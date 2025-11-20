// deprecated: use vga_rtl_top.v instead
module vga_controller (
    input wire clk,          // Pixel clock
    input wire reset,        // Reset signal
    output reg hsync,        // Horizontal sync signal
    output reg vsync,        // Vertical sync signal
    output reg [9:0] x,      // Current pixel x-coordinate
    output reg [9:0] y,      // Current pixel y-coordinate
    output reg active_video  // Active video signal
);

    // VGA timing parameters for 640x480 @ 60 Hz
    localparam H_DISPLAY = 640;  // Horizontal display area
    localparam H_FRONT = 16;     // Horizontal front porch
    localparam H_SYNC = 96;      // Horizontal sync pulse
    localparam H_BACK = 48;      // Horizontal back porch
    localparam H_TOTAL = H_DISPLAY + H_FRONT + H_SYNC + H_BACK;

    localparam V_DISPLAY = 480;  // Vertical display area
    localparam V_FRONT = 10;     // Vertical front porch
    localparam V_SYNC = 2;       // Vertical sync pulse
    localparam V_BACK = 33;      // Vertical back porch
    localparam V_TOTAL = V_DISPLAY + V_FRONT + V_SYNC + V_BACK;

    // Horizontal and vertical counters
    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;

    // Generate horizontal and vertical sync signals
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h_count <= 0;
            v_count <= 0;
            hsync <= 1;
            vsync <= 1;
            x <= 0;
            y <= 0;
            active_video <= 0;
        end else begin
            // Horizontal counter
            if (h_count == H_TOTAL - 1) begin
                h_count <= 0;
                // Vertical counter
                if (v_count == V_TOTAL - 1) begin
                    v_count <= 0;
                end else begin
                    v_count <= v_count + 1;
                end
            end else begin
                h_count <= h_count + 1;
            end

            // Generate horizontal sync
            hsync <= (h_count >= H_DISPLAY + H_FRONT) && (h_count < H_DISPLAY + H_FRONT + H_SYNC);

            // Generate vertical sync
            vsync <= (v_count >= V_DISPLAY + V_FRONT) && (v_count < V_DISPLAY + V_FRONT + V_SYNC);

            // Calculate pixel coordinates
            x <= (h_count < H_DISPLAY) ? h_count : 0;
            y <= (v_count < V_DISPLAY) ? v_count : 0;

            // Active video signal
            active_video <= (h_count < H_DISPLAY) && (v_count < V_DISPLAY);
        end
    end

endmodule