// Title: Booth Encoder V 1.0 (No Changelog)
// Created: Septmeber 10, 2021
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that define a Modified Booth Encoder for radix-4.
// 
//
//---------------------------------------------------------------------------
module boothEnc (
    input   [2:0]   in,         // The three-bit inputs to the Encoder
    output  reg     single,     // The output single to the Encoder
    output  reg     double,     // The output double to the Encoder
    output  reg     neg         // The output neg to the Encoder
);
    always @(in) begin
            // This genrates the outputs to the Encoder
        case (in)
            3'd0: {single, double, neg} = 3'b000;
            3'd1: {single, double, neg} = 3'b100;
            3'd2: {single, double, neg} = 3'b100;
            3'd3: {single, double, neg} = 3'b010;
            3'd4: {single, double, neg} = 3'b011;
            3'd5: {single, double, neg} = 3'b101;
            3'd6: {single, double, neg} = 3'b101;
            3'd7: {single, double, neg} = 3'b001;
            default: {single, double, neg} = 3'b000;
        endcase
    end
    
endmodule