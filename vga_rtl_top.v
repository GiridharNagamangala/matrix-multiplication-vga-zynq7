module vga_rtl_top #(
    // parameter X11 = 100, parameter X21 = 200, parameter X31 = 300,
    // parameter X12 = 108, parameter X22 = 208, parameter X32 = 308,
    // parameter X13 = 116, parameter X23 = 216, parameter X33 = 316,
    // parameter Y1 = 50, parameter Y2 = 70, parameter Y3 = 90
    parameter X0 = 100, parameter Y0 = 50,
    parameter MATRIX_N = 3, parameter MATRIX_M = 3, parameter DIGITS = 5
)(
    input  wire clk,         // System clock input
    input  wire reset,     // Active low reset
    output wire hsync,       // Horizontal sync output
    output wire vsync,       // Vertical sync output
    output wire hblank,      // Horizontal blanking signal
    output wire vblank,      // Vertical blanking signal
    output wire [3:0] vga_r, // VGA Red out
    output wire [3:0] vga_g, // VGA Green out
    output wire [3:0] vga_b // VGA Blue out
);

    // Clock divider instance to generate pixel clock from system clock
    wire pixel_clk, bram_clk, v_en;
    wire [10:0] h_count, v_count;
    wire [(MATRIX_M * MATRIX_N * DIGITS * 3)-1:0] pixel;

    clk_divider #(
        .DIVIDE_BY(4) // Adjust this value based on system clock frequency to get desired pixel clock
    ) clk_div_inst (
        .clk_in(clk),
        .reset(reset),
        .clk_out(pixel_clk),
        .clk_ram(bram_clk)
    );

    // Horizontal counter instance
    horizontal_counter horiz_counter_inst (
        .clk(clk),
        .clk_en(pixel_clk),
        .reset(reset),
        .hsync(hsync),
        .hblank(hblank),
        .en_v_count(v_en),
        .h_count(h_count)
    );

    // Vertical counter instance
    vertical_counter vert_counter_inst (
        .clk(clk),
        .clk_en(pixel_clk),
        .reset(reset),
        .en_v_count(v_en),
        .vsync(vsync),
        .vblank(vblank),
        .v_count(v_count)
    );

    genvar i, j, k, l;
    generate
        for (i = 0; i < MATRIX_N; i = i + 1) begin : row_loop
            for (j = 0; j < 3; j = j + 1) begin : matrix_loop
                for (k = 0; k < MATRIX_M; k = k + 1) begin : col_loop
                    for (l = 0; l < DIGITS; l = l + 1) begin : digit_loop
                        digit_8x16 #(
                            .XSTART(X0 + (l * 8) + (k * 55) + (j * 165)),
                            .YSTART(Y0 + (i * 30))
                        ) digit_inst (
                            .clk(bram_clk),
                            .h_count(h_count),
                            .v_count(v_count),
                            .bcd(4'h5),
                            .pixon(pixel[(i * MATRIX_M * DIGITS * 3) + (j * MATRIX_M * DIGITS) + (k * DIGITS) + l])
                        );
                    end
                end
            end
        end
    endgenerate

    // VGA Output colour assignment
    assign vga_r = |pixel ? 4'hf : 4'h0;
    assign vga_g = |pixel ? 4'hf : 4'h0;
    assign vga_b = |pixel ? 4'hf : 4'h0;

endmodule
