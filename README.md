# Matrix Multiplication and Display on VGA monitor

Displaying two matrices, and their matrix product on a monitor via a VGA bus; implemented end-to-end on a Xilinx Zedboard (XC7Z020-1CLG484C).
Synthesis and Implementation using Xilinx Vivado 2024 ML Edition.

## Deploying Project on a Zedboard

1. Make sure the part number for the board being used is the same as the one mentioned above. If not, refer to [Digilent's resource on board mapping](https://github.com/Digilent/digilent-xdc/tree/master "digilent-xdc: A collection of Master XDC files for Digilent FPGA and Zynq boards.") for your respective Xilinx board.
2. In Vivado, add all files in the Working Codefiles folder as design sources and the XDC file as a constraint.
3. Under Project manager, click on IP Catalog and search for VIO (Virtual Input-Output) in the window that opens, click on it to instantiate in the top module (`top.v`). Configure the output and input pins following the bus width and number of pins as given in the corresponding module instantiation in `top.v`.

     (Alternatively: The `top.v` file can be bypassed by instantiating `vga_rtl_top.v` and VIO in block diagram, and then creating HDL wrapper.)

## Codefiles and Hierarchy

+ **Board Constraints** `rtl_1.xdc` maps the RGB output buses to their corresponding pins on the on-board VGA socket, the VGA blanking signals (`h_blank` and `v_blank`) to LEDs `T22` and `U22` respectively, system clock to the board 100 MHz clock (pin `Y9`) and sets the I/O Voltage standard to 3.3V CMOS (`LVCMOS33`) among other individual pin properties (Drive, Direction and Slew).
+ **Deprecated** Files that are no longer used for Design Synthesis but were initially written to test and get a hang of the project.
+ **Working Board Config files** Bitfiles for both designs (Fixed point decimal and integer representation was split into two Xilinx Vivado projects for ease of presentation on board; although a single project can perform either by switching the corresponding parameters synthesis takes quite some time).
+ **Working Codefiles** All files that are used for synthesis.
