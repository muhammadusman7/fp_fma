// Title: Normalize V 1.0 (No Changelog)
// Created: 
// Updated: 
//---------------------------------------------------------------------------
// 
// 
//
//---------------------------------------------------------------------------
module normalize (
    input       [105:0]  in,
    input       [6:0]   shtamt0,
    input       [6:0]   shtamt1,
    input       [6:0]   shtamt2,
    input       [6:0]   shtamt3,
    input       [1:0]   mode,
    output reg  [105:0] out
);

    reg [105:0]out_temp;
    always @(*) begin
        if(mode == 2'b01) begin
            out_temp[21:0] = in[21:0] << shtamt0;   out_temp[27:22] = 6'b0;
            out_temp[49:28] = in[49:28] << shtamt1;   out_temp[55:50] = 6'b0;
            out_temp[77:56] = in[77:56] << shtamt2;  out_temp[83:78] = 6'b0;
            out_temp[105:84] = in[105:84] << shtamt3;
            out = out_temp;
        end else if (mode == 2'b10) begin
            out_temp[47:0] = in[47:0] << shtamt0; out_temp[57:48] = 10'b0;
            out_temp[105:58] = in[105:58] << shtamt1;
            out = out_temp;
        end else begin
            out_temp = in << shtamt0;
            out = out_temp;
        end
    end

endmodule