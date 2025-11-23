module bin2bcd #(
    parameter W = 16 // input width
)(
    input wire [W-1:0] bin, // binary
    output reg [W+(W-4)/3:0] bcd // bcd {...,thousands,hundreds,tens,ones}
);

  integer i,j;
  reg [W+(W-4)/3:0] bcd_reg;

  always @(bin) begin
    for(i = 0; i <= W+(W-4)/3; i = i+1) bcd_reg[i] = 0;           // initialize with zeros
    bcd_reg[W-1:0] = bin;                                         // initialize with input vector
    for(i = 0; i <= W-4; i = i+1)                             // iterate on structure depth
        for(j = 0; j <= i/3; j = j+1)                         // iterate on structure width
            if (bcd_reg[W-i+4*j -: 4] > 4)                        // if > 4
                bcd_reg[W-i+4*j -: 4] = bcd_reg[W-i+4*j -: 4] + 4'd3; // add 3
    bcd = {bcd_reg[3:0], bcd_reg[7:4], bcd_reg[11:8], bcd_reg[15:12], bcd_reg[20:17]};
  end

  // genvar k;
  // generate
  //   for (k = 0; k <= (W + (W-4)/3)/4; k = k + 1) begin : digit_flip
  //       assign bcd[(k*4) +: 4] = bcd[((W + (W-4)/3) - (k*4)) -: 4];
  //   end
  // endgenerate

//   assign bcd = {bcd_reg[3:0], bcd_reg[7:4], bcd_reg[11:8], bcd_reg[15:12], bcd_reg[19:16]};
    // assign bcd = bcd_reg;

endmodule