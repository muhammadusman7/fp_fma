`timescale 1ns / 1ps

module boothPPCal_tb;

    parameter WIDTH = 14;  // For 16 bit WIDTH = 16
    // Inputs
	reg [WIDTH-1:0] multiplier;
	reg [WIDTH-1:0] multiplicand;
    reg [2:0]booth;

    reg [WIDTH+2:0] temp_multiplier;
	// Outputs
	wire [WIDTH:0] product; // Partial product
    wire comp;
    wire [WIDTH:0] pp_in, pp_n, pp_2, pp_2n, pp_zero;
    integer i, j;
    
    boothPP #(.WIDTH(WIDTH)) bPP (
            .in(multiplicand), .out_in(pp_in), .out_in_n(pp_n), .out_in_2(pp_2),
            .out_in_2n(pp_2n), .out_zero(pp_zero) );

        // Get partial produts for each row
    boothPPCal #(.WIDTH(WIDTH)) pp (.pp(pp_in), .pp_n(pp_n), .pp_2(pp_2), .pp_2n(pp_2n),
            .pp_zero(pp_zero), .booth(booth), .comp(comp),
            .out(product) );


    initial begin
        
        multiplier = 0;
        multiplicand = 0;
        temp_multiplier = 0;
        booth = 3'b0;
        #5;
        
        // Get basic partial products
        for (j=1; j<=10 ; j=j+1) begin
            multiplicand =$random; 
	        multiplier = $random;
            temp_multiplier = {1'b0, 1'b0, multiplier, 1'b0};
            for (i=1; i<=(WIDTH+1)/2; i = i+1) begin
                booth = {temp_multiplier[2*i], temp_multiplier[2*i-1], temp_multiplier[2*i-2]};
                #10;
            end
        end
        $finish(); 
    end
    
endmodule