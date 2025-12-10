`timescale 1ns / 1ps

module cannon #(
    parameter N = 3,           // Matrix size N x N
    parameter WIDTH = 16       // Data width of A and B elements
) (
    input clk,
    input reset,
    input start,
    input [N*N*WIDTH - 1:0] mat_a_in,
    input [N*N*WIDTH - 1:0] mat_b_in,
    
    output [WIDTH-1:0] mata1,
    output [WIDTH-1:0] mata2,
    output [WIDTH-1:0] mata3,
    output [WIDTH-1:0] mata4,
    output [WIDTH-1:0] mata5,
    output [WIDTH-1:0] mata6,
    output [WIDTH-1:0] mata7,
    output [WIDTH-1:0] mata8,
    output [WIDTH-1:0] mata9,
    
    output [WIDTH-1:0] matb1,
    output [WIDTH-1:0] matb2,
    output [WIDTH-1:0] matb3,
    output [WIDTH-1:0] matb4,
    output [WIDTH-1:0] matb5,
    output [WIDTH-1:0] matb6,
    output [WIDTH-1:0] matb7,
    output [WIDTH-1:0] matb8,
    output [WIDTH-1:0] matb9,
    
    input read_ready,
    output [WIDTH*2-1+$clog2(N):0] serial_c_out,
    output output_valid,
     output [WIDTH*2-1+$clog2(N):0] stage0,
     output [WIDTH*2-1+$clog2(N):0] stage1,
     output [WIDTH*2-1+$clog2(N):0] stage2,
     output [WIDTH*2-1+$clog2(N):0] stage3,
     output [WIDTH*2-1+$clog2(N):0] stage4,
     output [WIDTH*2-1+$clog2(N):0] stage5,
     output [WIDTH*2-1+$clog2(N):0] stage6,
     output [WIDTH*2-1+$clog2(N):0] stage7,
     output [WIDTH*2-1+$clog2(N):0] stage8
);
    
    assign mata1 =(reset)? 16'b0000000000000000 : mat_a_in[N*N*WIDTH - 1       : ((N*N)-1)*WIDTH];
    assign mata2 =(reset)? 16'b0000000000000000 : mat_a_in[((N*N)-1)*WIDTH - 1 : ((N*N)-2)*WIDTH];
    assign mata3 =(reset)? 16'b0000000000000000 : mat_a_in[((N*N)-2)*WIDTH - 1 : ((N*N)-3)*WIDTH];
    assign mata4 =(reset)? 16'b0000000000000000 : mat_a_in[((N*N)-3)*WIDTH - 1 : ((N*N)-4)*WIDTH];
    assign mata5 =(reset)? 16'b0000000000000000 : mat_a_in[((N*N)-4)*WIDTH - 1 : ((N*N)-5)*WIDTH];
    assign mata6 =(reset)? 16'b0000000000000000 : mat_a_in[((N*N)-5)*WIDTH - 1 : ((N*N)-6)*WIDTH];
    assign mata7 =(reset)? 16'b0000000000000000 : mat_a_in[((N*N)-6)*WIDTH - 1 : ((N*N)-7)*WIDTH];
    assign mata8 =(reset)? 16'b0000000000000000 : mat_a_in[((N*N)-7)*WIDTH - 1 : ((N*N)-8)*WIDTH];
    assign mata9 =(reset)? 16'b0000000000000000 : mat_a_in[((N*N)-8)*WIDTH - 1 : ((N*N)-9)*WIDTH];
    
    assign matb1 =(reset)? 16'b0000000000000000 : mat_b_in[N*N*WIDTH - 1       : ((N*N)-1)*WIDTH];
    assign matb2 =(reset)? 16'b0000000000000000 : mat_b_in[((N*N)-1)*WIDTH - 1 : ((N*N)-2)*WIDTH];
    assign matb3 =(reset)? 16'b0000000000000000 : mat_b_in[((N*N)-2)*WIDTH - 1 : ((N*N)-3)*WIDTH];
    assign matb4 =(reset)? 16'b0000000000000000 : mat_b_in[((N*N)-3)*WIDTH - 1 : ((N*N)-4)*WIDTH];
    assign matb5 =(reset)? 16'b0000000000000000 : mat_b_in[((N*N)-4)*WIDTH - 1 : ((N*N)-5)*WIDTH];
    assign matb6 =(reset)? 16'b0000000000000000 : mat_b_in[((N*N)-5)*WIDTH - 1 : ((N*N)-6)*WIDTH];
    assign matb7 =(reset)? 16'b0000000000000000 : mat_b_in[((N*N)-6)*WIDTH - 1 : ((N*N)-7)*WIDTH];
    assign matb8 =(reset)? 16'b0000000000000000 : mat_b_in[((N*N)-7)*WIDTH - 1 : ((N*N)-8)*WIDTH];
    assign matb9 =(reset)? 16'b0000000000000000 : mat_b_in[((N*N)-8)*WIDTH - 1 : ((N*N)-9)*WIDTH]; 
    
    
    
    
    
    
    
    
    
    
    
    localparam C_WIDTH = WIDTH*2 + $clog2(N);
    localparam NUM_CELLS = N*N;
    localparam STATE_BITS = 2;
    
    localparam IDLE=2'd0, LOAD_INIT=2'd1, COMPUTE=2'd2, OUTPUT=2'd3;
    
    reg [STATE_BITS-1:0] state;
    reg [$clog2(N):0] cycle_count; 
    reg [$clog2(NUM_CELLS):0] out_count; 
    
    wire [WIDTH-1:0] a_chain [0:NUM_CELLS-1]; 
    wire [WIDTH-1:0] b_chain [0:NUM_CELLS-1]; 
    wire [C_WIDTH-1:0] c_result_array [0:NUM_CELLS-1]; 
    
    reg [C_WIDTH-1:0] output_regs [0:NUM_CELLS-1];
    integer idx;
    
    // --- Timing Fix: Gated Enables ---
    // Computation and Shifting should only happen for cycles 0 to N-1.
    // Cycle N is reserved for capturing the final result.
    
    
    shift_register_34bit final(     clk,
     reset,
     output_valid,
     serial_c_out,
     stage0,
    stage1,
    stage2,
     stage3,
   stage4,
      stage5,
     stage6,
     stage7,
    stage8);
    wire active_compute_cycle = (cycle_count < N);

    wire load_init_en = (state == LOAD_INIT);
    wire compute_en = (state == COMPUTE) && active_compute_cycle;
    wire shift_en = load_init_en || compute_en; 
    
    reg last_read_served;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            cycle_count <= 0;
            out_count <= 0;
            last_read_served <= 0;
            for (idx = 0; idx < NUM_CELLS; idx = idx + 1) begin
                output_regs[idx] <= 0;
            end
        end else begin
            last_read_served <= 0;
            
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= LOAD_INIT; 
                        cycle_count <= 0;
                        out_count <= 0;
                        last_read_served <= 0;
                    end
                end
                
                LOAD_INIT: begin
                    state <= COMPUTE;
                    cycle_count <= 0;
                end
                
                COMPUTE: begin
                    // Run for cycles 0 to N-1 to compute.
                    // On cycle N, the final MAC results are stable and ready to capture.
                    if (cycle_count == N) begin
                        // TIMING FIX: Capture results AFTER the Nth computation finishes
                        for (idx = 0; idx < NUM_CELLS; idx = idx + 1) begin
                            output_regs[idx] <= c_result_array[idx];
                        end
                        state <= OUTPUT;
                        out_count <= 0;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                end
                
                OUTPUT: begin
                    if (last_read_served) begin
                        state <= IDLE;
                        out_count <= 0;
                    end else if (read_ready) begin
                        if (out_count == NUM_CELLS - 1) begin
                            last_read_served <= 1;
                        end else begin
                            out_count <= out_count + 1;
                        end
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
    
    assign output_valid = (state == OUTPUT) && !last_read_served;
    assign serial_c_out = output_regs[out_count];


    
    // --- Initial Skewing and MAC Generation (Same as before) ---
    wire [WIDTH-1:0] mat_a_elements [0:NUM_CELLS-1];
    wire [WIDTH-1:0] mat_b_elements [0:NUM_CELLS-1];
    wire [WIDTH-1:0] a_init_skewed [0:NUM_CELLS-1];
    wire [WIDTH-1:0] b_init_skewed [0:NUM_CELLS-1];
    
    genvar g;
    generate
        for (g=0; g<NUM_CELLS; g=g+1) begin : input_decompose
            assign mat_a_elements[g] = mat_a_in[g*WIDTH +: WIDTH];
            assign mat_b_elements[g] = mat_b_in[g*WIDTH +: WIDTH];
        end
    endgenerate

    genvar i_skew, j_skew;
    generate
        for (i_skew=0; i_skew<N; i_skew=i_skew+1) begin : row_skew_gen
            for (j_skew=0; j_skew<N; j_skew=j_skew+1) begin : col_skew_gen
                localparam k = i_skew*N + j_skew; 
                localparam a_src_j = (j_skew + i_skew) % N;
                localparam a_src_k = i_skew * N + a_src_j;
                assign a_init_skewed[k] = mat_a_elements[a_src_k];

                localparam b_src_i = (i_skew + j_skew) % N;
                localparam b_src_k = b_src_i * N + j_skew;
                assign b_init_skewed[k] = mat_b_elements[b_src_k];
            end
        end
    endgenerate

    genvar i, j;
    generate
        for (i=0; i<N; i=i+1) begin : row_gen
            for (j=0; j<N; j=j+1) begin : col_gen
                localparam k = i*N + j; 
                localparam k_prev_a = i*N + (j == 0 ? N-1 : j-1);
                localparam k_prev_b = (i == 0 ? N-1 : i-1)*N + j;

                wire [WIDTH-1:0] a_in_mac = load_init_en ? a_init_skewed[k] : a_chain[k_prev_a];
                wire [WIDTH-1:0] b_in_mac = load_init_en ? b_init_skewed[k] : b_chain[k_prev_b];
                
                mac #(.WIDTH(WIDTH), .SIZE(N)) u_mac (
                    .clk(clk),
                    .reset(reset),
                    .shift_en(shift_en),
                    .compute_en(compute_en),
                    .a_in(a_in_mac),
                    .b_in(b_in_mac),
                    .a_out(a_chain[k]),      
                    .b_out(b_chain[k]),      
                    .c_result(c_result_array[k]) 
                );
            end
        end
    endgenerate
endmodule



module mac #(
    parameter WIDTH=16,       // Data width of A and B elements
    parameter SIZE=3          // Matrix size N (used for calculating C_result width: 2*WIDTH + log2(N))
) (
    input clk,
    input reset,
    input shift_en,     // Enables shifting of A and B registers (active during LOAD_INIT and COMPUTE)
    input compute_en,   // Enables the Multiply-Accumulate operation (active only during COMPUTE)
    
    // Inputs
    input [WIDTH-1:0] a_in,
    input [WIDTH-1:0] b_in,
    
    // Outputs
    output [WIDTH-1:0] a_out,
    output [WIDTH-1:0] b_out,
    output [WIDTH*2-1+$clog2(SIZE):0] c_result // Final accumulated result C_i,j
);
    
    // C width = 2*WIDTH + ceil(log2(SIZE)) for summation over SIZE elements
    localparam C_WIDTH = WIDTH*2 + $clog2(SIZE);
    
    // Registers to store matrix elements A, B, and the accumulating result C
    reg [WIDTH-1:0] a_reg;
    reg [WIDTH-1:0] b_reg;
    reg [C_WIDTH-1:0] c_reg;
    
    // Outputs are the registered values
    assign a_out = a_reg;
    assign b_out = b_reg;
    assign c_result = c_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            a_reg <= 0;
            b_reg <= 0;
            c_reg <= 0;
        end else begin
            
            // 1. Shifting A/B and C Initialization
            if (shift_en) begin
                a_reg <= a_in; 
                b_reg <= b_in; 
                
                // C Accumulator Initialization: Only during the one-cycle LOAD_INIT (shift_en=1, compute_en=0)
                if (!compute_en) begin
                    c_reg <= 0; // Initialize C accumulator to zero for a new computation
                end
            end
            
            // 2. Compute (Multiply-Accumulate)
            // Uses the a_reg and b_reg values from the *previous* cycle (systolic pipeline)
            if (compute_en) begin
                // C(i,j) = C(i,j) + A(i,k) * B(k,j)
                c_reg <= c_reg + a_reg * b_reg; 
            end
        end
    end
endmodule



module shift_register_34bit (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [33:0] data_in,
    output wire [33:0] stage0,
    output wire [33:0] stage1,
    output wire [33:0] stage2,
    output wire [33:0] stage3,
    output wire [33:0] stage4,
    output wire [33:0] stage5,
    output wire [33:0] stage6,
    output wire [33:0] stage7,
    output wire [33:0] stage8
);

    // Internal registers for 9 stages
    reg [33:0] shift_reg [0:8];
    
    // Assign outputs
    assign stage0 = shift_reg[0];
    assign stage1 = shift_reg[1];
    assign stage2 = shift_reg[2];
    assign stage3 = shift_reg[3];
    assign stage4 = shift_reg[4];
    assign stage5 = shift_reg[5];
    assign stage6 = shift_reg[6];
    assign stage7 = shift_reg[7];
    assign stage8 = shift_reg[8];
    
    integer i;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all stages to 0
            for (i = 0; i < 9; i = i + 1) begin
                shift_reg[i] <= 34'h000000000;
            end
        end
        else if (enable) begin
            // Shift data through the pipeline
            shift_reg[0] <= data_in;
            for (i = 1; i < 9; i = i + 1) begin
                shift_reg[i] <= shift_reg[i-1];
            end
        end
        // If enable is 0, hold current values (do nothing)
    end

endmodule