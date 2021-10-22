// Title: Operand V 1.0 (No Changelog)
// Created: Septmeber 11, 2021
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that takes a 64-bit input and outputs the sign
// exponent, and mantissa along with if input is zero, normal, infinity or NaN
//
//---------------------------------------------------------------------------
module operand(
    input [63:0]        in,
    input [1:0]         precision,
    input               en,
    output reg          sign,
    output reg [10:0]   exp,
    output reg [52:0]   mantissa,
    output reg          is_zero,
    output reg          is_norm,
    output reg          is_inf,
    output reg          is_NaN    
    );

    // Constant bais of 1023 for double precision
    
    parameter   DBIAS    =   1023;
    parameter   SBIAS    =   127;
    parameter   HBIAS    =   15;

    reg is_mantissa_nzdp, is_mantissa_nzsp, is_mantissa_nzhp;  // Is mantissa non-zero
    reg is_exp_nzdp, is_exp_nzsp, is_exp_nzhp;                 // Is exponent non-zero
    reg is_exp_mdp, is_exp_msp, is_exp_mhp;                    // Is exponent non-zero
    reg [63:0] data;

    always@(*) begin

        data = en ? in : 64'b0;
        // Extract sign bits of input
        sign = precision == 2'b01 ? data[15] : precision == 2'b10 ? data[31] : data[63];

        // Extract exponent
        exp = precision == 2'b01 ? {6'b0, data[14:10]} : precision == 2'b10 ? {3'b0, data[30:23]} : data[62:52];

        // Check if input is zero;
        is_mantissa_nzdp = |data[51:0];
        is_mantissa_nzsp = |data[22:0];
        is_mantissa_nzhp = |data[9:0];
        is_exp_nzdp = |data[62:52];
        is_exp_nzsp = |data[30:23];
        is_exp_nzhp = |data[14:10];

        is_zero = precision == 2'b01 ? ~(is_exp_nzhp || is_mantissa_nzhp) : precision == 2'b10 ? ~(is_exp_nzsp || is_mantissa_nzsp) : ~(is_exp_nzdp || is_mantissa_nzdp);

        // Check for NaN (Not a Number) (Exponent with bias is 2047 and Mantissa is nonzero)
        is_exp_mdp = exp[10:0] == 11'd2047;
        is_exp_msp = exp[7:0] == 8'd255;
        is_exp_mhp = exp[4:0] == 5'd31;

        is_NaN = precision == 2'b01 ? is_exp_mhp && is_mantissa_nzhp : 
            precision == 2'b10 ? is_exp_msp && is_mantissa_nzsp : is_exp_mdp && is_mantissa_nzdp;

        // Check for infinity (Exponant with bias is 2047 and Mantissa is zero)
        is_inf = precision == 2'b01 ? is_exp_mhp && ~is_mantissa_nzhp : 
            precision == 2'b10 ? is_exp_msp && ~is_mantissa_nzsp : is_exp_mdp && ~is_mantissa_nzdp;

        // Append 1 or 0 for normalized or demormalized significand
        is_norm = precision == 2'b01 ? is_exp_nzhp : precision == 2'b10 ? is_exp_nzsp : is_exp_nzdp;

        if(is_norm) begin
            mantissa = {1'b1, precision == 2'b01 ? {data[9:0], 42'b0} : precision == 2'b10 ? {data[22:0], 29'b0} : data[51:0]};
        end else begin                      // Subnormal Numbers Flush to Zero
            mantissa = {1'b0, 52'b0};
            exp = 11'b0;
        end
    end
endmodule
