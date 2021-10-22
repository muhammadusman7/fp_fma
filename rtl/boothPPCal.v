// Title: Booth Partial Product Calculation V 1.0 (No Changelog)
// Created: Septmeber 11, 2021
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that assings the partial products for radix-4
// based upon the booth encoded input.
//
//---------------------------------------------------------------------------
module boothPPCal #(parameter WIDTH = 14) (
    input   [WIDTH:0]   pp,
    input   [WIDTH:0]   pp_n,
    input   [WIDTH:0]   pp_2,
    input   [WIDTH:0]   pp_2n,
    input   [WIDTH:0]   pp_zero,
    input   [2:0]       booth,
    output  comp,
    output  [WIDTH:0]   out
);

    wire single_pp, double_pp, neg_pp;

    boothEnc bEnc (
        .in(booth), .single(single_pp), .double(double_pp), .neg(neg_pp) );
    boothSel #(.WIDTH(WIDTH)) bSel (
        .single(single_pp), .double(double_pp), .neg(neg_pp), .in(pp),
        .in_n(pp_n), .in_2(pp_2), .in_2n(pp_2n), .zero(pp_zero), .out(out) );
    
    assign comp = neg_pp & (single_pp | double_pp); 

endmodule