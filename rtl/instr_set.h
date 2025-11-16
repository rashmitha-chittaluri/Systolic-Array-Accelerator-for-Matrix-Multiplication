`timescale 1ns / 1ps

module tpu_fpga_wrapper(
    input clk,
    input srstn,
    input tpu_start,
    output tpu_done
);

    // Internal dummy signals to connect to tpu_top
    wire [31:0] sram_rdata_w0 = 32'd0;
    wire [31:0] sram_rdata_w1 = 32'd0;
    wire [31:0] sram_rdata_d0 = 32'd0;
    wire [31:0] sram_rdata_d1 = 32'd0;

    wire [9:0] sram_raddr_w0;
    wire [9:0] sram_raddr_w1;
    wire [9:0] sram_raddr_d0;
    wire [9:0] sram_raddr_d1;

    wire sram_write_enable_a0, sram_write_enable_b0, sram_write_enable_c0;
    wire [127:0] sram_wdata_a, sram_wdata_b, sram_wdata_c;
    wire [5:0] sram_waddr_a, sram_waddr_b, sram_waddr_c;

    // Instantiate your actual TPU design
    tpu_top uut (
        .clk(clk),
        .srstn(srstn),
        .tpu_start(tpu_start),
        .tpu_done(tpu_done),

        .sram_rdata_w0(sram_rdata_w0),
        .sram_rdata_w1(sram_rdata_w1),
        .sram_rdata_d0(sram_rdata_d0),
        .sram_rdata_d1(sram_rdata_d1),

        .sram_raddr_w0(sram_raddr_w0),
        .sram_raddr_w1(sram_raddr_w1),
        .sram_raddr_d0(sram_raddr_d0),
        .sram_raddr_d1(sram_raddr_d1),

        .sram_write_enable_a0(sram_write_enable_a0),
        .sram_wdata_a(sram_wdata_a),
        .sram_waddr_a(sram_waddr_a),

        .sram_write_enable_b0(sram_write_enable_b0),
        .sram_wdata_b(sram_wdata_b),
        .sram_waddr_b(sram_waddr_b),

        .sram_write_enable_c0(sram_write_enable_c0),
        .sram_wdata_c(sram_wdata_c),
        .sram_waddr_c(sram_waddr_c)
    );

endmodule
