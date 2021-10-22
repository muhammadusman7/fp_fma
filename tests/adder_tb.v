`timescale 1ns / 1ps

module adder_tb;

    // Inputs
    parameter WIDTH = 106;
    parameter CWIDTH = 29;   // Carry Wire Size CWIDTH = WIDTH/4 + WIDTH%4 +1; e.g 6/4+6%2+1 = 1+2+1 = 4
	reg [WIDTH-1:0] in_a;
	reg [WIDTH-1:0] in_b;
    reg c_in;
    
	// Outputs
	wire [WIDTH:0] s;

    reg [WIDTH:0] sum;

    integer i, j , k, passed = 0;
    
    adder #(.WIDTH(WIDTH), .CWIDTH(CWIDTH)) add (.in_a(in_a), .in_b(in_b), .c_in(c_in), .s(s[WIDTH-1:0]), .c_out(s[WIDTH]));

    initial begin
        
        in_a = 0;
        in_b = 0;
        c_in = 1;
        #5;
        
        for (j=1; j<=100_000 /*2**WIDTH-1*/; j=j+1) begin     // 10M Tests
            $display("Iteration No: %d, Total Passed = %d", j, passed);
            for (i=1; i<=100 /*2**WIDTH-1*/; i = i+1) begin
                // For Rnadom Tests
                in_a[26:0] = $unsigned($random);
                in_b[26:0] = $unsigned($random);
                in_a[105:27] = $unsigned($random);
                in_b[105:27] = $unsigned($random);
                
                for (k = 0; k<=1; k = k+1) begin
                    //in_a = i;        // For full tests
                    //in_b = j;
                    c_in = k;
                    sum = in_a + in_b + c_in;
                    #5;
                    if(sum == s)
                        passed = passed+1;
                    else begin
                        $display("Test Failed on Values: A = %h, B = %h, C = %b, Sum Expected = %h, Sum Generated = %h", in_b, in_b, c_in, sum, s);
                        $finish();
                    end
                    #5;                    
                end
            end
        end
        $display("All Tests Passed Successfully, Total Tests = %d", passed);
        $finish(); 
    end
    
endmodule