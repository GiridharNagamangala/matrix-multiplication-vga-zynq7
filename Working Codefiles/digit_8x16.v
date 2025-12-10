module digit_8x16 #(
    parameter XSTART = 100,
    parameter YSTART = 50
)(
	input wire clk,
    input wire [10:0] h_count,
    input wire [10:0] v_count,
	input wire [3:0]  bcd,
	output wire pixon
);

    wire [3:0] row = v_count - YSTART;
    wire [2:0] col = h_count - XSTART;
    wire factive = (h_count >= XSTART) && (h_count < XSTART + 8) && (v_count >= YSTART) && (v_count < YSTART + 16);
    wire fpixout;

    // Instance
    vga_digit_rom U1 (
        .clk(clk),
        .digit_code(bcd),
        .row(row),
        .col(7 - col),
        .pixel(fpixout)
    );

    assign pixon = factive ? fpixout : 1'b0;

endmodule