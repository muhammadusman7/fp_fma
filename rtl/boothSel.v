// Title: Booth Selector V 1.0 (No Changelog)
// Created: Septmeber 10, 2021
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that define a Modified Booth Selector for radix-4
// partial product generation
//
//---------------------------------------------------------------------------
module boothSel #(parameter WIDTH = 14) (
    input   single,                     // The single input to the Selector
    input   double,                     // The double input to the Selector
    input   neg,                        // The neg input to the Selector
    input   [WIDTH:0] in,             // The input to the Selector
    input   [WIDTH:0] in_n,           // The input to the Selector
    input   [WIDTH:0] in_2,           // The input to the Selector
    input   [WIDTH:0] in_2n,          // The input to the Selector
    input   [WIDTH:0] zero,           // The input to the Selector
    output  reg     [WIDTH:0] out     // The output to the Selector
);

    always @(*) begin
            // This genrates the outputs to the Selector
        case ({single, double, neg})
            3'b000: out = zero;
            3'b100: out = in;
            3'b010: out = in_2;
            3'b011: out = in_2n;
            3'b101: out = in_n;
            3'b001: out = zero;
            default: out = zero;
        endcase
    end
    
endmodule