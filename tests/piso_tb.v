// Title: Fused Multiply Add V 1.0 (No Changelog)
// Created: Septmeber 29, 2021
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that define a Modified Booth Selector for radix-4
// partial product generation
//
//---------------------------------------------------------------------------
module piso_tb;

	// Inputs
	reg en;
	reg clk;
	reg [74:0] din;
	reg [74:0] out;
	reg rst;
	integer i;
	integer j;
	reg [74:0] data [13:0];

	// Outputs
	wire tFlag;
	wire dout;
	wire [2:0]  row;

	// Instantiate the Unit Under Test (UUT)
	piso uut (
		.en(en), 
		.clk(clk), 
		.din(din), 
		.rst(rst), 
		.tFlag(tFlag), 
		.dout(dout),
		.row(row)
	);
	
	initial begin
		// Initialize Inputs
		en = 0;
		data [0] = 75'h4204016000000000001;
		data [1] = 75'h0004023000000000000;
		data [2] = 75'h00040234CCCC0000000;
		data [3] = 75'h0003FD06C4C5974E65C;
		data [4] = 75'h00040B41E83DD97F62B;
		data [5] = 75'h000407F48BC6A7EF9DB;
		data [6] = 75'h000407F48BC6A7EF9DB;
		data [7] = 75'h0004048684D129F5D32;
		data [8] = 75'h0003F72611593C60001;
		data [9] = 75'h000C0100FF20BD91970;
		data [10] = 75'h000C0BAD7E6A5048159;
		data [11] = 75'h00040BBC674C4140EF3;
		data [12] = 75'h00040A69E94DB886091;
		data [13] = 75'h000C07D46072866091F;
		clk = 0;
		din = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#90;
		rst = 0;
		#10 en = 1;
		for (j=0; j<=13; j=j+1) begin
            din = data [j];
			for (i=74; i>=0; i=i-1) begin
				#10;
			end
		end
		#10; 
		$finish();
	end

	always #5 clk = ~clk;
	always @(posedge clk) begin
		out = {out[73:0], dout};
		if(tFlag)
			$display("OUT: %h", out);
	end
      
endmodule

