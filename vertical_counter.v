module vertical_counter (
    input  wire clk,
    input  wire reset_n,
    input wire en_v_count,
    output wire  vsync,
    output wire  vblank,
    output reg [10:0] v_count
);

    // VGA 640x480 @60Hz timing parameters
    parameter V_VISIBLE_AREA   = 480;
    parameter V_FRONT_PORCH    = 10;
    parameter V_SYNC_PULSE     = 2;
    parameter V_BACK_PORCH     = 33;
    parameter V_TOTAL          = V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;

    assign vsync = ~(v_count >= (V_VISIBLE_AREA + V_FRONT_PORCH) && v_count < (V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE)); // Generate vsync pulse
    assign vblank = (v_count >= V_VISIBLE_AREA); // Generate vertical blanking signal

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            v_count <= 11'd0;
        end else begin
            if (en_v_count) begin
                if (v_count == V_TOTAL) v_count <= 11'd0;
                else v_count <= v_count + 1;
            end
        end
    end

endmodule