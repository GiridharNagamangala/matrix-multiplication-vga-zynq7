module horizontal_counter (
    input  wire clk,
    input  wire reset_n,
    output reg  hsync,
    output reg  hblank,
    output reg en_v_count,
    output reg [10:0] h_count
);

    // VGA 640x480 @60Hz timing parameters
    parameter H_VISIBLE_AREA   = 640;
    parameter H_FRONT_PORCH    = 16;
    parameter H_SYNC_PULSE     = 96;
    parameter H_BACK_PORCH     = 48;
    parameter H_TOTAL          = H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            h_count <= 11'd0;
            hsync   <= 1'b1; // Active low
            hblank  <= 1'b0;
            en_v_count <= 1'b0;
        end else begin
            if (h_count == H_TOTAL - 1) begin
                h_count <= 11'd0;
            end else begin
                h_count <= h_count + 1;
            end

            // Generate hsync pulse
            if (h_count >= (H_VISIBLE_AREA + H_FRONT_PORCH) && h_count < (H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE)) begin
                hsync <= 1'b0; // Active low
            end else begin
                hsync <= 1'b1;
            end

            // Generate horizontal blanking signal
            if (h_count >= H_VISIBLE_AREA) begin
                hblank <= 1'b1;
            end else begin
                hblank <= 1'b0;
            end

            // Generate vertical count enable signal
            if (h_count == H_TOTAL - 2) begin
                en_v_count <= 1'b1;
            end else begin
                en_v_count <= 1'b0;
            end
        end
    end

endmodule