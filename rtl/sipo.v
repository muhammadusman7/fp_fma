// Title: Serial In Paralell Out V 1.0 (No Changelog)
// Created: Septmeber 29, 2021
// Updated: 
//---------------------------------------------------------------------------
// 
// 
//
//---------------------------------------------------------------------------
module sipo (
	input       en,
	input       clk,
	input       din,
	input		rst,
	output reg  load,
	output reg  [69:0] dout,
	output reg 	[3:0]  row
);


	reg [6:0] 	bit_count;
	reg [69:0] 	data_reg;
    
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			data_reg	<= 70'd0;
			bit_count	<= 7'd0;
			load		<= 0;
			dout 		<= 70'd0;
			row			<= 4'd0;
		end else begin
			if (en && bit_count <= 7'd70) begin
				if (bit_count == 7'd70) begin
					data_reg	<= {data_reg[68:0], din};
					bit_count 	<= 7'd1;
					load		<= 1'b1;
					dout 		<= data_reg;
					if(row == 4'd12) begin
						row		<= 4'd1;
					end else begin
						row		<= row + 4'd1;
					end
				end else begin
					data_reg	<= {data_reg[68:0], din};
					bit_count 	<= bit_count + 7'd1;
					load		<= 1'b0;
					dout 		<= dout;
					row			<= row;
				end
			end else begin
				data_reg	<= data_reg;
				bit_count 	<= bit_count;
				load		<= load;
				dout 		<= dout;
				row			<= row;
			end
		end
	end

endmodule