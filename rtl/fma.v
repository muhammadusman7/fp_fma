// Title: Fused Multiply Add V 1.0 (No Changelog)
// Created: Septmeber 29, 2021
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that define a FMA Operation, it is a 3 stage pipline
// Multiplication is performed in 1st cycle, addition is perfomed in 2nd stage
// normalization and rounding, final output is calculated in 3rd Cycle
//---------------------------------------------------------------------------
module fma #(parameter WIDTH = 64)(
    input       clk, rst,
    input       [WIDTH-1:0] in_a0, in_a1, in_a2, in_a3,       // Multiplier
    input       [WIDTH-1:0] in_b0, in_b1, in_b2, in_b3,       // Multiplicand / Addened0
    input       [WIDTH-1:0] in_c0, in_c1, in_c2, in_c3,       // Addened / Addened1
    input       [5:0]       u_a0, u_a1, u_a2, u_a3,     // Input certainty of A, B and C
    input       [5:0]       u_b0, u_b1, u_b2, u_b3,
    input       [5:0]       u_c0, u_c1, u_c2, u_c3,
    input       [1:0]       mode,           // 11 (DP Datapath), 10 (SP Datapath), 01 (HP Datapath)
    input       [1:0]       precision,      // 11 (Double), 10 (Single), 01(Half)
    input       [1:0]       op,             // 11 (FMA), 10 (Add), 01 (Sub), 00 (Mul)
    output      [WIDTH-1:0] out0, out1, out2, out3,         // Output
    output      [3:0]       ufout, ofout, infout, zout, NaNout,
    output      [5:0]       uo0, uo1, uo2, uo3
);

    wire  [105:0] p0, p1;
    wire  [12:0]  exp_mul0, exp_mul1, exp_mul2, exp_mul3;
    wire  [12:0]  exp_c0, exp_c1, exp_c2, exp_c3;
    wire  [3:0]   sign_mul, uf_mul, of_mul, inf_mul, z_mul, NaN_mul, norm_mul;
    wire  [3:0]   sign_c, inf_c, z_c, NaN_c, norm_c;
    wire  [158:0] alignSft;
    wire  [3:0]   isshft;

    wire  [105:0] sum;
    wire  [12:0]  exp_s0, exp_s1, exp_s2, exp_s3;
    wire  [3:0]   sign_sum, cout_sum, uf_sum, of_sum, inf_sum, z_sum, NaN_sum;
    wire  [6:0]   lop0, lop1, lop2, lop3;
    wire  [12:0]  exp_diff0, exp_diff1, exp_diff2, exp_diff3; // Diff of exp_mul, exp_c, for certainty
    wire  [3:0]   isSat;

    wire  [WIDTH-1:0] out_0, out_1, out_2, out_3;
    wire  [3:0]       uf_out, of_out, inf_out, z_out, NaN_out;

    // Pipeline Register 1
    wire [WIDTH-1:0] m_a0, m_a1, m_a2, m_a3;
    wire [WIDTH-1:0] m_b0, m_b1, m_b2, m_b3;
    wire [WIDTH-1:0] m_c0, m_c1, m_c2, m_c3;
    wire [1:0]       m_mode, m_precision, m_op;
    wire  [5:0]   ua0, ua1, ua2, ua3, ub0, ub1, ub2, ub3, uc0, uc1, uc2, uc3;

    register #(.WIDTH(6)) regm(.clk(clk), .rst(rst), .in({mode, precision, op}), .out({m_mode, m_precision, m_op}));
    register #(.WIDTH(72)) regc1(.clk(clk), .rst(rst), .in({u_a0, u_a1, u_a2, u_a3, u_b0, u_b1, u_b2, u_b3, u_c0, u_c1, 
        u_c2, u_c3}), .out({ua0, ua1, ua2, ua3, ub0, ub1, ub2, ub3, uc0, uc1, uc2, uc3}));
    register #(.WIDTH(192)) regm0(.clk(clk), .rst(rst), .in({in_a0, in_b0, in_c0}), .out({m_a0, m_b0, m_c0}));
    register #(.WIDTH(192)) regm1(.clk(clk), .rst(rst), .in({in_a1, in_b1, in_c1}), .out({m_a1, m_b1, m_c1}));
    register #(.WIDTH(192)) regm2(.clk(clk), .rst(rst), .in({in_a2, in_b2, in_c2}), .out({m_a2, m_b2, m_c2}));
    register #(.WIDTH(192)) regm3(.clk(clk), .rst(rst), .in({in_a3, in_b3, in_c3}), .out({m_a3, m_b3, m_c3}));

    multiplication mul( .in_a0(m_a0), .in_a1(m_a1), .in_a2(m_a2), .in_a3(m_a3), .in_b0(m_b0), .in_b1(m_b1), 
            .in_b2(m_b2), .in_b3(m_b3), .in_c0(m_c0), .in_c1(m_c1), .in_c2(m_c2), .in_c3(m_c3), .mode(m_mode), 
            .precision(m_precision), .op(m_op), .p0(p0), .p1(p1), .exp_out0(exp_mul0), .exp_out1(exp_mul1), .exp_out2(exp_mul2), 
            .exp_out3(exp_mul3), .exp_c0(exp_c0), .exp_c1(exp_c1), .exp_c2(exp_c2), .exp_c3(exp_c3), .exp_diff0(exp_diff0),
            .exp_diff1(exp_diff1), .exp_diff2(exp_diff2), .exp_diff3(exp_diff3), .sign_out(sign_mul), .uf_out(uf_mul), 
            .of_out(of_mul), .inf_out(inf_mul), .z_out(z_mul), .NaN_out(NaN_mul), .norm_out(norm_mul), .sign_c(sign_c), 
            .inf_c(inf_c), .z_c(z_c), .NaN_c(NaN_c), .norm_c(norm_c), .alignSft(alignSft), .isshft(isshft), .isSat(isSat) );
    
    wire  [5:0]   mrc_0, mrc_1, mrc_2, mrc_3;       // Min Relative Certainty
    wire  [13:0]  cer_00, cer_01, cer_02, cer_03;
    wire  [3:0]   cer_1; 
    wire  [5:0]   marc_0, marc_1, marc_2, marc_3;   // Min Absolute Relative Certainty
    wire  [1:0]   cermux [3:0];
    wire  [12:0]  cer_20, cer_21, cer_22, cer_23;
    wire  [12:0]  pr;    // precision;
    // Minmum Relative Certainty
    assign mrc_0 = ua0 > ub0 ? ub0 : ua0;    assign mrc_1 = ua1 > ub1 ? ub1 : ua1;
    assign mrc_2 = ua2 > ub2 ? ub2 : ua2;    assign mrc_3 = ua3 > ub3 ? ub3 : ua3;
    // Minimum Absolute Certainty
    assign cer_00 = uc0 + $signed(exp_diff0) + 1'b1;    assign cer_01 = uc1 + $signed(exp_diff1) + 1'b1;
    assign cer_02 = uc2 + $signed(exp_diff2) + 1'b1;    assign cer_03 = uc3 + $signed(exp_diff3) + 1'b1;
    assign cer_1[0] = $signed(cer_00) > mrc_0;    assign cer_1[1] = $signed(cer_01) > mrc_1;
    assign cer_1[2] = $signed(cer_02) > mrc_2;    assign cer_1[3] = $signed(cer_03) > mrc_3;
    assign marc_0 = cer_1[0] ? uc0 : mrc_0;    assign marc_1 = cer_1[1] ? uc1 : mrc_1;
    assign marc_2 = cer_1[2] ? uc2 : mrc_2;    assign marc_3 = cer_1[3] ? uc3 : mrc_3;
    assign pr = mode == 2'b01 ? 13'd12 : mode ==2'b10 ? 13'd25 : 13'd54;
    assign cermux[0] = {cer_1[0], isshft[0]};
    assign cer_20 = cermux[0] == 2'b00 ? 13'b0 : cermux[0] == 2'b01 ? exp_diff0 : cermux[0] == 2'b10 ? pr : {12'd0, isSat[0]};
    assign cermux[1] = {cer_1[1], isshft[1]};
    assign cer_21 = cermux[1] == 2'b00 ? 13'b0 : cermux[1] == 2'b01 ? exp_diff1 : cermux[1] == 2'b10 ? pr : {12'd0, isSat[1]};
    assign cermux[2] = {cer_1[2], isshft[2]};
    assign cer_22 = cermux[2] == 2'b00 ? 13'b0 : cermux[2] == 2'b01 ? exp_diff2 : cermux[2] == 2'b10 ? pr : {12'd0, isSat[2]};
    assign cermux[3] = {cer_1[3], isshft[3]};
    assign cer_23 = cermux[3] == 2'b00 ? 13'b0 : cermux[3] == 2'b01 ? exp_diff3 : cermux[3] == 2'b10 ? pr : {12'd0, isSat[3]};


    
    // Pipeline Register 2
    wire  [105:0] s_p0, s_p1;
    wire  [12:0]  s_exp_mul0, s_exp_mul1, s_exp_mul2, s_exp_mul3;
    wire  [12:0]  s_exp_c0, s_exp_c1, s_exp_c2, s_exp_c3;
    wire  [3:0]   s_sign_mul, s_uf_mul, s_of_mul, s_inf_mul, s_z_mul, s_NaN_mul, s_norm_mul;
    wire  [3:0]   s_sign_c, s_inf_c, s_z_c, s_NaN_c, s_norm_c;
    wire  [158:0] s_alignSft;
    wire  [3:0]   s_isshft;
    wire  [1:0]   s_mode, s_precision;
    wire  [5:0]   marc0, marc1, marc2, marc3;
    wire  [12:0]  cer20, cer21, cer22, cer23;
    
    register #(.WIDTH(375)) regs(.clk(clk), .rst(rst), .in({p0, p1, alignSft, m_mode, m_precision}), .out({s_p0, s_p1,
        s_alignSft, s_mode, s_precision}));
    register #(.WIDTH(76)) regc2(.clk(clk), .rst(rst), .in({cer_20, cer_21, cer_22, cer_23, marc_0, marc_1, marc_2, marc_3}), 
        .out({cer20, cer21, cer22, cer23, marc0, marc1, marc2, marc3}));
    register #(.WIDTH(39)) regs0(.clk(clk), .rst(rst), .in({exp_mul0, exp_c0, sign_mul[0], uf_mul[0], of_mul[0], inf_mul[0],
        z_mul[0], NaN_mul[0], norm_mul[0], sign_c[0], inf_c[0], z_c[0], NaN_c[0], norm_c[0], isshft[0]}), .out({s_exp_mul0, 
        s_exp_c0, s_sign_mul[0], s_uf_mul[0], s_of_mul[0], s_inf_mul[0], s_z_mul[0], s_NaN_mul[0], s_norm_mul[0], s_sign_c[0],
        s_inf_c[0], s_z_c[0], s_NaN_c[0], s_norm_c[0], s_isshft[0]}));
    register #(.WIDTH(39)) regs1(.clk(clk), .rst(rst), .in({exp_mul1, exp_c1, sign_mul[1], uf_mul[1], of_mul[1], inf_mul[1],
        z_mul[1], NaN_mul[1], norm_mul[1], sign_c[1], inf_c[1], z_c[1], NaN_c[1], norm_c[1], isshft[1]}), .out({s_exp_mul1, 
        s_exp_c1, s_sign_mul[1], s_uf_mul[1], s_of_mul[1], s_inf_mul[1], s_z_mul[1], s_NaN_mul[1], s_norm_mul[1], s_sign_c[1],
        s_inf_c[1], s_z_c[1], s_NaN_c[1], s_norm_c[1], s_isshft[1]}));
    register #(.WIDTH(39)) regs2(.clk(clk), .rst(rst), .in({exp_mul2, exp_c2, sign_mul[2], uf_mul[2], of_mul[2], inf_mul[2],
        z_mul[2], NaN_mul[2], norm_mul[2], sign_c[2], inf_c[2], z_c[2], NaN_c[2], norm_c[2], isshft[2]}), .out({s_exp_mul2, 
        s_exp_c2, s_sign_mul[2], s_uf_mul[2], s_of_mul[2], s_inf_mul[2], s_z_mul[2], s_NaN_mul[2], s_norm_mul[2], s_sign_c[2],
        s_inf_c[2], s_z_c[2], s_NaN_c[2], s_norm_c[2], s_isshft[2]}));
    register #(.WIDTH(39)) regs3(.clk(clk), .rst(rst), .in({exp_mul3, exp_c3, sign_mul[3], uf_mul[3], of_mul[3], inf_mul[3],
        z_mul[3], NaN_mul[3], norm_mul[3], sign_c[3], inf_c[3], z_c[3], NaN_c[3], norm_c[3], isshft[3]}), .out({s_exp_mul3, 
        s_exp_c3, s_sign_mul[3], s_uf_mul[3], s_of_mul[3], s_inf_mul[3], s_z_mul[3], s_NaN_mul[3], s_norm_mul[3], s_sign_c[3],
        s_inf_c[3], s_z_c[3], s_NaN_c[3], s_norm_c[3], s_isshft[3]}));

    addition add( .mode(s_mode), .precision(s_precision), .p0(s_p0), .p1(s_p1), .exp_m0(s_exp_mul0), .exp_m1(s_exp_mul1), .exp_m2(s_exp_mul2), 
            .exp_m3(s_exp_mul3), .exp_c0(s_exp_c0), .exp_c1(s_exp_c1), .exp_c2(s_exp_c2), .exp_c3(s_exp_c3), .sign_mul(s_sign_mul), 
            .uf_mul(s_uf_mul), .of_mul(s_of_mul), .inf_mul(s_inf_mul), .z_mul(s_z_mul), .NaN_mul(s_NaN_mul), .norm_mul(s_norm_mul), 
            .sign_c(s_sign_c), .inf_c(s_inf_c), .z_c(s_z_c), .NaN_c(s_NaN_c), .norm_c(s_norm_c), .alignShft(s_alignSft), .isshft(s_isshft), 
            .out(sum), .exp_s0(exp_s0), .exp_s1(exp_s1), .exp_s2(exp_s2), .exp_s3(exp_s3), .sign_out(sign_sum), .c_out(cout_sum),
            .uf_out(uf_sum), .of_out(of_sum), .inf_out(inf_sum), .z_out(z_sum), .NaN_out(NaN_sum), .lop_0(lop0), .lop_1(lop1), 
            .lop_2(lop2), .lop_3(lop3) );

    wire [13:0] cer_30, cer_31, cer_32, cer_33;
    assign cer_30 = cer20 + marc0;    assign cer_31 = cer21 + marc1;
    assign cer_32 = cer22 + marc2;    assign cer_33 = cer23 + marc3;

    // Pipeline Register 3
    wire  [105:0] n_sum;
    wire  [12:0]  n_exp_s0, n_exp_s1, n_exp_s2, n_exp_s3;
    wire  [3:0]   n_sign_sum, n_cout_sum, n_uf_sum, n_of_sum, n_inf_sum, n_z_sum, n_NaN_sum;
    wire  [6:0]   n_lop0, n_lop1, n_lop2, n_lop3;
    wire  [1:0]   n_mode, n_precision;
    wire  [13:0] cer30, cer31, cer32, cer33;

    register #(.WIDTH(110)) regn(.clk(clk), .rst(rst), .in({sum, s_mode, s_precision}), .out({n_sum, n_mode, n_precision}));
    register #(.WIDTH(56)) regc3(.clk(clk), .rst(rst), .in({cer_30, cer_31, cer_32, cer_33}), .out({cer30, cer31, cer32, cer33}));
    register #(.WIDTH(27)) regn0(.clk(clk), .rst(rst), .in({lop0, exp_s0, sign_sum[0], cout_sum[0], uf_sum[0], of_sum[0], 
        inf_sum[0], z_sum[0], NaN_sum[0]}), .out({n_lop0, n_exp_s0, n_sign_sum[0], n_cout_sum[0], n_uf_sum[0], n_of_sum[0], 
        n_inf_sum[0], n_z_sum[0], n_NaN_sum[0]}));
    register #(.WIDTH(27)) regn1(.clk(clk), .rst(rst), .in({lop1, exp_s1, sign_sum[1], cout_sum[1], uf_sum[1], of_sum[1], 
        inf_sum[1], z_sum[1], NaN_sum[1]}), .out({n_lop1, n_exp_s1, n_sign_sum[1], n_cout_sum[1], n_uf_sum[1], n_of_sum[1], 
        n_inf_sum[1], n_z_sum[1], n_NaN_sum[1]}));
    register #(.WIDTH(27)) regn2(.clk(clk), .rst(rst), .in({lop2, exp_s2, sign_sum[2], cout_sum[2], uf_sum[2], of_sum[2], 
        inf_sum[2], z_sum[2], NaN_sum[2]}), .out({n_lop2, n_exp_s2, n_sign_sum[2], n_cout_sum[2], n_uf_sum[2], n_of_sum[2], 
        n_inf_sum[2], n_z_sum[2], n_NaN_sum[2]}));
    register #(.WIDTH(27)) regn3(.clk(clk), .rst(rst), .in({lop3, exp_s3, sign_sum[3], cout_sum[3], uf_sum[3], of_sum[3], 
        inf_sum[3], z_sum[3], NaN_sum[3]}), .out({n_lop3, n_exp_s3, n_sign_sum[3], n_cout_sum[3], n_uf_sum[3], n_of_sum[3], 
        n_inf_sum[3], n_z_sum[3], n_NaN_sum[3]}));

    wire [3:0] roundof; // Rounding Overflow
    normnround nnround( .mode(n_mode), .precision(n_precision), .sum(n_sum), .lop0(n_lop0), .lop1(n_lop1), .lop2(n_lop2), .lop3(n_lop3), 
            .exp_s0(n_exp_s0), .exp_s1(n_exp_s1), .exp_s2(n_exp_s2), .exp_s3(n_exp_s3), .sign_sum(n_sign_sum), .c_outsum(n_cout_sum),
            .uf_sum(n_uf_sum), .of_sum(n_of_sum), .inf_sum(n_inf_sum), .z_sum(n_z_sum), .NaN_sum(n_NaN_sum), .out0(out_0), .out1(out_1),
            .out2(out_2), .out3(out_3), .uf_out(uf_out), .of_out(of_out), .inf_out(inf_out), .z_out(z_out), .NaN_out(NaN_out), .cout_round(roundof));
    
    wire [5:0] un_0, un_1, un_2, un_3;
    wire [5:0] cer_40, cer_41, cer_42, cer_43;
    wire [5:0] uo_0, uo_1, uo_2, uo_3;
    wire [5:0] prec;
    assign prec = mode == 2'b01 ? 6'd11 : mode == 2'b10 ? 6'd24 : 6'd53;
    assign un_0 = cer30 - n_lop0;    assign un_1 = cer31 - n_lop1;
    assign un_2 = cer32 - n_lop2;    assign un_3 = cer33 - n_lop3;
    assign cer_40 = un_0 > prec ? prec : un_0;    assign cer_41 = un_1 > prec ? prec : un_1;
    assign cer_42 = un_2 > prec ? prec : un_2;    assign cer_43 = un_3 > prec ? prec : un_3;
    assign uo_0 = roundof[0] ? (cer_40-1'b1) : cer_40;    assign uo_1 = roundof[1] ? (cer_41-1'b1) : cer_41;
    assign uo_2 = roundof[2] ? (cer_42-1'b1) : cer_42;    assign uo_3 = roundof[3] ? (cer_43-1'b1) : cer_43;
    
    // Pipeline Register 4
    wire      [1:0]   o_mode, o_precision;
    register #(.WIDTH(24)) rego(.clk(clk), .rst(rst), .in({n_mode, n_precision, uf_out, of_out, inf_out, z_out, NaN_out}), 
        .out({o_mode, o_precision, ufout, ofout, infout, zout, NaNout}));
    register #(.WIDTH(24)) regc4(.clk(clk), .rst(rst), .in({uo_0, uo_1, uo_2, uo_3}), .out({uo0, uo1, uo2, uo3}));
    register #(.WIDTH(64)) rego0(.clk(clk), .rst(rst), .in(out_0), .out(out0));
    register #(.WIDTH(64)) rego1(.clk(clk), .rst(rst), .in(out_1), .out(out1));
    register #(.WIDTH(64)) rego2(.clk(clk), .rst(rst), .in(out_2), .out(out2));
    register #(.WIDTH(64)) rego3(.clk(clk), .rst(rst), .in(out_3), .out(out3));
    
endmodule