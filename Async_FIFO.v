module Async_FIFO #(
    parameter width    = 8,
    parameter ptr_size = 4,
    parameter depth    = 16
    )(
    input  wr_enb,
    input  clk,
    input  [width-1:0] data_in,
    input  rd_enb,
    input  rst,
    output [width-1:0] data_out,
    output full,
    output empty
    );
 
    wire wr_clk, rd_clk;
    wire locked;
    wire rst_safe = rst | ~locked;   // hold reset until PLL locks
 
    wire [ptr_size:0] b_rd_ptr, b_wr_ptr;
    wire [ptr_size:0] g_wr_ptr, g_rd_ptr;
    wire [ptr_size:0] g_wr_ptr_sync, g_rd_ptr_sync;
 
`ifdef SIMULATION
    // -------------------------------------------------
    // Simulation: bypass clk_wiz_0
    // wr_clk and rd_clk are driven directly from TB
    // so just assign them from the clk port (unused here)
    // The TB overrides these via the always blocks
    // -------------------------------------------------
    assign wr_clk = clk;   // TB drives wr_clk separately - see note below
    assign rd_clk = clk;
    assign locked = 1'b1;  // assume locked immediately in sim
`else
    // -------------------------------------------------
    // Synthesis: use Clocking Wizard (MMCM)
    // clk_out1 = 25 MHz = rd_clk
    // clk_out2 = 50 MHz = wr_clk
    // -------------------------------------------------
    clk_wiz_0 instance_name (
        .clk_in1 (clk),
        .clk_out1(wr_clk),
        .clk_out2(rd_clk),
        .reset   (rst),
        .locked  (locked)
    );
`endif
 
    fifo_mem #(
        .width(width), .ptr_size(ptr_size), .depth(depth)
    ) MEM (
        .d_in  (data_in),  .wr_ptr(b_wr_ptr), .rd_ptr(b_rd_ptr),
        .wr_clk(wr_clk),   .rd_clk(rd_clk),
        .full  (full),     .empty (empty),
        .wr_en (wr_enb),   .rd_en (rd_enb),
        .d_out (data_out)
    );
 
    WRITE_PTR #(.ptr_size(ptr_size)) W_handler (
        .wr_clk    (wr_clk),
        .wr_en     (wr_enb),
        .rst       (rst_safe),
        .g_rptr_sync(g_rd_ptr_sync),
        .full      (full),
        .b_wptr    (b_wr_ptr),
        .g_wptr    (g_wr_ptr)
    );
 
    READ_PTR #(.ptr_size(ptr_size)) R_handler (
        .rd_clk      (rd_clk),
        .rd_en       (rd_enb),
        .rst         (rst_safe),
        .g_wr_ptr_sync(g_wr_ptr_sync),
        .empty       (empty),
        .b_rd_ptr    (b_rd_ptr),
        .g_rd_ptr    (g_rd_ptr)
    );
 
    // synchronise g_rd_ptr into wr_clk domain
    TwoFFSynchronizer #(.DATA_WIDTH(ptr_size)) F1 (
        .clk  (wr_clk),
        .rst  (rst_safe),
        .d_in (g_rd_ptr),
        .d_out(g_rd_ptr_sync)
    );
 
    // synchronise g_wr_ptr into rd_clk domain
    TwoFFSynchronizer #(.DATA_WIDTH(ptr_size)) F2 (
        .clk  (rd_clk),
        .rst  (rst_safe),
        .d_in (g_wr_ptr),
        .d_out(g_wr_ptr_sync)
    );
 
endmodule
 