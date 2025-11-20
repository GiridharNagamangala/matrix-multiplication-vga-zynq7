module vga_rtl_top (
    input  wire clk,         // System clock input
    input  wire reset_n,     // Active low reset
    output wire hsync,       // Horizontal sync output
    output wire vsync,       // Vertical sync output
    output wire hblank,      // Horizontal blanking signal
    output wire vblank,      // Vertical blanking signal
    output wire [10:0] h_count, // Horizontal pixel count
    output wire [10:0] v_count  // Vertical pixel count
);

    // Clock divider instance to generate pixel clock from system clock
    wire pixel_clk, v_en;
    clk_divider #(
        .DIVIDE_BY(4) // Adjust this value based on system clock frequency to get desired pixel clock
    ) clk_div_inst (
        .clk_in(clk),
        .reset_n(reset_n),
        .clk_out(pixel_clk)
    );

    // Horizontal counter instance
    horizontal_counter horiz_counter_inst (
        .clk(pixel_clk),
        .reset_n(reset_n),
        .hsync(hsync),
        .hblank(hblank),
        .en_v_count(v_en),
        .h_count(h_count)
    );

    // Vertical counter instance
    vertical_counter vert_counter_inst (
        .clk(pixel_clk),
        .reset_n(reset_n),
        .en_v_count(v_en),
        .vsync(vsync),
        .vblank(vblank),
        .v_count(v_count)
    );

endmodule