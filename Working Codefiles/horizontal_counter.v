module horizontal_counter (
    input  wire clk,
    input wire clk_en,
    input  wire reset,
    output wire  hsync,
    output wire  hblank,
    output wire en_v_count,
    output reg [10:0] h_count
);

    // VGA 640x480 @60Hz timing parameters
    parameter H_VISIBLE_AREA   = 640;
    parameter H_FRONT_PORCH    = 16;
    parameter H_SYNC_PULSE     = 96;
    parameter H_BACK_PORCH     = 48;
    parameter H_TOTAL          = H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;

    assign hsync = ~(h_count >= (H_VISIBLE_AREA + H_FRONT_PORCH) && h_count < (H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE)); // Generate hsync pulse
    assign hblank = (h_count >= H_VISIBLE_AREA); // Generate horizontal blanking signal
    assign en_v_count = (h_count == H_TOTAL - 2); // Generate vertical count enable signal

    always @(posedge clk) begin
        if (reset) begin
            h_count <= 11'd0;
        end else begin
            if (clk_en)
                h_count <= (h_count < H_TOTAL) ? h_count + 1 : 11'd0;
        end
    end

endmodule