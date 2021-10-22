// Title: Addition V 1.0 (No Changelog)
// Created: Septmeber 24, 2021
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that perform addition of the FMA unit, it is second
// stage of the pipline.
//
//---------------------------------------------------------------------------
module addition (
    input       [1:0]       mode, precision,
    input       [105:0]     p0, p1,
    input       [12:0]      exp_m0, exp_m1, exp_m2, exp_m3,  // exp_out of multiplication
    input       [12:0]      exp_c0, exp_c1, exp_c2, exp_c3,  // exp_out of operand
    input       [3:0]       sign_mul, uf_mul, of_mul, inf_mul, z_mul, NaN_mul, norm_mul, // xx_out of multiplication
    input       [3:0]       sign_c, inf_c, z_c, NaN_c, norm_c,
    input       [158:0]     alignShft,
    input       [3:0]       isshft,
    output      [105:0]     out,
    output      [12:0]      exp_s0, exp_s1, exp_s2, exp_s3,
    output reg  [3:0]       sign_out, 
    output      [3:0]       c_out, uf_out, of_out, inf_out, z_out, NaN_out,
    output      [6:0]       lop_0, lop_1, lop_2, lop_3
);

    wire    [105:0] sum_3t2, carry_3t2, sum_adder;
    reg     [105:0] add0, add1;
    wire    cin_add = 1'b0;
    wire    cout;
    wire    [6:0] lo_pos[6:0];
    wire    [106:0] sum_add, sum_add_n;
    reg     [106:0] sum;
    reg     [159:0] sum_out;
    wire    [3:0] op;
    wire    [105:0] alignShft_n;
    reg     [105:0] aligned;

        
    // Output
    assign out = sum_out[105:0];

    wire en1 = (mode == 2'b10 || mode == 2'b01);
    wire en2 = mode == 2'b01;
    
    // Operation Calculation
    assign op[0] = sign_mul[0]^sign_c[0];
    assign op[1] = sign_mul[1]^sign_c[1];
    assign op[2] = sign_mul[2]^sign_c[2];
    assign op[3] = sign_mul[3]^sign_c[3];
    assign alignShft_n = ~alignShft[105:0];
    
    // 3:2 compression
    comp3to2 comp(.in_a(p0), .in_b(p1), .in_c(aligned[105:0]), .sum(sum_3t2), .carry(carry_3t2) );

    // Addition
    adder #(.WIDTH(106), .CWIDTH(29)) add(.in_a(add0), .in_b(add1), .c_in(cin_add), .c_out(cout), .s(sum_adder[105:0]) );
    assign sum_add[106] = carry_3t2[105] ^ cout;
    assign sum_add[48] = mode == 2'b10 ? (carry_3t2[47] ^ sum_adder[48]) : sum_adder[48];
    assign sum_add[22] = mode == 2'b01 ? (carry_3t2[21] ^ sum_adder[22]) : sum_adder[22];
    assign sum_add[50] = mode == 2'b01 ? (carry_3t2[49] ^ sum_adder[50]) : sum_adder[50];
    assign sum_add[78] = mode == 2'b01 ? (carry_3t2[77] ^ sum_adder[78]) : sum_adder[78];
    assign sum_add[21:0] = sum_adder[21:0]; assign sum_add[47:23] = sum_adder[47:23];
    assign sum_add[49] = sum_adder[49]; assign sum_add[77:51] = sum_adder[77:51];
    assign sum_add[105:79] = sum_adder[105:79];
    assign c_out[0] = (mode == 2'b01 ? sum_add[22] : mode == 2'b10 ?  sum_add[48] : sum_add[106]) & ~op[0] & isshft[0];
    assign c_out[1] = (mode == 2'b01 ? sum_add[50] : mode == 2'b10 ?  sum_add[106] : 1'b0) & ~op[1] & isshft[1];
    assign c_out[2] = (mode == 2'b01 ? sum_add[78] : 1'b0) & ~op[2] & isshft[2];
    assign c_out[3] = (mode == 2'b01 ? sum_add[106] : 1'b0) & ~op[3] & isshft[3];

    assign sum_add_n = ~sum_add;

    // Exponent
    expAdd expadd0( .a({z_mul[0], norm_mul[0], inf_mul[0], NaN_mul[0], exp_m0}), .b({z_c[0], norm_c[0], inf_c[0], NaN_c[0], exp_c0}),
            .en(1'b1), .precision(precision), .mode(mode), .isshft(isshft[0]), .out(exp_s0), .underflow(uf_out[0]), .overflow(of_out[0]),
            .inf(inf_out[0]), .NaN(NaN_out[0]), .zero(z_out[0]) );
    expAdd expadd1( .a({z_mul[1], norm_mul[1], inf_mul[1], NaN_mul[1], exp_m1}), .b({z_c[1], norm_c[1], inf_c[1], NaN_c[1], exp_c1}),
            .en(en1), .precision(precision), .mode(mode), .isshft(isshft[1]), .out(exp_s1), .underflow(uf_out[1]), .overflow(of_out[1]),
            .inf(inf_out[1]), .NaN(NaN_out[1]), .zero(z_out[1]) );
    expAdd expadd2( .a({z_mul[2], norm_mul[2], inf_mul[2], NaN_mul[2], exp_m2}), .b({z_c[2], norm_c[2], inf_c[2], NaN_c[2], exp_c2}),
            .en(en2), .precision(precision), .mode(mode), .isshft(isshft[2]), .out(exp_s2), .underflow(uf_out[2]), .overflow(of_out[2]),
            .inf(inf_out[2]), .NaN(NaN_out[2]), .zero(z_out[2]) );
    expAdd expadd3( .a({z_mul[3], norm_mul[3], inf_mul[3], NaN_mul[3], exp_m3}), .b({z_c[3], norm_c[3], inf_c[3], NaN_c[3], exp_c3}),
            .en(en2), .precision(precision), .mode(mode), .isshft(isshft[3]), .out(exp_s3), .underflow(uf_out[3]), .overflow(of_out[3]),
            .inf(inf_out[3]), .NaN(NaN_out[3]), .zero(z_out[3]) );
    // LoD
    lod LoD(.in(sum_out[105:0]), .lo_posdp(lo_pos[0]), .lo_possp0(lo_pos[1]), .lo_possp1(lo_pos[2]), .lo_poshp0(lo_pos[3]), 
            .lo_poshp1(lo_pos[4]), .lo_poshp2(lo_pos[5]), .lo_poshp3(lo_pos[6]) );
    assign lop_0 = mode == 2'b01 ? lo_pos[3] : mode == 2'b10 ? lo_pos[1] : lo_pos[0];
    assign lop_1 = mode == 2'b01 ? lo_pos[4] : mode == 2'b10 ? lo_pos[2] : 7'b0;
    assign lop_2 = mode == 2'b01 ? lo_pos[5] : 7'b0;
    assign lop_3 = mode == 2'b01 ? lo_pos[6] : 7'b0;

    


    always @(*) begin
        sum[106] = sum_add[106];
        case (mode)
            2'b01: begin  
                aligned[21:0] = op[0] ? alignShft_n[21:0] : alignShft[21:0];
                aligned[49:28] = op[1] ? alignShft_n[49:28] : alignShft[49:28];    aligned[27:22] = alignShft[27:22];
                aligned[77:56] = op[2] ? alignShft_n[77:56] : alignShft[77:56];    aligned[55:50] = alignShft[55:50];
                aligned[105:84] = op[3] ? alignShft_n[105:84] : alignShft[105:84]; aligned[83:78] = alignShft[83:78];
                sum[21:0] = op[0] ? ((sum_add[22] & isshft[0]) ? sum_add[21:0] : (sum_add_n[21:0]+1)) : sum_add[21:0];
                sum[49:28] = op[1] ? ((sum_add[50] & isshft[1]) ? sum_add[49:28] : (sum_add_n[49:28]+1)) : sum_add[49:28];    sum[27:22] = sum_add[27:22];
                sum[77:56] = op[2] ? ((sum_add[78] & isshft[2])? sum_add[77:56] : (sum_add_n[77:56]+1)) : sum_add[77:56];    sum[55:50] = sum_add[55:50];
                sum[105:84] = op[3] ? ((sum_add[106] & isshft[3]) ? sum_add[105:84] : (sum_add_n[105:84]+1)) : sum_add[105:84]; sum[83:78] = sum_add[83:78];
                add0 = {sum_3t2[105:84], 6'b0, sum_3t2[77:56], 6'b0, sum_3t2[49:28], 6'b0, sum_3t2[21:0]}; // Add op to complete 2's comp
                add1 = {carry_3t2[104:84], op[3], 6'b0, carry_3t2[76:56], op[2], 6'b0, carry_3t2[48:28], op[1], 6'b0, carry_3t2[20:0], op[0]}; 
                sum_out [117:106] = alignShft[116:106] + (op[0] ? ((~isshft[0] & sum[22]) ? -1 : 0) : sum[22]); sum_out[119:118] = 2'b0; // Add carry of the sum to the remainder that is not shifted
                sum_out [131:120] = alignShft[130:120] + (op[1] ? ((~isshft[1] & sum[50]) ? -1 : 0) : sum[50]); sum_out[133:132] = 2'b0;
                sum_out [145:134] = alignShft[144:134] + (op[2] ? ((~isshft[2] & sum[78]) ? -1 : 0) : sum[78]); sum_out[147:146] = 2'b0;
                sum_out [159:148] = alignShft[158:148] + (op[3] ? ((~isshft[3] & sum[106]) ? -1 : 0) : sum[106]);
                if(~isshft[0]) begin     // exp_c > exp_m
                    sum_out[21:0] = {sum_out[117:106], sum[21:12]};
                    sign_out[0] = sign_c[0];
                end else if(c_out[0]) begin
                    sum_out[21:0] = {1'b1, sum[21:1]};
                    if(op[0]) begin
                        sign_out[0]  = sign_mul[0] ? sum[22] : ~sum[22];
                    end else begin
                        sign_out[0] = sign_mul[0] & sign_c[0];
                    end
                end else begin
                    sum_out[21:0] = sum[21:0];
                    if(op[0]) begin
                        sign_out[0]  = sign_mul[0] ? sum[22] : ~sum[22];
                    end else begin
                        sign_out[0] = sign_mul[0] & sign_c[0];
                    end
                end
                sum_out[27:22] = 6'b0;
                if(~isshft[1]) begin 
                    sum_out[49:28] = {sum_out[131:120], sum[49:40]};
                    sign_out[1] = sign_c[1];
                end else if(c_out[1]) begin
                    sum_out[49:28] = {1'b1, sum[49:29]};
                    if(op[1]) begin
                        sign_out[1]  = sign_mul[1] ? sum[50] : ~sum[50];
                    end else begin
                        sign_out[1] = sign_mul[1] & sign_c[1];
                    end
                end else begin
                    sum_out[49:28] = sum[49:28];
                    if(op[1]) begin
                        sign_out[1]  = sign_mul[1] ? sum[50] : ~sum[50];
                    end else begin
                        sign_out[1] = sign_mul[1] & sign_c[1];
                    end
                end
                sum_out[55:50] = 6'b0;
                if(~isshft[2]) begin 
                    sum_out[77:56] = {sum_out[145:134], sum[77:68]};
                    sign_out[2] = sign_c[2];
                end else if(c_out[2]) begin
                    sum_out[77:56] = {1'b1, sum[77:57]};
                    if(op[2]) begin
                        sign_out[2]  = sign_mul[2] ? sum[78] : ~sum[78];
                    end else begin
                        sign_out[2] = sign_mul[2] & sign_c[2];
                    end
                end else begin
                    sum_out[77:56] = sum[77:56];
                    if(op[2]) begin
                        sign_out[2]  = sign_mul[2] ? sum[78] : ~sum[78];
                    end else begin
                        sign_out[2] = sign_mul[2] & sign_c[2];
                    end
                end
                sum_out[83:78] = 6'b0;
                if(~isshft[3]) begin 
                    sum_out[105:84] = {sum_out[159:148], sum[105:96]};
                    sign_out[3] = sign_c[3];
                end else if(c_out[3]) begin
                    sum_out[105:84] = {1'b1, sum[105:85]};
                    if(op[3]) begin
                        sign_out[3]  = sign_mul[3] ? sum[106] : ~sum[106];
                    end else begin
                        sign_out[3] = sign_mul[3] & sign_c[3];
                    end
                end else begin
                    sum_out[105:84] = sum[105:84];
                    if(op[3]) begin
                        sign_out[3]  = sign_mul[3] ? sum[106] : ~sum[106];
                    end else begin
                        sign_out[3] = sign_mul[3] & sign_c[3];
                    end
                end
            end 
            2'b10: begin 
                aligned[47:0] = op[0] ? alignShft_n[47:0] : alignShft[47:0];
                aligned[105:58] = op[1] ? alignShft_n[105:58] : alignShft[105:58]; aligned[57:48] = alignShft[57:48];
                sum[47:0] = op[0] ? ((sum_add[48] & isshft[0]) ? sum_add[47:0] : (sum_add_n[47:0]+1)) : sum_add[47:0];
                sum[105:58] = op[1] ? ((sum_add[106] & isshft[1]) ? sum_add[105:58] : (sum_add_n[105:58]+1)) : sum_add[105:58]; sum[57:48] = sum_add[57:48];
                add0 = {sum_3t2[105:58], 10'b0, sum_3t2[47:0]}; 
                add1 = {carry_3t2[104:58], op[1], 10'b0, carry_3t2[46:0], op[0]}; 
                sum_out [130:106] = alignShft[129:106] + (op[0] ? ((~isshft[0] & sum[48]) ? -1 : 0) : sum[48]); sum_out[134:131] = 4'b0;
                sum_out [159:135] = alignShft[158:135] + (op[1] ? ((~isshft[1] & sum[106]) ? -1 : 0) : sum[106]); 
                if(~isshft[0]) begin     // exp_c > exp_m
                    sum_out[47:0] = {sum_out[130:106], sum[47:25]};
                    sign_out[0] = sign_c[0];
                end else if(c_out[0]) begin
                    sum_out[47:0] = {1'b1, sum[47:1]};
                    if(op[0]) begin
                        sign_out[0]  = sign_mul[0] ? sum[48] : ~sum[48];
                    end else begin
                        sign_out[0] = sign_mul[0] & sign_c[0];
                    end
                end else begin
                    sum_out[47:0] = sum[47:0];
                    if(op[0]) begin
                        sign_out[0]  = sign_mul[0] ? sum[48] : ~sum[48];
                    end else begin
                        sign_out[0] = sign_mul[0] & sign_c[0];
                    end
                end
                sum_out[57:48] = 10'b0;
                if(~isshft[1]) begin 
                    sum_out[105:58] = {sum_out[159:135], sum[105:83]};
                    sign_out[1] = sign_c[1];
                end else if(c_out[1]) begin
                    sum_out[105:58] = {1'b1, sum[105:59]};
                    if(op[1]) begin
                        sign_out[1]  = sign_mul[0] ? sum[106] : ~sum[106];
                    end else begin
                        sign_out[1] = sign_mul[1] & sign_c[1];
                    end
                end else begin
                    sum_out[105:58] = sum[105:58];
                    if(op[1]) begin
                        sign_out[1]  = sign_mul[1] ? sum[106] : ~sum[106];
                    end else begin
                        sign_out[1] = sign_mul[1] & sign_c[1];
                    end
                end
                sign_out[3:2] = 2'b0;
            end 
            2'b11: begin  
                aligned[105:0] = op[0] ? alignShft_n[105:0] : alignShft[105:0];
                sum[105:0] = op[0] ? ((sum_add[106] & isshft[0]) ? sum_add[105:0] : (sum_add_n[105:0]+1)) : sum_add[105:0];
                add0 = sum_3t2; 
                add1 = {carry_3t2[104:0], op[0]}; 
                sum_out [159:106] = alignShft[158:106] + (op[0] ? ((~isshft[0] & sum[106]) ? -1 : 0) : sum[106]);
                if(~isshft[0]) begin     // exp_c > exp_m
                    sum_out[105:0] = {sum_out[159:106], sum[105:54]};
                    sign_out[0] = sign_c[0];
                end else if(c_out[0]) begin
                    sum_out[105:0] = {1'b1, sum[105:1]};
                    if(op[0]) begin
                        sign_out[0]  = sign_mul[0] ? sum[106] : ~sum[106];
                    end else begin
                        sign_out[0] = sign_mul[0] & sign_c[0];
                    end
                end else begin
                    sum_out[105:0] = sum[105:0];
                    if(op[0]) begin
                        sign_out[0]  = sign_mul[0] ? sum[106] : ~sum[106];
                    end else begin
                        sign_out[0] = sign_mul[0] & sign_c[0];
                    end
                end
                sign_out[3:1] = 3'b0;
            end 
            default: begin  
                aligned[105:0] = op[0] ? alignShft_n[105:0] : alignShft[105:0];
                sum[105:0] = op[0] ? ((sum_add[106] & isshft[0]) ? sum_add[105:0] : (sum_add_n[105:0]+1)) : sum_add[105:0];
                add0 = sum_3t2; 
                add1 = {carry_3t2[104:0], op[0]}; 
                sum_out [159:106] = alignShft[158:106] + (op[0] ? ((~isshft[0] & sum[106]) ? -1 : 0) : sum[106]);
                if(~isshft[0]) begin     // exp_c > exp_m
                    sum_out[105:0] = {sum_out[159:106], sum[105:54]};
                    sign_out[0] = sign_c[0];
                end else if(c_out[0]) begin
                    sum_out[105:0] = {1'b1, sum[105:1]};
                    if(op[0]) begin
                        sign_out[0]  = sign_mul[0] ? sum[106] : ~sum[106];
                    end else begin
                        sign_out[0] = sign_mul[0] & sign_c[0];
                    end
                end else begin
                    sum_out[105:0] = sum[105:0];
                    if(op[0]) begin
                        sign_out[0]  = sign_mul[0] ? sum[106] : ~sum[106];
                    end else begin
                        sign_out[0] = sign_mul[0] & sign_c[0];
                    end
                end
                sign_out[3:1] = 3'b0;
            end 
        endcase
    end
    
endmodule
