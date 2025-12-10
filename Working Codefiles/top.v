`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2025 11:08:12
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk,
    output hsync,
    output vsync,
    output hblank,
    output vblank,
    output [3:0] vga_r,
    output [3:0] vga_g,
    output [3:0] vga_b
    );
    
    
    wire reset,read_ready,compute_done;
    wire [3*3*16-1:0] matrix_a, matrix_b;
    vga_rtl_top#(
    .X0(100),
    .Y0(50),
    .MATRIX_N(3),
    .MATRIX_M(3),
    .DIGITS(5),
    .WIDTH(16)
)temp(
    clk,
    reset,
    read_ready,
    matrix_a,
    matrix_b,
    compute_done,
    hsync,
    vsync,
    hblank,
    vblank,
    vga_r,
    vga_g,
    vga_b
);
    
    vio_0 hi (
  .clk(clk),                // input wire clk
  .probe_in0(compute_done),    // input wire [0 : 0] probe_in0
  .probe_in1(hsync),    // input wire [0 : 0] probe_in1
  .probe_in2(vsync),    // input wire [0 : 0] probe_in2
  .probe_in3(hblank),    // input wire [0 : 0] probe_in3
  .probe_in4(vblank),    // input wire [0 : 0] probe_in4
  .probe_in5(vga_r),    // input wire [3 : 0] probe_in5
  .probe_in6(vga_g),    // input wire [3 : 0] probe_in6
  .probe_in7(vga_b),    // input wire [3 : 0] probe_in7
  .probe_out0(reset),  // output wire [0 : 0] probe_out0
  .probe_out1(read_ready),  // output wire [0 : 0] probe_out1
  .probe_out2(matrix_a),  // output wire [143 : 0] probe_out2
  .probe_out3(matrix_b)  // output wire [143 : 0] probe_out3
);
endmodule
