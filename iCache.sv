module iCache(input clk,input [31:0]iCacheReadAddr, output logic [31:0]iCacheReadData);

logic [31:0]icache[128:0];

always@(posedge clk) begin
	iCacheReadData <= icache[iCacheReadAddr];
end


	
assign icache[0]  = 32'h20_01_00_02;
assign icache[4]  = 32'h20_02_00_04; 
assign icache[8]  = 32'h20_03_00_06;
assign icache[12]  = 32'h; 
assign icache[16]  = 32'h20_04_00_08; 

//icache[8]  = 
//icache[12] =


endmodule;
