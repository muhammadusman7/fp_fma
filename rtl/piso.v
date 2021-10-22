// Title: Paralel in Serial Out V 1.0 (No Changelog)
// Created: 
// Updated: 
//---------------------------------------------------------------------------
// 
// 
//
//---------------------------------------------------------------------------
module piso (
	input         clk,
	input         rst,
	input         en,
	input  		  [74:0] din,
	output reg    tFlag,		// Transmission Completed
	output reg    dout,
	output reg 	  [2:0]  row	
);

	reg [6:0]  bit_count;
	reg [74:0] data_reg;

	always @(posedge clk or posedge rst) begin
		if(rst) begin
			data_reg	<= 75'd0;
			bit_count	<= 7'd75;
			tFlag		<= 0;
			dout 		<= 1'b0;
			row			<= 4'd0;
		end else begin
			
			if (en && bit_count <= 7'd75) begin
				if (bit_count == 7'd75) begin
					data_reg	<= din;
					bit_count 	<= 7'd1;
					tFlag		<= 1'b1;
					dout 		<= data_reg[74];
					if(row == 3'd4) begin
						row		<= 3'd1;
					end else begin
						row		<= row + 3'd1;
					end
				end else begin
					data_reg	<= {data_reg[73:0], 1'b0};
					bit_count 	<= bit_count + 7'd1;
					tFlag		<= 1'b0;
					dout 		<= data_reg[74];
					row			<= row;
				end
			end else begin
				data_reg	<= data_reg;
				bit_count 	<= bit_count;
				tFlag		<= tFlag;
				dout 		<= dout;
				row			<= row;
			end
		end
	end

endmodule