// Title: Register V 1.0 (No Changelog)
// Created: Septmeber 09, 2021
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that define a Register to added in pipeline stages
// 
//
//---------------------------------------------------------------------------
module register #(parameter WIDTH = 64) (
    input       clk, rst,
    input       [WIDTH-1:0] in,
    output reg  [WIDTH-1:0] out
);
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            out <= {WIDTH{1'b0}};
        end else begin
            out <= in;
        end
    end
endmodule