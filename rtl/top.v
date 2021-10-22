// Title: Top Integration Module V 1.0 (No Changelog)
// Created: Septmeber 29, 2021
// Updated: 
//---------------------------------------------------------------------------
// Integrates the final FMA with SIPO and PISO
// 
//
//---------------------------------------------------------------------------
module top (
    input           clk,
    input           rst_sipo,
    input           rst_piso,
    input           en_sipo,
    input           din,
    input           en_piso,
    input   [1:0]   mode,
    input   [1:0]   precision,
    input   [1:0]   op,
    output          rFlag,
    output          dout,
    output          tFlag
);

    parameter WIDTH = 64;

    reg  [63:0] in_a0, in_a1, in_a2, in_a3;
    reg  [63:0] in_b0, in_b1, in_b2, in_b3;
    reg  [63:0] in_c0, in_c1, in_c2, in_c3;
    reg  [5:0]  u_a0, u_a1, u_a2, u_a3;     // Input certainty of A, B and C
    reg  [5:0]  u_b0, u_b1, u_b2, u_b3;
    reg  [5:0]  u_c0, u_c1, u_c2, u_c3;
    wire [5:0]  uo0, uo1, uo2, uo3;
    wire [63:0] out0, out1, out2, out3;
    wire [69:0] sipo_out;
    reg  [74:0] piso_din;
    reg  [69:0] discard;
    wire [3:0]  sipo_row, ufout, ofout, infout, zout, NaNout;
    wire [2:0]  piso_row;

    sipo in ( .en(en_sipo), .clk(clk), .din(din), .rst(rst_sipo), .load(rFlag), .dout(sipo_out), .row(sipo_row) );
    
    fma #(.WIDTH(WIDTH)) fma_inst( .clk(clk), .rst(rst_piso && rst_sipo), .in_a0(in_a0), .in_a1(in_a1), .in_a2(in_a2), .in_a3(in_a3), 
        .in_b0(in_b0), .in_b1(in_b1), .in_b2(in_b2), .in_b3(in_b3), .in_c0(in_c0), .in_c1(in_c1), .in_c2(in_c2),
        .in_c3(in_c3), .u_a0(u_a0), .u_a1(u_a1), .u_a2(u_a2), .u_a3(u_a3), .u_b0(u_b0), .u_b1(u_b1), .u_b2(u_b2),
        .u_b3(u_b3), .u_c0(u_c0), .u_c1(u_c1), .u_c2(u_c2), .u_c3(u_c3), .mode(mode), .precision(precision), .op(op),
        .out0(out0), .out1(out1), .out2(out2), .out3(out3), .ufout(ufout), .ofout(ofout), .infout(infout), .zout(zout),
        .NaNout(NaNout), .uo0(uo0), .uo1(uo1), .uo2(uo2), .uo3(uo3) );
    
    piso out ( .en(en_piso), .clk(clk), .din(piso_din), .rst(rst_piso), .tFlag(tFlag), .dout(dout), .row(piso_row) );

    always @(*) begin
        if(en_sipo) begin
            case (sipo_row)
                4'b0001: {u_a0, in_a0} = sipo_out;
                4'b0010: {u_b0, in_b0} = sipo_out;
                4'b0011: {u_c0, in_c0} = sipo_out;
                4'b0100: {u_a1, in_a1} = sipo_out;
                4'b0101: {u_b1, in_b1} = sipo_out;
                4'b0110: {u_c1, in_c1} = sipo_out;
                4'b0111: {u_a2, in_a2} = sipo_out;
                4'b1000: {u_b2, in_b2} = sipo_out;
                4'b1001: {u_c2, in_c2} = sipo_out;
                4'b1010: {u_a3, in_a3} = sipo_out;
                4'b1011: {u_b3, in_b3} = sipo_out;
                4'b1100: {u_c3, in_c3} = sipo_out;
                default: discard = sipo_out;
            endcase
        end
        if(en_piso) begin
            case (piso_row)
                3'b001: piso_din = {uo0, ufout[0], ofout[0], infout[0], zout[0], NaNout[0], out0};
                3'b010: piso_din = {uo1, ufout[1], ofout[1], infout[1], zout[1], NaNout[1], out1};
                3'b011: piso_din = {uo2, ufout[2], ofout[2], infout[2], zout[2], NaNout[2], out2};
                3'b100: piso_din = {uo3, ufout[3], ofout[3], infout[3], zout[3], NaNout[3], out3};
                default: piso_din = {uo0, ufout[0], ofout[0], infout[0], zout[0], NaNout[0], out0};
            endcase
        end
    end
    
endmodule