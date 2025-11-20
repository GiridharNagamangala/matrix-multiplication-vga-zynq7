module vga_rgb_test (
    input  wire       clk,       // pixel clock (25 MHz for 640x480@60)
    input  wire       reset,     // synchronous reset
    output wire       hsync,
    output wire       vsync,
    output wire [2:0] red,       // 3-bit red
    output wire [2:0] green,     // 3-bit green
    output wire [2:0] blue       // 3-bit blue
);

    // VGA controller signals
    wire [9:0] x;
    wire [9:0] y;
    wire       active_video;

    // Instantiate VGA sync generator
    vga_controller VGA (
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .x(x),
        .y(y),
        .active_video(active_video)
    );

    // Simple test pattern:
    // - Red channel: horizontal gradient from x (top 3 bits)
    // - Green channel: vertical gradient from y (top 3 bits)
    // - Blue channel: checker-ish pattern from LSBs of x,y
    wire [2:0] r_pix = x[9:7];
    wire [2:0] g_pix = y[9:7];
    wire [2:0] b_pix = { (x[6] ^ y[6]), (x[7] ^ y[7]), (x[8] ^ y[8]) };

    // Drive outputs only during active video, otherwise black
    assign red   = active_video ? r_pix : 3'b000;
    assign green = active_video ? g_pix : 3'b000;
    assign blue  = active_video ? b_pix : 3'b000;

endmodule