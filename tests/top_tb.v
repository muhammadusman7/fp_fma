// Title: Fused Multiply Add V 1.0 (No Changelog)
// Created: Septmeber 29, 2021
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that define a Modified Booth Selector for radix-4
// partial product gen_sipoeration
//
//---------------------------------------------------------------------------
module top_tb;

    // Inputs
	reg en_sipo, en_piso;
	reg clk;
	reg din;
	reg rst;
	reg [1:0] mode, precision, op;
	integer i;
	integer j;
	reg [69:0] data [13:0];
    reg [74:0] out;

	// Outputs
	wire rFlag, tFlag;
	wire  dout;

	// Instantiate the Unit Under Test (UUT)
	top uut( .clk(clk), .rst(rst), .en_sipo(en_sipo), .din(din), .en_piso(en_piso), .mode(mode), 
        .precision(precision), .op(op), .rFlag(rFlag), .dout(dout), .tFlag(tFlag) );
    
    initial begin
		// Initialize Inputs
		en_sipo = 0; en_piso = 0; mode = 2'b11; out = 75'b0; precision = 2'b11; op = 2'b11;
		data [0] = 70'h204016000000000000;
		data [1] = 70'h004023000000000000;
		data [2] = 70'h0040234CCCC0000000;
		data [3] = 70'h003FD06C4C5974E65C;
		data [4] = 70'h0040B41E83DD97F62B;
		data [5] = 70'h00407F48BC6A7EF9DB;
		data [6] = 70'h00407F48BC6A7EF9DB;
		data [7] = 70'h004048684D129F5D32;
		data [8] = 70'h003F72611593C60001;
		data [9] = 70'h00C0100FF20BD91970;
		data [10] = 70'h00C0BAD7E6A5048159;
		data [11] = 70'h0040BBC674C4140EF3;
		data [12] = 70'h0040A69E94DB886091;
		data [13] = 70'h00C07D46072866091E;
		clk = 0;
		din = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#10 rst = 1;
		#80 rst = 0;
		#10 en_sipo = 1; en_piso = 0;
		for (j=0; j<=13; j=j+1) begin
			for (i=69; i>=0; i=i-1) begin
				din = data [j][i];
				#10;
                if($time == 4400)begin
                    en_piso = 1;
                end
			end
		end
		en_sipo = 0;
        #10; 
		$finish();
	end

	always #5 clk = ~clk;

    always @(posedge clk) begin
        if(en_piso)
            out = {out[73:0], dout};
        if(tFlag) begin
            $display("OUT: %h", out);
        end
    end
    
endmodule