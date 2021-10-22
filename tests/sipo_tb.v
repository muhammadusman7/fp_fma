`timescale 1ns / 1ps
module sipo_tb;

	// Inputs
	reg en;
	reg clk;
	reg din;
	reg rst;
	reg [1:0] mode;
	integer i;
	integer j;
	reg [69:0] data [13:0];

	// Outputs
	wire load;
	wire [69:0] dout;
	wire [3:0]  row;

	// Instantiate the Unit Under Test (UUT)
	sipo uut (
		.en(en), 
		.clk(clk), 
		.din(din), 
		.rst(rst), 
		//.mode(mode),
		.load(load), 
		.dout(dout),
		.row(row)
	);
	
	initial begin
		// Initialize Inputs
		en = 0;	mode = 2'b01;
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
		data [13] = 70'h00C07D46072866091F;
		clk = 0;
		din = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#90;
		rst = 0;
		#10 en = 1;
		for (j=0; j<=13; j=j+1) begin
			for (i=69; i>=0; i=i-1) begin
				din = data [j][i];
				#10;
			end
		end
		#10; 
		$finish();
	end

	always #5 clk = ~clk;
      
endmodule

