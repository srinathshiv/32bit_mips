module iCache(input clk,input [31:0]iCacheReadAddr, output logic [31:0]iCacheReadData);

logic [31:0]icache[128:0];

always@(posedge clk) begin
	iCacheReadData <= icache[iCacheReadAddr];
end



/* ADDI instructions */
assign icache[0]   = 32'h20_01_00_02;
assign icache[4]   = 32'h20_02_00_04;
assign icache[8]   = 32'h20_03_00_06;
assign icache[12]   = 32'h20_04_00_08; 
assign icache[16]   = 32'h20_05_00_09;
assign icache[20]   = 32'h20_06_00_0a;
assign icache[24]   = 32'h20_07_00_0b;
assign icache[28]   = 32'h20_08_00_0c;
assign icache[32]   = 32'h20_09_00_0d;
assign icache[36]   = 32'h20_0a_00_0e;
assign icache[40]   = 32'h20_0b_00_0f;


/* ADD assign icache[44]  = 32'h00_43_08_20;*/
//SW assign icache[44]   = 32'hac_82_00_00;
//JMP assign icache[44]   = 32'h08_00_00_01;
assign icache[44]   = 32'h14_83_00_04;
assign icache[48]   = 32'h20_0c_00_10;
assign icache[52]   = 32'h20_0d_00_11;
assign icache[56]   = 32'h20_0e_00_12;
assign icache[60]   = 32'h20_0f_00_12;

//LW assign icache[68]   = 32'h8c_82_00_00;



/*
assign icache[16]  = 32'h20_00_00_00; 
assign icache[20]  = 32'h20_00_00_00; 
assign icache[24]  = 32'h20_00_00_00; 
assign icache[28]  = 32'h20_00_00_00; 
assign icache[32]  = 32'h20_00_00_00; 
assign icache[36]  = 32'hac_82_00_00; 
assign icache[40]  = 32'h20_00_00_00;
assign icache[36]  = 32'h20_04_00_08; 
*/

//icache[8]  = 
//icache[12] =


endmodule;
