`timescale 1ns/1ps
`define SIMULATION

module AsyncFIFO_Test;
    localparam DATA_WIDTH  = 8;
    localparam FIFO_Depth  = 16;
    localparam ptr_size    = $clog2(FIFO_Depth);  // = 4

    reg wr_enb, rd_enb;
    reg wr_clk = 0;
    reg rd_clk = 0;
    reg rst;
    reg [DATA_WIDTH-1:0] d_in;

    wire [DATA_WIDTH-1:0] data_out;
    wire full, empty;

    // wr_clk = 25 MHz  (period = 40 ns, half = 20 ns)
    // rd_clk = 50 MHz  (period = 20 ns, half = 10 ns)
    always #20 wr_clk = ~wr_clk;
    always #10 rd_clk = ~rd_clk;

    // Feed wr_clk as the top-level clk so Async_FIFO's assign
    // wr_clk = clk and rd_clk = clk each get a real clock in sim.
    // The two clocks are independent - each submodule uses the
    // correct one via the internal wires.
    Async_FIFO #(
        .width   (DATA_WIDTH),
        .depth   (FIFO_Depth),
        .ptr_size(ptr_size)
    ) dut (
        .wr_enb  (wr_enb),
        .clk     (wr_clk),   // unused in sim - clocks come from always blocks
        .data_in (d_in),
        .rd_enb  (rd_enb),
        .rst     (rst),
        .data_out(data_out),
        .full    (full),
        .empty   (empty)
    );

    // ---- override internal clocks directly for simulation ----
    // Because `ifdef SIMULATION assigns wr_clk/rd_clk = clk (same net),
    // we force the internal wires to the correct independent clocks.
    // This is the cleanest way without modifying submodule ports.
    assign dut.wr_clk = wr_clk;
    assign dut.rd_clk = rd_clk;

    integer i;

    initial begin
        rst    = 1;
        wr_enb = 0;
        rd_enb = 0;
        d_in   = 0;
        #40;
        rst = 0;

        // --- burst write 5 values ---
        wr_enb = 1;
        for (i = 0; i < 5; i = i + 1) begin
            d_in = i;
            @(posedge wr_clk); #1;
        end
        wr_enb = 0;

        // --- wait then read 3 values ---
        #80;
        rd_enb = 1;
        repeat(3) @(posedge rd_clk);
        rd_enb = 0;

        // --- burst write 8 more values ---
        #40;
        wr_enb = 1;
        for (i = 5; i < 13; i = i + 1) begin
            d_in = i;
            @(posedge wr_clk); #1;
        end
        wr_enb = 0;

        // --- read until empty ---
        #80;
        rd_enb = 1;
        while (!empty) @(posedge rd_clk);
        rd_enb = 0;

        // --- fill FIFO fully ---
        wr_enb = 1;
        for (i = 100; i < 100 + FIFO_Depth; i = i + 1) begin
            d_in = i;
            @(posedge wr_clk); #1;
        end
        wr_enb = 0;

        // --- read half ---
        #60;
        rd_enb = 1;
        repeat(FIFO_Depth/2) @(posedge rd_clk);
        rd_enb = 0;

        // --- write while reading (overlap) ---
        #20;
        wr_enb = 1;
        for (i = 200; i < 204; i = i + 1) begin
            d_in = i;
            @(posedge wr_clk); #1;
        end
        wr_enb = 0;

        rd_enb = 1;
        repeat(FIFO_Depth/2 + 4) @(posedge rd_clk);
        rd_enb = 0;

        #100;
        $display("Simulation complete.");
        $finish;
    end

    initial begin
        $dumpfile("async_FIFO.vcd");
        $dumpvars(0, AsyncFIFO_Test);
    end

endmodule