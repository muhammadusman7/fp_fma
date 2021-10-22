// Title: Alingmint Shifter V 1.0 (No Changelog)
// Created: 
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that aligns the addened with the respect to multip-
// lication result
//
//---------------------------------------------------------------------------
module alignShift (
    input       [52:0]  in,
    input       [7:0]   shtamt0,
    input       [7:0]   shtamt1,
    input       [7:0]   shtamt2,
    input       [7:0]   shtamt3,
    input       [1:0]   mode,
    output reg  [105:0] out_shifted,
    output reg  [52:0]  out_remainder
);

    reg [159:0] out_temp;
    always @(*) begin
        if(mode == 2'b01) begin
            out_temp = {1'b0, in[52:40], 26'b0, in[39:26], 26'b0,  in[25:12], 26'b0,  in[11:0], 28'b0}; //  0:39, 40:79, 80:119, 120:159
            out_temp[39:0] = out_temp[39:0] >> shtamt0;         // 27:6 usefull
            out_temp[79:40] = out_temp[79:40] >> shtamt1;       // 67:46
            out_temp[119:80] = out_temp[119:80] >> shtamt2;     // 107:86
            out_temp[159:120] = out_temp[159:120] >> shtamt3;   // 147:126
            out_shifted = {out_temp[147:126], 6'b0, out_temp[107:86], 6'b0, out_temp[67:46], 6'b0, out_temp[27:6]};
            out_remainder = {out_temp[158:148], 3'b0, out_temp[118:108], 3'b0, out_temp[78:68], 3'b0, out_temp[38:28]};
        end else if (mode == 2'b10) begin
            out_temp = {1'b0, in[52:25], 51'b0,  in[24:0], 55'b0};    //  0:79, 80:159
            out_temp[79:0] = out_temp[79:0] >> shtamt0;         // 54:7 usefull
            out_temp[159:80] = out_temp[159:80] >> shtamt1;     // 134:87
            out_shifted = {out_temp[134:87], 10'b0, out_temp[54:7]};
            out_remainder = {out_temp[158:135], 5'b0, out_temp[78:55]};
        end else begin
            out_temp = {1'b0, in[52:0], 106'b0}; //  0:105
            out_temp = out_temp >> shtamt0;
            out_shifted = out_temp[105:0];
            out_remainder = out_temp[158:106];
        end
    end

endmodule