module bracks #(
    parameter X0 = 100, // Add 175 for each successive matrix
    parameter Y0 = 50
)(
    input wire [10:0] h_count,
    input wire [10:0] v_count,
	output wire pixon
);

    assign pixon = ((h_count >= X0 - 5 && h_count < ((v_count > Y0 + 2 || v_count < Y0 + 148) ? X0 : X0 - 3)) || (h_count >= X0 + 153 && h_count < ((v_count > Y0 + 2 || v_count < Y0 + 148) ? X0 + 150 : X0 + 155))) && (v_count >= Y0 && v_count < Y0 + 150);

endmodule