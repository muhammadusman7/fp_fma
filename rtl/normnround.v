// Title: Normalize and Round V 1.0 (No Changelog)
// Created: 
// Updated: 
//---------------------------------------------------------------------------
// 
// 
//
//---------------------------------------------------------------------------
module normnround (
    input      [1:0]       mode, precision,
    input      [105:0]     sum,
    input      [6:0]       lop0, lop1, lop2, lop3,
    input      [12:0]      exp_s0, exp_s1, exp_s2, exp_s3,
    input      [3:0]       sign_sum, c_outsum, uf_sum, of_sum, inf_sum, z_sum, NaN_sum,
    output reg [63:0]      out0, out1, out2, out3,
    output reg [3:0]       uf_out, of_out, inf_out, z_out, NaN_out,
    output     [3:0]       cout_round
);

    wire [105:0] normalized; 
    wire [52:0] rounded;
    reg [12:0] exp_o0, exp_o1, exp_o2, exp_o3;
    wire [63:0] zero = 64'b0;
    wire [63:0] infdp = 64'hFFF0000000000000;
    wire [63:0] infsp = 64'hFFFFFFFFFF800000;
    wire [63:0] infhp = 64'hFFFFFFFFFFFFFC00;
    wire [63:0] NaNdp = 64'hFFF8000000000000;
    wire [63:0] NaNsp = 64'hFFFFFFFFFFC00000;
    wire [63:0] NaNhp = 64'hFFFFFFFFFFFFFE00;
    
    normalize norm(.in(sum), .shtamt0(lop0), .shtamt1(lop1), .shtamt2(lop2),
        .shtamt3(lop3), .mode(mode), .out(normalized) );
    rounding round(.in(normalized), .mode(mode), .cout(cout_round), .out(rounded) );
    

    always@(*) begin
        uf_out = uf_sum; of_out = of_sum;
        inf_out = inf_sum; z_out = z_sum; NaN_out = NaN_sum;
        if(cout_round[0] && mode == precision) begin
            exp_o0 = exp_s0 - lop0 + 1 + c_outsum[0];
        end
        else begin
            exp_o0 = exp_s0 - lop0 + c_outsum[0];
        end
        if(cout_round[1] && mode == precision) begin
            exp_o1 = exp_s1 - lop1 + 1 + c_outsum[1];
        end
        else begin
            exp_o1 = exp_s1 - lop1 + c_outsum[1];
        end
        if(cout_round[2] && mode == precision) begin
            exp_o2 = exp_s2 - lop2 + 1 + c_outsum[2];
        end
        else begin
            exp_o2 = exp_s2 - lop2 + c_outsum[2];
        end
        if(cout_round[3] && mode == precision) begin
            exp_o3 = exp_s3 - lop3 + 1 + c_outsum[3];
        end
        else begin
            exp_o3 = exp_s3 - lop3 + c_outsum[3];
        end
        case ({mode, precision})
            4'b1111: begin
                out0 = (z_sum[0] | uf_sum[0]) ? zero : inf_sum[0] ? {sign_sum[0], infdp[62:0]} : 
                    NaN_sum[0] ? {sign_sum[0], NaNdp[62:0]} : {sign_sum[0], exp_o0[10:0], rounded[51:0]};
                out1 = zero;
                out2 = zero;
                out3 = zero;
            end
            4'b1011: begin
                out0 = (z_sum[0] | uf_sum[0]) ? zero : inf_sum[0] ? {sign_sum[0], infdp[62:0]} : 
                    NaN_sum[0] ? {sign_sum[0], NaNdp[62:0]} : {sign_sum[0], exp_o0[10:0], normalized[46:0], 5'b0};
                out1 = (z_sum[1] | uf_sum[1]) ? zero : inf_sum[1] ? {sign_sum[0], infdp[62:0]} : 
                    NaN_sum[1] ? {sign_sum[0], NaNdp[62:0]} : {sign_sum[1], exp_o1[10:0], normalized[104:58], 5'b0};
                out2 = zero;
                out3 = zero;
            end
            4'b0111: begin
                out0 = (z_sum[0] | uf_sum[0]) ? zero : inf_sum[0] ? {sign_sum[0], infdp[62:0]} : 
                    NaN_sum[0] ? {sign_sum[0], NaNdp[62:0]} : ({sign_sum[0], exp_o0[10:0], normalized[20:0], 31'b0});
                out1 = (z_sum[1] | uf_sum[1]) ? zero : inf_sum[1] ? {sign_sum[0], infdp[62:0]} : 
                    NaN_sum[1] ? {sign_sum[0], NaNdp[62:0]} : {sign_sum[1], exp_o1[10:0], normalized[48:28], 31'b0};
                out2 = (z_sum[2] | uf_sum[2]) ? zero : inf_sum[2] ? {sign_sum[0], infdp[62:0]} : 
                    NaN_sum[2] ? {sign_sum[0], NaNdp[62:0]} : {sign_sum[2], exp_o2[10:0], normalized[76:56], 31'b0};
                out3 = (z_sum[3] | uf_sum[3]) ? zero : inf_sum[3] ? {sign_sum[0], infdp[62:0]} : 
                    NaN_sum[3] ? {sign_sum[0], NaNdp[62:0]} : {sign_sum[3], exp_o3[10:0], normalized[104:84], 31'b0};
            end
            4'b1010: begin
                out0 = (z_sum[0] | uf_sum[0]) ? zero : inf_sum[0] ? {infsp[63:32], sign_sum[0], infsp[30:0]} : 
                    NaN_sum[0] ? {NaNsp[63:32], sign_sum[0], NaNsp[30:0]} : {32'b0, sign_sum[0], exp_o0[7:0], rounded[22:0]};
                out1 = (z_sum[1] | uf_sum[1]) ? zero : inf_sum[1] ? {infsp[63:32], sign_sum[1], infsp[30:0]} : 
                    NaN_sum[1] ? {NaNsp[63:32], sign_sum[1], NaNsp[30:0]} : {32'b0, sign_sum[1], exp_o1[7:0], rounded[51:29]};
                out2 = zero;
                out3 = zero;
            end
            4'b0110: begin
                out0 = (z_sum[0] | uf_sum[0]) ? zero : inf_sum[0] ? {infsp[63:32], sign_sum[0], infsp[30:0]} : 
                    NaN_sum[0] ? {NaNsp[63:32], sign_sum[0], NaNsp[30:0]} : {32'b0, sign_sum[0], exp_o0[7:0], normalized[20:0], 2'b0};
                out1 = (z_sum[1] | uf_sum[1]) ? zero : inf_sum[1] ? {infsp[63:32], sign_sum[1], infsp[30:0]} : 
                    NaN_sum[1] ? {NaNsp[63:32], sign_sum[1], NaNsp[30:0]} : {32'b0, sign_sum[1], exp_o1[7:0], normalized[48:28], 2'b0};
                out2 = (z_sum[2] | uf_sum[2]) ? zero : inf_sum[2] ? {infsp[63:32], sign_sum[2], infsp[30:0]} : 
                    NaN_sum[2] ? {NaNsp[63:32], sign_sum[2], NaNsp[30:0]} : {32'b0, sign_sum[2], exp_o2[7:0], normalized[76:56], 2'b0};
                out3 = (z_sum[3] | uf_sum[3]) ? zero : inf_sum[3] ? {infsp[63:32], sign_sum[3], infsp[30:0]} : 
                    NaN_sum[3] ? {NaNsp[63:32], sign_sum[3], NaNsp[30:0]} : {32'b0, sign_sum[3], exp_o3[7:0], normalized[104:84], 2'b0};
            end
            4'b0101: begin
                out0 = (z_sum[0] | uf_sum[0]) ? zero : inf_sum[0] ? {infsp[63:16], sign_sum[0], infsp[14:0]} : 
                    NaN_sum[0] ? {NaNhp[63:16], sign_sum[0], NaNhp[14:0]} : {48'b0, sign_sum[0], exp_o0[4:0], rounded[9:0]};
                out1 = (z_sum[1] | uf_sum[1]) ? zero : inf_sum[1] ? {infsp[63:16], sign_sum[0], infsp[14:0]} : 
                    NaN_sum[1] ? {NaNhp[63:16], sign_sum[1], NaNhp[14:0]} : {48'b0, sign_sum[1], exp_o1[4:0], rounded[23:14]};
                out2 = (z_sum[2] | uf_sum[2]) ? zero : inf_sum[2] ? {infsp[63:16], sign_sum[0], infsp[14:0]} : 
                    NaN_sum[2] ? {NaNhp[63:16], sign_sum[2], NaNhp[14:0]} : {48'b0, sign_sum[2], exp_o2[4:0], rounded[37:28]};
                out3 = (z_sum[3] | uf_sum[3]) ? zero : inf_sum[3] ? {infsp[63:16], sign_sum[0], infsp[14:0]} : 
                    NaN_sum[3] ? {NaNhp[63:16], sign_sum[3], NaNhp[14:0]} : {48'b0, sign_sum[3], exp_o3[4:0], rounded[51:42]};
            end
            default: begin 
                out0 = (z_sum[0] | uf_sum) ? zero : inf_sum[0] ? {sign_sum[0], infdp[62:0]} : 
                    NaN_sum[0] ? {sign_sum[0], NaNdp[62:0]} : {sign_sum[0], exp_o0[10:0], rounded[51:0]};
                out1 = zero;
                out2 = zero;
                out3 = zero;
            end
        endcase
    end
endmodule
