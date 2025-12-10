module bin2bcd #( 
    parameter W = 16 // input width 
)( 
    input wire [W-1:0] bin, // binary 
    output reg [W+(W-4)/3:0] bcd // bcd {...,thousands,hundreds,tens,ones} 
); 

  integer i,j; 
  reg [W+(W-4)/3:0] bcd_temp; // temporary storage

  always @(bin) begin 
    for(i = 0; i <= W+(W-4)/3; i = i+1) bcd_temp[i] = 0;      
    bcd_temp[W-1:0] = bin;                                    
    for(i = 0; i <= W-4; i = i+1)                             
        for(j = 0; j <= i/3; j = j+1)                         
            if (bcd_temp[W-i+4*j -: 4] > 4)                   
                bcd_temp[W-i+4*j -: 4] = bcd_temp[W-i+4*j -: 4] + 4'd3;
    
    // Reverse the order: concatenate from LSB to MSB
    bcd = {1'b0,bcd_temp[3:0], bcd_temp[7:4], bcd_temp[11:8], bcd_temp[15:12], bcd_temp[19:16]};
  end 

endmodule
