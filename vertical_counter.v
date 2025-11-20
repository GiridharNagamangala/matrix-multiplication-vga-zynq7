module vertical_counter (
    input  wire clk,
    input  wire reset_n,
    output reg  vsync,
    output reg  vblank,
    output reg [10:0] v_count
);

    // VGA 640x480 @60Hz timing parameters
    parameter V_VISIBLE_AREA   = 480;
    parameter V_FRONT_PORCH    = 10;
    parameter V_SYNC_PULSE     = 2;
    parameter V_BACK_PORCH     = 33;
    parameter V_TOTAL          = V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            v_count <= 11'd0;
            vsync   <= 1'b1; // Active low
            vblank  <= 1'b0;
        end else begin
            if (v_count == V_TOTAL - 1) begin
                    v_count <= 11'd0;
                end else begin
                    v_count <= v_count + 1;
                end

            // Generate vsync pulse
            if (v_count >= (V_VISIBLE_AREA + V_FRONT_PORCH) && v_count < (V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE)) begin
                vsync <= 1'b0; // Active low
            end else begin
                vsync <= 1'b1;
            end

            // Generate vertical blanking signal
            if (v_count >= V_VISIBLE_AREA) begin
                vblank <= 1'b1;
            end else begin
                vblank <= 1'b0;
            end
        end
    end

endmodule