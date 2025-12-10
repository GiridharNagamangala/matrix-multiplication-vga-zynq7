module bracks #(
    parameter X0 = 100,          // Top-left X coordinate of the LEFT bracket
    parameter Y0 = 50            // Top-left Y coordinate of both brackets
)(
    input wire [11:0] x,          // Current VGA Pixel X Coordinate
    input wire [11:0] y,          // Current VGA Pixel Y Coordinate
    output wire pixel_on          // 1 = Pixel On (White), 0 = Pixel Off (Black)
);

    // --- Parameters from Prompt ---
    localparam BRACKET_HEIGHT = 106; // Length of the bracket (Y axis)
    localparam SEPARATION     = 158; // Separation between the two brackets
    
    // --- Styling Parameters (Adjustable) ---
    localparam LINE_THICKNESS = 2;   // Thickness of the bracket lines
    localparam BRACKET_WIDTH  = 4;  // Width of the top/bottom horizontal arms

    // ==========================================
    // Logic for Left Bracket [
    // ==========================================
    
    // 1. Define the Outer Boundary of the Left Bracket
    wire l_outer_on;
    assign l_outer_on = (x >= X0) && (x < X0 + BRACKET_WIDTH) &&
                        (y >= Y0) && (y < Y0 + BRACKET_HEIGHT);

    // 2. Define the Inner "Cutout" (to make it hollow)
    // For a '[' the cutout is shifted to the right by THICKNESS
    wire l_inner_cutout;
    assign l_inner_cutout = (x >= X0 + LINE_THICKNESS) && 
                            (y >= Y0 + LINE_THICKNESS) && 
                            (y < Y0 + BRACKET_HEIGHT - LINE_THICKNESS);

    // 3. Result: Outer AND NOT Inner
    wire left_bracket_on;
    assign left_bracket_on = l_outer_on && !l_inner_cutout;

    // ==========================================
    // Logic for Right Bracket ]
    // ==========================================

    // Calculate start X for right bracket
    // Assumption: Separation is the empty gap between the brackets.
    wire [11:0] r_start_x;
    assign r_start_x = X0 + BRACKET_WIDTH + SEPARATION;

    // 1. Define the Outer Boundary of the Right Bracket
    wire r_outer_on;
    assign r_outer_on = (x >= r_start_x) && (x < r_start_x + BRACKET_WIDTH) &&
                        (y >= Y0)   && (y < Y0 + BRACKET_HEIGHT);

    // 2. Define the Inner "Cutout"
    // For a ']' the cutout is shifted to the left (starts at r_start_x)
    // and ends before the thickness on the right edge.
    wire r_inner_cutout;
    assign r_inner_cutout = (x < r_start_x + BRACKET_WIDTH - LINE_THICKNESS) &&
                            (y >= Y0 + LINE_THICKNESS) &&
                            (y < Y0 + BRACKET_HEIGHT - LINE_THICKNESS);

    // 3. Result: Outer AND NOT Inner
    wire right_bracket_on;
    assign right_bracket_on = r_outer_on && !r_inner_cutout;

    // ==========================================
    // Final Output
    // ==========================================
    assign pixel_on = left_bracket_on || right_bracket_on;

endmodule