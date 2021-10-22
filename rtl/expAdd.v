// Title: Exponent of Addition V 1.0 (No Changelog)
// Created: Septmeber 24, 2021
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that define calculation of exponent for addition
// 
//
//---------------------------------------------------------------------------
module expAdd(
    input       [16:0]  a,      // a = {is_zero, is_norm, is_inf, is_NaN, exp[12:0]}
    input       [16:0]  b,      // Exponenet = a[12:0]
    input               en,
    input       [1:0]   precision, mode,  // 11 (Double), 10 (Single), 01 (Half)
    input               isshft,
    output reg  [12:0]  out,
    output reg          underflow,      // Consider (Del) ?
    output reg          overflow,       // Consider (Del) ?
    output reg          inf,
    output reg          NaN,
    output reg          zero
);

    // Constant bais of 1023 for double precision
    parameter   DBIAS    =   1023;
    parameter   SBIAS    =   127;
    parameter   HBIAS    =   15;
    //reg [12:0] temp_out;
    reg [16:0] data_a, data_b; 
    always @(*) begin
        {underflow, overflow, inf, NaN, zero} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
        data_a = en ? a : 17'b0; 
        data_b = en ? b : 17'b0; 
        
        if (data_a[16] && data_b[16] || ~data_a[15] && ~data_b[15]) begin       // is a and b Zero or sub normal
            out = 13'b0;
            zero = 1'b1;
        end else if (data_a[16] || ~data_a[15]) begin   // is a Zero or subnormal
             out = data_b[12:0];
            if(data_b[14] || data_b [13]) begin       // a is zero/subnormal and b is inf or NaN
                zero = 1'b0; inf = data_b [14]; NaN = data_b [13];
                out = 13'b1_1111_1111_1111;
            end
        end else if (data_b[16] || ~data_b[15]) begin   // is b Zero/subnormal
             out = data_a[12:0];
            if(data_a[14] || data_a [13]) begin       // b is zero and a is inf or NaN
                zero = 1'b0; inf = data_a [14]; NaN = data_a [13];
                out = 13'b1_1111_1111_1111;
            end
        end else if (data_a[14] || data_a[13] || data_b[14] || data_b[13]) begin
            out = 13'b1_1111_1111_1111;  // is a or b infinity or NaN
            inf = 1'b1; NaN = 1'b0;
            if (data_a[13] || data_b[13]) begin  // a or b is NaN
                inf = 1'b0; NaN = 1'b1;
            end
        end else begin
            {underflow, overflow, inf, NaN, zero} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
            out = isshft ? data_a[12:0] : (data_b[12:0]);
        end
    end
        
endmodule