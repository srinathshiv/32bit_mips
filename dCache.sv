
module dCache(
	input clk, 
	input logic [4:0]dCacheAddr, 
	input logic dCacheWriteEn, 
	input logic dCacheReadEn,
	input logic [31:0]rfReadData_p1,
	output logic [31:0]loadedData);

reg [31:0]dcache[31:0];

assign loadedData = (dCacheReadEn == 1'b1) ? dcache[dCacheAddr] : 1'b0 ;
   
always @(posedge clk) begin
     if (dCacheWriteEn) begin
     dcache[dCacheAddr] <= rfReadData_p1;
     end
end

endmodule;
