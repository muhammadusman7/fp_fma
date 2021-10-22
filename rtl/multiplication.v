// Title: Booth 53-bit Mantissa Multiplier V 1.0 (No Changelog)
// Created: 
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that define a Modified Booth  radix-4 Multiplication
// Datapath is modified to perform single 53-bit, double 24-bit, or four 11-bit
// multiplications i each iteration.
//---------------------------------------------------------------------------
module multiplication (
    input       [63:0]  in_a0, in_b0, in_a1, in_b1,
    input       [63:0]  in_a2, in_b2, in_a3, in_b3,
    input       [63:0]  in_c0, in_c1, in_c2, in_c3,
    input       [1:0]   mode,       // 11 (DP Datapath), 10 (SP Datapath), 01 (HP Datapath)
    input       [1:0]   precision,  // 11 (Double), 10 (Single), 01 (Half)
    input       [1:0]   op,         // 11 (FMA), 10 (Add), 01 (Sub), 00 (Mul)
    output reg  [105:0] p0, p1,
    output      [12:0]  exp_out0, exp_out1, exp_out2, exp_out3,
    output      [12:0]  exp_c0, exp_c1, exp_c2, exp_c3,
    output      [12:0]  exp_diff0, exp_diff1, exp_diff2, exp_diff3,
    output      [3:0]   sign_out, uf_out, of_out, inf_out, z_out, NaN_out, norm_out,
    output      [3:0]   sign_c, inf_c, z_c, NaN_c, norm_c,
    output      [158:0] alignSft,
    output      [3:0]   isshft,
    output      [3:0]   isSat
);

    wire [105:0] m_p0, m_p1;
    wire [11:0] sign;
    wire [10:0] exp [11:0];
    wire [52:0] mantissa [11:0];
    wire [11:0] is_zero;
    wire [11:0] is_norm;
    wire [11:0] is_inf;
    wire [11:0] is_NaN;
    wire [7:0]  shftamt [3:0];
    wire [3:0]  sign_out_c;
    wire        isFMA, isSub, isMul;
    reg  [52:0] multiplier, multiplicand, addened;
    assign isFMA = op == 2'b11;
    assign isMul = op == 2'b00;
    assign isSub = op == 2'b01;
    assign sign_c = isSub ? ~sign_out_c : sign_out_c;
    // 3 Operands (Always enable)
    operand operand_a0( .in(in_a0), .precision(precision), .en(1'b1), .sign(sign[0]), .exp(exp[0]), .mantissa(mantissa[0]), 
        .is_zero(is_zero[0]), .is_norm(is_norm[0]), .is_inf(is_inf[0]), .is_NaN(is_NaN[0]) );
    operand operand_b0( .in(in_b0), .precision(precision), .en(1'b1), .sign(sign[1]), .exp(exp[1]), .mantissa(mantissa[1]), 
        .is_zero(is_zero[1]), .is_norm(is_norm[1]), .is_inf(is_inf[1]), .is_NaN(is_NaN[1]) );
    operand operand_c0( .in(isMul ? 64'b0 : in_c0), .precision(precision), .en(1'b1), .sign(sign[2]), .exp(exp[2]), .mantissa(mantissa[2]), 
        .is_zero(is_zero[2]), .is_norm(is_norm[2]), .is_inf(is_inf[2]), .is_NaN(is_NaN[2]) );
    assign sign_out_c[0] = sign[2]; assign inf_c[0] = is_inf[2]; assign z_c[0] = is_zero[2]; assign  NaN_c[0] = is_NaN[2];
    assign  norm_c[0] =is_norm[2];

    // 3 Operands (enable only when mode 10|01 & precision = D or S or H)
    wire en1 = (mode == 2'b10 || mode == 2'b01);
    operand operand_a1( .in(in_a1), .precision(precision), .en(en1), .sign(sign[3]), .exp(exp[3]), .mantissa(mantissa[3]), 
        .is_zero(is_zero[3]), .is_norm(is_norm[3]), .is_inf(is_inf[3]), .is_NaN(is_NaN[3]) );
    operand operand_b1( .in(in_b1), .precision(precision), .en(en1), .sign(sign[4]), .exp(exp[4]), .mantissa(mantissa[4]), 
        .is_zero(is_zero[4]), .is_norm(is_norm[4]), .is_inf(is_inf[4]), .is_NaN(is_NaN[4]) );
    operand operand_c1( .in(isMul ? 64'b0 : in_c1), .precision(precision), .en(en1), .sign(sign[5]), .exp(exp[5]), .mantissa(mantissa[5]), 
        .is_zero(is_zero[5]), .is_norm(is_norm[5]), .is_inf(is_inf[5]), .is_NaN(is_NaN[5]) );
    assign sign_out_c[1] = sign[5]; assign inf_c[1] = is_inf[5]; assign z_c[1] = is_zero[5]; assign  NaN_c[1] = is_NaN[5];
    assign  norm_c[1] =is_norm[5];
    // 3  Operands (enable only when mode 01 & precision = D or S or H)
    wire en2 = mode == 2'b01;
    operand operand_a2( .in(in_a2), .precision(precision), .en(en2), .sign(sign[6]), .exp(exp[6]), .mantissa(mantissa[6]), 
        .is_zero(is_zero[6]), .is_norm(is_norm[6]), .is_inf(is_inf[6]), .is_NaN(is_NaN[6]) );
    operand operand_b2( .in(in_b2), .precision(precision), .en(en2), .sign(sign[7]), .exp(exp[7]), .mantissa(mantissa[7]), 
        .is_zero(is_zero[7]), .is_norm(is_norm[7]), .is_inf(is_inf[7]), .is_NaN(is_NaN[7]) );
    operand operand_c2( .in(isMul ? 64'b0 : in_c2), .precision(precision), .en(en2), .sign(sign[8]), .exp(exp[8]), .mantissa(mantissa[8]), 
        .is_zero(is_zero[8]), .is_norm(is_norm[8]), .is_inf(is_inf[8]), .is_NaN(is_NaN[8]) );
    assign sign_out_c[2] = sign[8]; assign inf_c[2] = is_inf[8]; assign z_c[2] = is_zero[8]; assign  NaN_c[2] = is_NaN[8];
    assign  norm_c[2] =is_norm[8];
    // 3 Operands (enable only when mode 01 & precision = D or S or H)
    operand operand_a3( .in(in_a3), .precision(precision), .en(en2), .sign(sign[9]), .exp(exp[9]), .mantissa(mantissa[9]), 
        .is_zero(is_zero[9]), .is_norm(is_norm[9]), .is_inf(is_inf[9]), .is_NaN(is_NaN[9]) );
    operand operand_b3( .in(in_b3), .precision(precision), .en(en2), .sign(sign[10]), .exp(exp[10]), .mantissa(mantissa[10]), 
        .is_zero(is_zero[10]), .is_norm(is_norm[10]), .is_inf(is_inf[10]), .is_NaN(is_NaN[10]) );
    operand operand_c3( .in(isMul ? 64'b0 : in_c3), .precision(precision), .en(en2), .sign(sign[11]), .exp(exp[11]), .mantissa(mantissa[11]), 
        .is_zero(is_zero[11]), .is_norm(is_norm[11]), .is_inf(is_inf[11]), .is_NaN(is_NaN[11]) );
    assign sign_out_c[3] = sign[11]; assign inf_c[3] = is_inf[11]; assign z_c[3] = is_zero[11]; assign  NaN_c[3] = is_NaN[11];
    assign  norm_c[3] =is_norm[11];
    // Calculate Sign and Exponent and Alignment
    signExpMul se0(.a({is_zero[0], is_norm[0], is_inf[0], is_NaN[0], sign[0], exp[0]}), .b({is_zero[1], is_norm[1], is_inf[1], is_NaN[1], sign[1], exp[1]}), 
            .c(exp[2]), .en(1'b1), .mode(mode), .precision(precision), .isMul(isFMA | isMul), .out(exp_out0), .underflow(uf_out[0]), .overflow(of_out[0]), .inf(inf_out[0]), 
            .NaN(NaN_out[0]), .zero(z_out[0]), .sign(sign_out[0]), .isshft(isshft[0]), .shftamt(shftamt[0]), .expdiff(exp_diff0), .isSat(isSat[0]) );
    assign norm_out[0] = is_norm[0] && is_norm[1];
    signExpMul se1(.a({is_zero[3], is_norm[3], is_inf[3], is_NaN[3], sign[3], exp[3]}), .b({is_zero[4], is_norm[4], is_inf[4], is_NaN[4], sign[4], exp[4]}), 
            .c(exp[5]), .en(en1), .mode(mode), .precision(precision), .isMul(isFMA | isMul), .out(exp_out1), .underflow(uf_out[1]), .overflow(of_out[1]), .inf(inf_out[1]), 
            .NaN(NaN_out[1]), .zero(z_out[1]), .sign(sign_out[1]), .isshft(isshft[1]), .shftamt(shftamt[1]), .expdiff(exp_diff1), .isSat(isSat[1]) );
    assign norm_out[1] = is_norm[3] && is_norm[4];
    signExpMul se2(.a({is_zero[6], is_norm[6], is_inf[6], is_NaN[6], sign[6], exp[6]}), .b({is_zero[7], is_norm[7], is_inf[7], is_NaN[7], sign[7], exp[7]}), 
            .c(exp[8]), .en(en2), .mode(mode), .precision(precision), .isMul(isFMA | isMul), .out(exp_out2), .underflow(uf_out[2]), .overflow(of_out[2]), .inf(inf_out[2]), 
            .NaN(NaN_out[2]), .zero(z_out[2]), .sign(sign_out[2]), .isshft(isshft[2]), .shftamt(shftamt[2]), .expdiff(exp_diff2), .isSat(isSat[2]) );
    assign norm_out[2] = is_norm[6] && is_norm[7];
    signExpMul se3(.a({is_zero[9], is_norm[9], is_inf[9], is_NaN[9], sign[9], exp[9]}), .b({is_zero[10], is_norm[10], is_inf[10], is_NaN[10], sign[10], exp[10]}), 
            .c(exp[11]), .en(en2), .mode(mode), .precision(precision), .isMul(isFMA | isMul), .out(exp_out3), .underflow(uf_out[3]), .overflow(of_out[3]), .inf(inf_out[3]), 
            .NaN(NaN_out[3]), .zero(z_out[3]), .sign(sign_out[3]), .isshft(isshft[3]), .shftamt(shftamt[3]), .expdiff(exp_diff3), .isSat(isSat[3]) );
    assign norm_out[3] = is_norm[9] && is_norm[10];
    assign exp_c0 = isshft[0] ? exp_out0 : (exp[2] + shftamt[0]+1);
    assign exp_c1 = isshft[1] ? exp_out1 : (exp[5] + shftamt[1]+1);
    assign exp_c2 = isshft[2] ? exp_out2 : (exp[8] + shftamt[2]+1);
    assign exp_c3 = isshft[3] ? exp_out3 : (exp[11] + shftamt[3]+1);
    // Adder alignshift
    alignShift rshft(.in(addened), .shtamt0(shftamt[0]), .shtamt1(shftamt[1]), .shtamt2(shftamt[2]), .shtamt3(shftamt[3]), 
            .mode(mode), .out_shifted(alignSft[105:0]), .out_remainder(alignSft[158:106]) );
    // Multiplier
    multiplier53Booth #(.WIDTH(53)) mul53 (.multiplicand(multiplicand), .multiplier(multiplier), .mode(mode), .p0(m_p0), .p1(m_p1) );


    always @(*) begin
        case (mode)
            2'b01: begin  
                multiplier = {mantissa[9][52:42], 3'b0, mantissa[6][52:42], 3'b0, mantissa[3][52:42], 3'b0, mantissa[0][52:42]}; 
                multiplicand = {mantissa[10][52:42], 3'b0, mantissa[7][52:42], 3'b0, mantissa[4][52:42], 3'b0, mantissa[1][52:42]}; 
                addened = {mantissa[11][52:42], 3'b0, mantissa[8][52:42], 3'b0, mantissa[5][52:42], 3'b0, mantissa[2][52:42]}; 
                p0 = (isFMA | isMul) ? m_p0 : {mantissa[9][52:31], 6'b0, mantissa[6][52:31], 6'b0, mantissa[3][52:31], 6'b0, mantissa[0][52:31]};
                p1 = (isFMA | isMul) ? m_p1 : 106'b0;
            end 
            2'b10: begin 
                multiplier = {mantissa[3][52:29], 5'b0, mantissa[0][52:29]}; 
                multiplicand = {mantissa[4][52:29], 5'b0, mantissa[1][52:29]}; 
                addened = {mantissa[5][52:29], 5'b0, mantissa[2][52:29]};
                p0 = (isFMA | isMul) ? m_p0 : {mantissa[3][52:5], 10'b0, mantissa[0][52:5]};
                p1 = (isFMA | isMul) ? m_p1 : 106'b0; 
            end 
            2'b11: begin  
                multiplier = mantissa[0]; 
                multiplicand = mantissa[1]; 
                addened = mantissa[2]; 
                p0 = (isFMA | isMul) ? m_p0 : {mantissa[0], 53'b0};
                p1 = (isFMA | isMul) ? m_p1 : 106'b0;
            end 
            default: begin
                multiplier = mantissa[0]; 
                multiplicand = mantissa[1]; 
                addened = mantissa[2]; 
                p0 = (isFMA | isMul) ? m_p0 : {mantissa[0], 53'b0};
                p1 = (isFMA | isMul) ? m_p1 : 106'b0;
            end
        endcase
    end
    
endmodule