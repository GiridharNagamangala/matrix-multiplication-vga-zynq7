module vga_rtl_top #(
    parameter X11 = 100, parameter X21 = 200, parameter X31 = 300,
    parameter X12 = 108, parameter X22 = 208, parameter X23 = 308,
    parameter X13 = 116, parameter X32 = 216, parameter X33 = 316,
    parameter Y1 = 50, parameter Y2 = 70, parameter Y3 = 90
)(
    input  wire clk,         // System clock input
    input  wire reset_n,     // Active low reset
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
    wire p11, p12, p13, p21, p22, p23, p31, p32, p33;

    clk_divider #(
        .DIVIDE_BY(4) // Adjust this value based on system clock frequency to get desired pixel clock
    ) clk_div_inst (
        .clk_in(clk),
        .reset_n(reset_n),
        .clk_out(pixel_clk),
        .clk_ram(bram_clk)
    );

    // Horizontal counter instance
    horizontal_counter horiz_counter_inst (
        .clk(clk),
        .clk_en(pixel_clk),
        .reset_n(reset_n),
        .hsync(hsync),
        .hblank(hblank),
        .en_v_count(v_en),
        .h_count(h_count)
    );

    // Vertical counter instance
    vertical_counter vert_counter_inst (
        .clk(clk),
        .clk_en(pixel_clk),
        .reset_n(reset_n),
        .en_v_count(v_en),
        .vsync(vsync),
        .vblank(vblank),
        .v_count(v_count)
    );

    // Digit display instance (added bcd code for number '91' temporarily)
    digit_8x16 #(
        .XSTART(X11),
        .YSTART(Y1)
    ) digit_display_inst11 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h9), // BCD code for digit '9'
        .pixon(p11)
    );

    digit_8x16 #(
        .XSTART(X12),
        .YSTART(Y1)
    ) digit_display_inst12 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h1), // BCD code for digit '9'
        .pixon(p12)
    );

    digit_8x16 #(
        .XSTART(X13),
        .YSTART(Y1)
    ) digit_display_inst13 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h1), // BCD code for digit '9'
        .pixon(p13)
    );

    digit_8x16 #(
        .XSTART(X21),
        .YSTART(Y2)
    ) digit_display_inst21 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h1), // BCD code for digit '9'
        .pixon(p21)
    );

    digit_8x16 #(
        .XSTART(X22),
        .YSTART(Y2)
    ) digit_display_inst22 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h1), // BCD code for digit '9'
        .pixon(p22)
    );

    digit_8x16 #(
        .XSTART(X23),
        .YSTART(Y3)
    ) digit_display_inst23 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h1), // BCD code for digit '9'
        .pixon(p23)
    );

    digit_8x16 #(
        .XSTART(X31),
        .YSTART(Y3)
    ) digit_display_inst31 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h1), // BCD code for digit '9'
        .pixon(p31)
    );

    digit_8x16 #(
        .XSTART(X32),
        .YSTART(Y3)
    ) digit_display_inst32 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h1), // BCD code for digit '9'
        .pixon(p32)
    );

    digit_8x16 #(
        .XSTART(X33),
        .YSTART(Y3)
    ) digit_display_inst33 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h1), // BCD code for digit '9'
        .pixon(p33)
    );

    assign vga_r = (p11 || p12 || p13 || p21 || p22 || p23 || p31 || p32 || p33) ? 4'hf : 4'h0;
    assign vga_g = (p11 || p12 || p13 || p21 || p22 || p23 || p31 || p32 || p33) ? 4'hf : 4'h0;
    assign vga_b = (p11 || p12 || p13 || p21 || p22 || p23 || p31 || p32 || p33) ? 4'hf : 4'h0;

endmodule
