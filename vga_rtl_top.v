// Working output (to an extent)

module vga_rtl_top #(
    parameter X0 = 100, parameter Y0 = 50,
    parameter MATRIX_N = 3, parameter MATRIX_M = 3, parameter DIGITS = 5, WIDTH = 16
)(
    input  wire clk,         // System clock input
    input  wire reset,       // Active low reset
    input read_ready,
    input [MATRIX_M*MATRIX_N*WIDTH - 1:0] matrix_a,
    input [MATRIX_M*MATRIX_N*WIDTH - 1:0] matrix_b,
    output wire compute_done,
    output wire hsync,       // Horizontal sync output
    output wire vsync,       // Vertical sync output
    output wire hblank,      // Horizontal blanking signal
    output wire vblank,      // Vertical blanking signal
    output wire [3:0] vga_r, // VGA Red out
    output wire [3:0] vga_g, // VGA Green out
    output wire [3:0] vga_b  // VGA Blue out
);

    // Clock divider instance to generate pixel clock from system clock
    wire pixel_clk, bram_clk, v_en;
    wire [10:0] h_count, v_count;
    wire [2:0] brackets;
    wire [(MATRIX_M * MATRIX_N * DIGITS * 3)-1:0] pixel;
    wire mult, equal;

    // Register to store Matrix output numbers
    wire [WIDTH-1:0] matrices [0:MATRIX_N-1][0:(MATRIX_M*3)-1];

    clk_divider #(
        .DIVIDE_BY(4) // Adjust this value based on system clock frequency to get desired pixel clock
    ) clk_div_inst (
        .clk_in(clk),
        .reset(reset),
        .clk_out(pixel_clk),
        .clk_ram(bram_clk)
    );

    // Cannon's algorithm Matrix Multpiplication module
    cannon #(
        .N(3),
        .WIDTH(16)
    ) cannon_inst (
        .clk(clk),
        .reset(reset),
        .start(1'b1),
        .read_ready(read_ready),
        .mat_a_in(matrix_a),
        .mat_b_in(matrix_b),
        .output_valid(compute_done),
        .mata1(matrices[0][0]),
        .mata2(matrices[0][1]),
        .mata3(matrices[0][2]),
        .mata4(matrices[1][0]),
        .mata5(matrices[1][1]),
        .mata6(matrices[1][2]),
        .mata7(matrices[2][0]),
        .mata8(matrices[2][1]),
        .mata9(matrices[2][2]),
        .matb1(matrices[0][3]),
        .matb2(matrices[0][4]),
        .matb3(matrices[0][5]),
        .matb4(matrices[1][3]),
        .matb5(matrices[1][4]),
        .matb6(matrices[1][5]),
        .matb7(matrices[2][3]),
        .matb8(matrices[2][4]),
        .matb9(matrices[2][5]),
        .stage0(matrices[0][6]),
        .stage1(matrices[0][7]),
        .stage2(matrices[0][8]),
        .stage3(matrices[1][6]),
        .stage4(matrices[1][7]),
        .stage5(matrices[1][8]),
        .stage6(matrices[2][6]),
        .stage7(matrices[2][7]),
        .stage8(matrices[2][8]),
        .serial_c_out() // Unused as of now
    );

    // Horizontal counter instance
    horizontal_counter horiz_counter_inst (
        .clk(clk),
        .clk_en(pixel_clk),
        .reset(reset),
        .hsync(hsync),
        .hblank(hblank),
        .en_v_count(v_en),
        .h_count(h_count)
    );

    // Vertical counter instance
    vertical_counter vert_counter_inst (
        .clk(clk),
        .clk_en(pixel_clk),
        .reset(reset),
        .en_v_count(v_en),
        .vsync(vsync),
        .vblank(vblank),
        .v_count(v_count)
    );

    genvar i, j, k, l;
    generate
        for (i = 0; i < MATRIX_N; i = i + 1) begin : row_loop
            for (j = 0; j < 3; j = j + 1) begin : matrix_loop
                for (k = 0; k < MATRIX_M; k = k + 1) begin : col_loop
                    wire [(DIGITS*4)-1:0] bcd_num;
                    bin2bcd #(
                        .W(WIDTH)
                    ) bcd_inst (
                        .bin(matrices[i][j * MATRIX_M + k]),
                        .bcd(bcd_num)
                    );
                    for (l = 0; l < DIGITS; l = l + 1) begin : digit_loop
                        digit_8x16 #(
                            .XSTART(X0 + (l * 8) + (k * 55) + (j * 175)),
                            .YSTART(Y0 + (i * 30))
                        ) digit_inst (
                            .clk(bram_clk),
                            .h_count(h_count),
                            .v_count(v_count),
                            .bcd(bcd_num[(l*4) +: 4]),
                            .pixon(pixel[(i * MATRIX_M * DIGITS * 3) + (j * MATRIX_M * DIGITS) + (k * DIGITS) + l])
                        );
                    end
                end
            end
        end
    endgenerate
    
    // Brackets for Matrix A
    bracks #(
        .X0(X0),
        .Y0(Y0)
    ) bracks_matA (
        .h_count(h_count),
        .v_count(v_count),
        .pixon(brackets[0])
    );

    // Brackets for Matrix B
    bracks #(
        .X0(X0 + 175),
        .Y0(Y0)
    ) bracks_matB (
        .h_count(h_count),
        .v_count(v_count),
        .pixon(brackets[1])
    );

    // Brackets for resultant Matrix
    bracks #(
        .X0(X0 + 350),
        .Y0(Y0)
    ) bracks_matout (
        .h_count(h_count),
        .v_count(v_count),
        .pixon(brackets[2])
    );

    // Multiplication symbol
    digit_8x16 #(
        .XSTART(X0 + 148),
        .YSTART(Y0 + 30)
    ) mult_symbol (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'd10), // Code for multiplication symbol
        .pixon(mult)
    );

    // Equals symbol
    digit_8x16 #(
        .XSTART(X0 + 333),
        .YSTART(Y0 + 30)
    ) equal_symbol (
        .clk(bram_clk),
        .h_count(h_count),
        .v_count(v_count),
        .bcd(4'd11), // Code for equals symbol
        .pixon(equal)
    );

    // VGA Output colour assignment
    assign vga_r = |pixel || |brackets || mult || equal ? 4'hf : 4'h0;
    assign vga_g = |pixel || |brackets || mult || equal ? 4'hf : 4'h0;
    assign vga_b = |pixel || |brackets || mult || equal ? 4'hf : 4'h0;

endmodule
