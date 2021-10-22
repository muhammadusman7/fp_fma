// Title: Sign and Exponent of Multiplication V 1.0 (No Changelog)
// Created: Septmeber 24, 2021
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that calculates the sign, exponent of multiplication
// 
//
//---------------------------------------------------------------------------
module signExpMul(
    input       [15:0]  a,      // a = {is_zero, is_norm, is_inf, is_NaN, Sign, exp[10:0]}
    input       [15:0]  b,      // Exponenet = a0[10:0]
    input       [10:0]  c,
    input               en,
    input       [1:0]   mode,  
    input       [1:0]   precision,  // 11 (Double), 10 (Single), 01 (Half)
    input               isMul,
    output reg  [12:0]  out,
    output reg          underflow,
    output reg          overflow,
    output reg          inf,
    output reg          NaN,
    output reg          zero,
    output reg          sign,
    output reg          isshft,
    output reg   [7:0]  shftamt,
    output reg   [12:0] expdiff,
    output reg          isSat
);

    // Constant bais of 1023 for double precision
    parameter   DBIAS    =   1022;  // BIAS -1 as floating point is after 2 bits at MSB
    parameter   SBIAS    =   126;   // side in the multiplication
    parameter   HBIAS    =   14;
    reg [12:0] temp_out;
    reg [15:0] data_a, data_b; 
    reg [10:0] data_c;
    //reg [12:0] expdiff;
    reg [12:0] shftamt_temp;
    //reg        isSat;   // is shift saturate
    always @(*) begin
        {underflow, overflow, inf, NaN, zero} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
        data_a = en ? a : 16'b0; 
        data_b = en ? b : 16'b0; 
        data_c = en ? c : 11'b0; 
        sign = isMul ? (data_a[11] ^ data_b[11]) : data_a[11]; // xor to calculate sign
        
        if (data_a[15]) begin       // is a Zero
            out = 13'b0;
            zero = 1'b1;
            if((data_b[13] || data_b [12]) & isMul) begin       // a is zero and b is inf or NaN
                zero = 1'b0; NaN = 1'b1;
                out = 13'b1_1111_1111_1111;
            end
        end
        else if (data_b[15] & isMul) begin   // is b Zero
            out = 13'b0;
            zero = 1'b1;
            if(data_a[13] || data_a [12]) begin       // b is zero and a is inf or NaN
                zero = 1'b0; NaN = 1'b1;
                out = 13'b1_1111_1111_1111;
            end
        end else if ( ~data_a[14] || (~data_b[14] & isMul)) begin   // if a or b is subnormal flush to zero
            out = 13'b0;
            zero = 1'b1;
        end else if (data_a[13] || data_a[12] || (data_b[13] || data_b[12]) && isMul) begin
            out = 13'b1_1111_1111_1111;  // is a or b infinity or NaN
            inf = 1'b1; NaN = 1'b0;
            if (data_a[12] || (data_b[12] && isMul)) begin  // a or b is NaN
                inf = 1'b0; NaN = 1'b1;
            end
        end else begin
            temp_out = isMul ? (data_a[10:0] + data_b[10:0] - (precision == 2'b01 ? HBIAS : precision == 2'b10 ? SBIAS : DBIAS)) : data_a[10:0];
            case (precision)
                2'b01: begin overflow = $signed(temp_out) >= 13'd30 ? 1'b1 : 1'b0; inf = overflow; 
                    underflow = $signed(temp_out) < 0 ? 1'b1 : 1'b0;  end
                2'b10: begin overflow = $signed(temp_out) >= 13'd254 ? 1'b1 : 1'b0; inf = overflow; 
                    underflow = $signed(temp_out) < 0 ? 1'b1 : 1'b0;  end
                2'b11: begin overflow = $signed(temp_out) >= 13'd2046 ? 1'b1 : 1'b0; inf = overflow; 
                    underflow = $signed(temp_out) < 0 ? 1'b1 : 1'b0;  end
                default: begin overflow = $signed(temp_out) >= 13'd2046 ? 1'b1 : 1'b0; inf = overflow; 
                    underflow = $signed(temp_out) < 0 ? 1'b1 : 1'b0;  end
            endcase
            out = overflow ? 13'b1_1111_1111_1111 : underflow ? 13'b0 : temp_out;
        end
        expdiff = out - data_c;
        shftamt_temp = expdiff + (mode == 01 ? 8'd11 : mode == 2'b10 ? 8'd24 : 8'd53);  // Shift Adjusments due to offset in alignShift
        isSat = $signed(shftamt_temp) > 8'b1111_1111;
        shftamt = en ? isSat ? 8'b1111_1111 : shftamt_temp[7:0] : 8'b0;
        isshft = en ? $signed(out) >= data_c : 1'b0;
    end
        
endmodule