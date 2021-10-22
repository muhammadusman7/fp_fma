`timescale 1ns / 1ps

module multiplier53Booth_tb;

    parameter WIDTH = 53;  // For 16 bit WIDTH = 16
    // Inputs
	reg [WIDTH-1:0] multiplier;
	reg [WIDTH-1:0] multiplicand;
    reg [1:0] mode;
	// Outputs
	wire [2*WIDTH-1:0]   p0; // Partial products
    wire [2*WIDTH-1:0]   p1; // Partial products
    // Local
    reg [2*WIDTH-1:0]   product_result, product_expected;
    reg is_passed;

    integer csvWrite, i, j, k, passed = 0, failed = 0;

    multiplier53Booth #(.WIDTH(53)) mul53 (
        .multiplicand(multiplicand), .multiplier(multiplier),
        .mode(mode), .p0(p0), .p1(p1)
    );

    initial begin
    
        //csvWrite = $fopen("/multiplier28.csv");
        //$fdisplay(csvWrite, "Sr No, Time, Multiplicand, Multiplier, Result, Expected, Passed");    
        multiplier = 0;
        multiplicand = 0;
        mode = 2'b10;
        #5;
        
        // Get partial products
        for (i = 1; i<=100_000; i= i+1) begin // 10M Tests
            $display("Simulation Started for Iteration: %d", i);
            for (j=1; j<=100; j=j+1) begin
                for (k = 1; k <= 1; k = k+1) begin
                    mode = k;
                    multiplicand[26:0] = $unsigned($random);
                    multiplier[26:0] = $unsigned($random);
                    multiplicand[53:27] = $unsigned($random);
                    multiplier[53:27] = $unsigned($random);

                    // To test all combinations of half precision set i = j = 1:2047 and k = 1:1
                    multiplicand[10:0] = i;
                    multiplier[10:0] = j;
                    multiplicand[24:14] = i;
                    multiplier[24:14] = j;
                    multiplicand[38:28] = i;
                    multiplier[38:28] = j;
                    multiplicand[52:42] = i;
                    multiplier[52:42] = j;
                    
                    if (product_result == product_expected) begin
                        passed = passed + 1;
                        is_passed = 1'b1;
                    end else begin
                        failed = failed + 1;
                        is_passed = 1'b0; $finish();
                        $display("Test Failed on Values: Multiplicad = %h, Multiplier = %h, Product Expected = %h, Product Generated = %h", multiplicand, multiplier, product_expected, product_result);
                    end
                    //$fmonitor(csvWrite, "%d,%d,%d,%d,%d,%d,%b",(passed+failed) , $time, multiplicand, multiplier, product_expected, product_result, is_passed);
                    #5; 
                end
            end
            $display("Total Passed: %d, Total Failed: %d", passed, failed);    
        end
        $display("Simulation Completed: Total Tests = %d, Passed = %d, Failed: %d", (passed+failed), passed, failed);
        //$fclose(csvWrite);
        $finish(); 
    end

    always @(p1, p0) begin
        product_result = p0 + p1;
        
        if (mode == 2) begin
            multiplier[28:24] = 5'b0;
            multiplicand[28:24] = 5'b0;
            product_result[48] = 1'b0; 
            product_expected[47:0] = multiplicand[23:0] * multiplier[23:0];
            product_expected[105:58] = multiplicand[52:29] * multiplier[52:29];
            product_expected[57:48] = 10'b0;
        end
        else if (mode == 1) begin
            multiplier[13:11] = 3'b0;
            multiplicand[13:11] = 3'b0;
            multiplier[27:25] = 3'b0;
            multiplicand[27:25] = 3'b0;
            multiplier[41:39] = 3'b0;
            multiplicand[41:39] = 3'b0;

            // To Test only first Half precision mulyiplication
        //    multiplier[52:11] = 42'b0;
        //    multiplicand[52:11] = 42'b0;

            product_result[22] = 1'b0;
            product_result[50] = 1'b0; 
            product_result[78] = 1'b0; 
            product_expected[21:0] = multiplicand[10:0] * multiplier[10:0];
            product_expected[49:28] = multiplicand[24:14] * multiplier[24:14];
            product_expected[77:56] = multiplicand[38:28] * multiplier[38:28];
            product_expected[105:84] = multiplicand[52:42] * multiplier[52:42];
            product_expected[27:22] = 6'b0;
            product_expected[55:50] = 6'b0;
            product_expected[83:78] = 6'b0;
        end
        else begin
            product_expected = multiplicand * multiplier;
        end
        
    end
    
endmodule