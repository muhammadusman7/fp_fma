// Title: Booth Partial Products V 1.0 (No Changelog)
// Created: Septmeber 10, 2021
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that define a Modified Booth Selector for radix-4
// partial product generation
//
//---------------------------------------------------------------------------
module boothPP #(parameter WIDTH = 14) (
    input   [WIDTH-1:0] in,
    output  [WIDTH:0] out_in,
    output  [WIDTH:0] out_in_n,
    output  [WIDTH:0] out_in_2,
    output  [WIDTH:0] out_in_2n,
    output  [WIDTH:0] out_zero
);

    wire [WIDTH:0] onesComp; // One's Comp
    // +1 needs to be compensated in PP reductions

    assign onesComp     = ~{1'b0, in};
    assign out_in       = {1'b0, in};
    assign out_in_n     = onesComp;
    assign out_in_2     = {in, 1'b0};
    assign out_in_2n    = {onesComp[WIDTH-1:0], 1'b1};
    assign out_zero     = 0;

endmodule