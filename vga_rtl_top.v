module vga_rtl_top #(
    parameter X11 = 100, parameter X21 = 200, parameter X31 = 300,
    parameter X12 = 108, parameter X22 = 208, parameter X32 = 308,
    parameter X13 = 116, parameter X23 = 216, parameter X33 = 316,
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
    wire p111, p112, p113, p121, p122, p123, p131, p132, p133,
         p211, p212, p213, p221, p222, p223, p231, p232, p233,
         p311, p312, p313, p321, p322, p323, p331, p332, p333;

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

    // Number 1 digit 1
    digit_8x16 #(
        .XSTART(X11),
        .YSTART(Y1)
    ) digit_display_inst111 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h1), // BCD code for digit '9'
        .pixon(p111)
    );

    // number 1 digit 2
    digit_8x16 #(
        .XSTART(X12),
        .YSTART(Y1)
    ) digit_display_inst112 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h2), // BCD code for digit '9'
        .pixon(p112)
    );

    // number 1 digit 3
    digit_8x16 #(
        .XSTART(X13),
        .YSTART(Y1)
    ) digit_display_inst113 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h3), // BCD code for digit '9'
        .pixon(p113)
    );

    // number 2 digit 1
    digit_8x16 #(
        .XSTART(X21),
        .YSTART(Y1)
    ) digit_display_inst121 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h4), // BCD code for digit '9'
        .pixon(p121)
    );

    // number 2 digit 2
    digit_8x16 #(
        .XSTART(X22),
        .YSTART(Y1)
    ) digit_display_inst122 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h5), // BCD code for digit '9'
        .pixon(p122)
    );

    // number 2 digit 3
    digit_8x16 #(
        .XSTART(X23),
        .YSTART(Y1)
    ) digit_display_inst123 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h6), // BCD code for digit '9'
        .pixon(p123)
    );

    // number 3 digit 1
    digit_8x16 #(
        .XSTART(X31),
        .YSTART(Y1)
    ) digit_display_inst131 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h7), // BCD code for digit '9'
        .pixon(p131)
    );

    // number 3 digit 2
    digit_8x16 #(
        .XSTART(X32),
        .YSTART(Y1)
    ) digit_display_inst132 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h8), // BCD code for digit '9'
        .pixon(p132)
    );

    // number 3 digit 3
    digit_8x16 #(
        .XSTART(X33),
        .YSTART(Y1)
    ) digit_display_inst133 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h9), // BCD code for digit '9'
        .pixon(p133)
    );

    // Number 4 digit 1
    digit_8x16 #(
        .XSTART(X11),
        .YSTART(Y2)
    ) digit_display_inst211 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h1), // BCD code for digit '9'
        .pixon(p211)
    );

    // number 4 digit 2
    digit_8x16 #(
        .XSTART(X12),
        .YSTART(Y2)
    ) digit_display_inst212 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h2), // BCD code for digit '9'
        .pixon(p212)
    );

    // number 4 digit 3
    digit_8x16 #(
        .XSTART(X13),
        .YSTART(Y2)
    ) digit_display_inst213 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h3), // BCD code for digit '9'
        .pixon(p213)
    );

    // number 5 digit 1
    digit_8x16 #(
        .XSTART(X21),
        .YSTART(Y2)
    ) digit_display_inst221 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h4), // BCD code for digit '9'
        .pixon(p221)
    );

    // number 5 digit 2
    digit_8x16 #(
        .XSTART(X22),
        .YSTART(Y2)
    ) digit_display_inst222 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h5), // BCD code for digit '9'
        .pixon(p222)
    );

    // number 5 digit 3
    digit_8x16 #(
        .XSTART(X23),
        .YSTART(Y2)
    ) digit_display_inst223 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h6), // BCD code for digit '9'
        .pixon(p223)
    );

    // number 6 digit 1
    digit_8x16 #(
        .XSTART(X31),
        .YSTART(Y2)
    ) digit_display_inst231 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h7), // BCD code for digit '9'
        .pixon(p231)
    );

    // number 6 digit 2
    digit_8x16 #(
        .XSTART(X32),
        .YSTART(Y2)
    ) digit_display_inst232 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h8), // BCD code for digit '9'
        .pixon(p232)
    );

    // number 6 digit 3
    digit_8x16 #(
        .XSTART(X33),
        .YSTART(Y2)
    ) digit_display_inst233 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h9), // BCD code for digit '9'
        .pixon(p233)
    );

    // Number 7 digit 1
    digit_8x16 #(
        .XSTART(X11),
        .YSTART(Y3)
    ) digit_display_inst311 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h1), // BCD code for digit '9'
        .pixon(p311)
    );

    // number 7 digit 2
    digit_8x16 #(
        .XSTART(X12),
        .YSTART(Y3)
    ) digit_display_inst312 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h2), // BCD code for digit '9'
        .pixon(p312)
    );

    // number 7 digit 3
    digit_8x16 #(
        .XSTART(X13),
        .YSTART(Y3)
    ) digit_display_inst313 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h3), // BCD code for digit '9'
        .pixon(p313)
    );

    // number 8 digit 1
    digit_8x16 #(
        .XSTART(X21),
        .YSTART(Y3)
    ) digit_display_inst321 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h4), // BCD code for digit '9'
        .pixon(p321)
    );

    // number 8 digit 2
    digit_8x16 #(
        .XSTART(X22),
        .YSTART(Y3)
    ) digit_display_inst322 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h5), // BCD code for digit '9'
        .pixon(p322)
    );

    // number 8 digit 3
    digit_8x16 #(
        .XSTART(X23),
        .YSTART(Y3)
    ) digit_display_inst323 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h6), // BCD code for digit '9'
        .pixon(p323)
    );

    // number 9 digit 1
    digit_8x16 #(
        .XSTART(X31),
        .YSTART(Y3)
    ) digit_display_inst331 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h7), // BCD code for digit '9'
        .pixon(p331)
    );

    // number 9 digit 2
    digit_8x16 #(
        .XSTART(X32),
        .YSTART(Y3)
    ) digit_display_inst332 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h8), // BCD code for digit '9'
        .pixon(p332)
    );

    // number 9 digit 3
    digit_8x16 #(
        .XSTART(X33),
        .YSTART(Y3)
    ) digit_display_inst333 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h9), // BCD code for digit '9'
        .pixon(p333)
    );

    assign vga_r = (p111 || p112 || p113 || p121 || p122 || p123 || p131 || p132 || p133 || p211 || p212 || p213 || p221 || p222 || p223 || p231 || p232 || p233 || p311 || p312 || p313 || p321 || p322 || p323 || p331 || p332 || p333) ? 4'hf : 4'h0;
    assign vga_g = (p111 || p112 || p113 || p121 || p122 || p123 || p131 || p132 || p133 || p211 || p212 || p213 || p221 || p222 || p223 || p231 || p232 || p233 || p311 || p312 || p313 || p321 || p322 || p323 || p331 || p332 || p333) ? 4'hf : 4'h0;
    assign vga_b = (p111 || p112 || p113 || p121 || p122 || p123 || p131 || p132 || p133 || p211 || p212 || p213 || p221 || p222 || p223 || p231 || p232 || p233 || p311 || p312 || p313 || p321 || p322 || p323 || p331 || p332 || p333) ? 4'hf : 4'h0;

endmodule
