module clk_divider (
    input  wire clk_in,
    input  wire reset,
    output reg  clk_out,
    output reg clk_ram
);

    parameter integer DIVIDE_BY = 4; // Must be >= 2

    // Counter to track clock cycles
    reg [$clog2(DIVIDE_BY)-1:0] counter;

    always @(posedge clk_in) begin
        if (reset) begin
            counter <= 32'd0;
            clk_out <= 1'b0;
            clk_ram <= 1'b0;
        end else begin
            if (counter == (DIVIDE_BY - 1)) begin
                clk_out <= 1'b1; // Toggle enable clock pulse
                counter <= 32'd0;    // Reset counter
            end else begin
                counter <= counter + 1; // Increment counter
                clk_out <= 1'b0;
            end
            if (counter == (DIVIDE_BY / 2 - 1))
                clk_ram <= ~clk_ram; // Output out-of tree clock specific to digit lookup map
        end
    end

endmodule