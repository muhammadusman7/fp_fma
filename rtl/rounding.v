// Title: Rounding V 1.0 (No Changelog)
// Created: 
// Updated: 
//---------------------------------------------------------------------------
// 
// 
//
//---------------------------------------------------------------------------
module rounding (
    input       [105:0] in,
    input       [1:0]   mode,
    output reg  [3:0]   cout,
    output reg  [52:0]  out
);
    reg [52:0]  out_temp;
    always @(*) begin
        if (mode == 2'b01) begin
            // Assign 0 to unused bits
            out_temp[13:11] = 3'b0;
            out_temp[27:25] = 3'b0;
            out_temp[41:39] = 3'b0;
            {cout[0], out_temp[10:0]} = in[21:11] + in[10];
            if(cout[0]) begin
                out[10:0] = {cout[0], out_temp[10:1]};
            end else begin
                out[10:0] = out_temp[10:0];
            end
            {cout[1], out_temp[24:14]} = in[49:39] + in[38];
            if(cout[1]) begin
                out[24:11] = {cout[1], out_temp[24:12]};
            end else begin
                out[24:11] = {out_temp[24:11]};
            end
            {cout[2], out_temp[38:28]} = in[77:67] + in[66];
            if(cout[2]) begin
                out[38:25] = {cout[2], out_temp[38:26]};
            end else begin
                out[38:25] = {out_temp[38:25]};
            end
            {cout[3], out_temp[52:42]} = in[105:95] + in[94];
            if(cout[3]) begin
                out[52:39] = {cout[2], out_temp[52:40]};
            end else begin
                out[52:39] = {out_temp[52:39]};
            end
        end else if (mode == 2'b10) begin
            // Assign 0 to unused bits
            out_temp[28:24] = 5'b0;
            cout[3:2] = 2'b0;
            {cout[0], out_temp[23:0]} = in[47:24] + in[23];
            if(cout[0]) begin
                out[23:0] = {cout[0], out_temp[23:1]};
            end else begin
                out[23:0] = out_temp[23:0];
            end
            {cout[1], out_temp[52:29]} = in[105:82] + in[81];
            if(cout[1]) begin
                out[52:24] = {cout[1], out_temp[52:25]};
            end else begin
                out[52:24] = {out_temp[52:24]};
            end 
        end else begin
            // Assign 0 to unused bits
            cout[3:1] = 3'b0;
            {cout[0], out_temp[52:0]} = in[105:53] + in[52];
            if(cout[0]) begin
                out[52:0] = {cout[0], out_temp[52:1]};
            end else begin
                out[52:0] = out_temp[52:0];
            end
        end
    end

endmodule