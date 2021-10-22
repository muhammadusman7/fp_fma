`timescale 1ns / 1ps
`define NULL 0

module fma_tb;

    integer               data_file; // file handler
    integer               scan_file; // file handler
    integer               txt_write;

    parameter WIDTH = 64;
    reg       clk = 1'b0;
    reg       rst = 1'b0;
    reg       [WIDTH-1:0] count;
    reg       [WIDTH-1:0] in_a0, in_a1, in_a2, in_a3;       // Multiplier
    reg       [WIDTH-1:0] in_b0, in_b1, in_b2, in_b3;       // Multiplicand / Addened0
    reg       [WIDTH-1:0] in_c0, in_c1, in_c2, in_c3;       // Addened / Addened1
    reg       [1:0]       mode;           // 11 (DP Datapath), 10 (SP Datapath), 01 (HP Datapath)
    reg       [1:0]       precision;      // 11 (Double), 10 (Single), 01(Half)
    reg       [1:0]       op; 
    reg       [5:0]       u_a0, u_a1, u_a2, u_a3;     // Input certainty of A, B and C
    reg       [5:0]       u_b0, u_b1, u_b2, u_b3;
    reg       [5:0]       u_c0, u_c1, u_c2, u_c3;
    wire      [WIDTH-1:0] out0, out1, out2, out3;         // Output
    wire      [3:0]       ufout, ofout, infout, zout, NaNout;
    wire      [5:0]       uo0, uo1, uo2, uo3;

    fma #(.WIDTH(WIDTH)) uut( .clk(clk), .rst(rst), .in_a0(in_a0), .in_a1(in_a1), .in_a2(in_a2), .in_a3(in_a3), 
        .in_b0(in_b0), .in_b1(in_b1), .in_b2(in_b2), .in_b3(in_b3), .in_c0(in_c0), .in_c1(in_c1),
        .in_c2(in_c2), .in_c3(in_c3), .u_a0(u_a0), .u_a1(u_a1), .u_a2(u_a2), .u_a3(u_a3), 
        .u_b0(u_b0), .u_b1(u_b1), .u_b2(u_b2), .u_b3(u_b3), .u_c0(u_c0), .u_c1(u_c1),
        .u_c2(u_c2), .u_c3(u_c3), .mode(mode), .precision(precision), .op(op), .out0(out0), .out1(out1),
        .out2(out2), .out3(out3), .ufout(ufout), .ofout(ofout), .infout(infout), .zout(zout), .NaNout(NaNout),
        .uo0(uo0), .uo1(uo1), .uo2(uo2), .uo3(uo3) );
    
    initial begin
        rst = 1'b0; #5 rst = 1'b1; #5 rst = 1'b0;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        data_file = $fopen("input.txt", "r");
        if (data_file == `NULL) begin
            $display("data_file handle was NULL");
            $finish;
        end
        txt_write = $fopen("output.txt");
        count = 0;
        op = 2'b11; mode = 2'b11; precision = 2'b11; clk = 1'b0;
        u_a0 = 6'd53; u_a1 = 6'd53; u_a2 = 6'd53; u_a3 = 6'd53;
        u_b0 = 6'd53; u_b1 = 6'd53; u_b2 = 6'd53; u_b3 = 6'd53;
        u_c0 = 6'd53; u_c1 = 6'd53; u_c2 = 6'd53; u_c3 = 6'd53;
        in_a0 = 64'b0; in_b0 = 64'b0; in_c0 = 64'b0;
        in_a1 = 64'b0; in_b1 = 64'b0; in_c1 = 64'b0;
        in_a2 = 64'b0; in_b2 = 64'b0; in_c2 = 64'b0;
        in_a3 = 64'b0; in_b3 = 64'b0; in_c3 = 64'b0;  
    end

    always @(posedge clk) begin
        scan_file = $fscanf(data_file, "%h\n", in_a0);
        scan_file = $fscanf(data_file, "%h\n", in_b0);
        scan_file = $fscanf(data_file, "%h\n", in_c0); 
        $fmonitor(txt_write , "%h", in_a0);
        $fmonitor(txt_write , "%h", in_b0);
        $fmonitor(txt_write , "%h", in_c0);
        $fmonitor(txt_write , "%h", out0);
        data_file = data_file;
        txt_write = txt_write;
        count = count + 1;
        $display("Iteration: %d", count);
        if($feof(data_file)) begin
            $fclose(data_file);
            $fclose(txt_write);
            $finish();
        end
    end

endmodule