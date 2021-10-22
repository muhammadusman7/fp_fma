// Title: Single bit Full Adder V 1.0 (No Changelog)
// Created: Septmeber 09, 2021
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that define a Full Adder.
// 
//
//---------------------------------------------------------------------------
module fullAdder (   
    input   a,              // The three-bit inputs to the Full Adder
    input   b,
    input   c_in,
    output  c_out,              // The two-bit outputs to the Full Adder
    output  s 
);
    
        assign {c_out, s} = a + b + c_in;    
            // Actual operation is to map it to FA Std Cell

endmodule