`timescale 1ns / 1ps

module tpu_fpga_wrapper(
    input clk,
    input srstn,        // Connected to BTN0
    input tpu_start,    // Connected to BTN1
    output reg led0     // Connected to LED0
);

    // Internal dummy SRAM data
    wire [31:0] sram_rdata_w0 = 32'd0;
    wire [31:0] sram_rdata_w1 = 32'd0;
    wire [31:0] sram_rdata_d0 = 32'd0;
    wire [31:0] sram_rdata_d1 = 32'd0;

    wire [9:0] sram_raddr_w0, sram_raddr_w1;
    wire [9:0] sram_raddr_d0, sram_raddr_d1;

    wire sram_write_enable_a0, sram_write_enable_b0, sram_write_enable_c0;
    wire [127:0] sram_wdata_a, sram_wdata_b, sram_wdata_c;
    wire [5:0] sram_waddr_a, sram_waddr_b, sram_waddr_c;

    wire tpu_done;

    // Instantiate TPU core
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

    // ============================================================
    // LED blinking logic for visual verification
    // ============================================================
    reg [25:0] blink_counter = 0;
    reg blinking = 0;

    always @(posedge clk or negedge srstn) begin
        if (!srstn) begin
            blink_counter <= 0;
            blinking <= 0;
            led0 <= 0;
        end else begin
            if (tpu_done && !blinking) begin
                // Start blinking when TPU finishes
                blinking <= 1;
                blink_counter <= 0;
            end else if (blinking) begin
                blink_counter <= blink_counter + 1;
                led0 <= blink_counter[22]; // slow toggle
                if (blink_counter > 50_000_000) begin // stop after ~1 second
                    blinking <= 0;
                    led0 <= 0;
                end
            end
        end
    end

endmodule
