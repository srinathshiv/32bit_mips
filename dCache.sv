
module dCache(
	input clk, 
	input logic [31:0]dCacheAddr, 
	input logic dCacheWriteEn, 
	input logic dCacheReadEn,
	input logic [31:0]dCacheWriteData,
	output logic [31:0]dCacheReadData);

reg [31:0]dcache[256:0];

assign dCacheReadData = (dCacheReadEn == 1'b1) ? dcache[dCacheAddr] : 1'b0 ;
   
always @(posedge clk) begin
     if (dCacheWriteEn) begin
     dcache[dCacheAddr] <= dCacheWriteData;
     end
end

endmodule;
