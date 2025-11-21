module vga_rtl_top (
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
    wire pixel_on;

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

    // assign vga_r = (((h_count < 305 && h_count > 300) || (h_count < 600 && h_count > 595)) && (v_count < 500 && v_count > 200)) ? 4'hf : 4'h0; // (143, 784), (35, 515)
    // assign vga_g = (((h_count < 305 && h_count > 300) || (h_count < 600 && h_count > 595)) && (v_count < 500 && v_count > 200)) ? 4'hf : 4'h0; // (143, 784), (35, 515)
    // assign vga_b = (((h_count < 305 && h_count > 300) || (h_count < 600 && h_count > 595)) && (v_count < 500 && v_count > 200)) ? 4'hf : 4'h0; // (143, 784), (35, 515)

    // Digit display instance (added bcd code for number '91' temporarily)
    digit_8x16 #(
        .XSTART(100),
        .YSTART(50)
    ) digit_display_inst1 (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'h5), // BCD code for digit '9'
        .pixon(pixel_on)
    );

    assign vga_r = pixel_on ? 4'hf : 4'h0;
    assign vga_g = pixel_on ? 4'hf : 4'h0;
    assign vga_b = pixel_on ? 4'hf : 4'h0;

endmodule
