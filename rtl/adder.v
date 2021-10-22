// Title: Adder V 1.0 (No Changelog)
// Created: Septmeber 09, 2021
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that define a Adder. It uses 4 bit carry look ahead
// adders to generate final adder
//
//---------------------------------------------------------------------------
module adder #(parameter WIDTH = 106, CWIDTH = 29) (   
    input   [WIDTH-1:0] in_a,              // The three-bit inputs to the Full Adder
    input   [WIDTH-1:0] in_b,
    input   c_in,
    output  c_out,              // The two-bit outputs to the Full Adder
    output  [WIDTH-1:0] s 
);
    // Carry Wire Size CWIDTH = WIDTH/4 + WIDTH%4 +1; e.g 53/4+53%2+1 = 13+1+1 = 15  
    wire [CWIDTH-1:0] c;
    assign c[0] = c_in;
    genvar i, j;
    generate
        for (i = 0; i <= WIDTH; i = i+4) begin
            if(WIDTH-i >= 4) begin
                claAdder4 cla4i (.in_a(in_a[i +:4]), .in_b(in_b[i +:4]), .c_in(c[i/4]), .s(s[i +:4]), .c_out(c[i/4+1]));
            end else begin
                for (j = 0; j <= WIDTH-1-i; j = j+1) begin
                    fullAdder faj (.a(in_a[j+i]), .b(in_b[j+i]), .c_in(c[i/4+j]), .s(s[j+i]), .c_out(c[i/4+j+1]));
                end
            end
        end
    endgenerate
    assign c_out = c[CWIDTH-1];

endmodule