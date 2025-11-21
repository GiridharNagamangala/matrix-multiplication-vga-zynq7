`timescale 1ns / 1ps
module vga_digit_rom (
    input       clk,
    input       [3:0]   digit_code, // 0 to 9
    input       [3:0]   row,        // 0 to 15
    input       [2:0]   col,        // 0 to 7
    output wire pixel
);

// Address structure - {digit_code[3:0], row[3:0], col[2:0]} (11 bits)

RAMB16_S1 BRAM_DIGITS (
    .CLK(clk),
    .EN(1'b1),
    .WE(1'b0),
    .ADDR({digit_code, row, ~col}), 
    .SSR(1'b0),
    .DI(1'b0),
    .DO(pixel)
);

// Initialization Parameters (ASCII 0 to 9), 8 cols per digit x 16 rows

defparam BRAM_DIGITS.INIT_00 = 256'h7c66666666666666667c00000000000018181818181818181818000000000000; // INIT_00 contains Digit 0 (0x30) and Digit 1 (0x31)
defparam BRAM_DIGITS.INIT_01 = 256'h7c666030180c0666667c0000000000007c66063c06066666667c000000000000; // INIT_01 contains Digit 2 (0x32) and Digit 3 (0x33)
defparam BRAM_DIGITS.INIT_02 = 256'h183868c8c8fec8c8c8c8000000000000fcc0c0c0f8060606067c000000000000; // INIT_02 contains Digit 4 (0x34) and Digit 5 (0x35)
defparam BRAM_DIGITS.INIT_03 = 256'h7c6660c0c0f86666667c000000000000fefe0204081020408080000000000000; // INIT_03 contains Digit 6 (0x36) and Digit 7 (0x37)
defparam BRAM_DIGITS.INIT_04 = 256'h7c6666667c666666667c0000000000007c6666667c060606067c000000000000; // INIT_04 contains Digit 8 (0x38) and Digit 9 (0x39)
defparam BRAM_DIGITS.INIT_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000; // INIT_05 and onwards are not strictly needed, but it is common practice to initialize the rest to 0
// ... (INIT_06 to INIT_3F would typically be set to all zeros)

endmodule