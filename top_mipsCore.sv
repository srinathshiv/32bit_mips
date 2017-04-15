module top_mipsCore();

logic clk;
logic rst;
logic [31:0]iCacheReadData;
logic [31:0]dCacheReadData;
logic [31:0]rfReadData_p0;
logic [31:0]rfReadData_p1;

mipsCore mips( 
	
	.iCacheReadData(iCacheReadData),
	.iCacheReadAddr(iCacheReadAddr),

        .dCacheReadData(dCacheReadData),
	.dCacheWriteData(dCacheWriteData),
	.dCacheAddr(dCacheAddr),
	.dCacheWriteEn(dCacheWriteEn),
	.dCacheReadEn(dCacheReadEn),

	.rfReadData_p0(rfReadData_p0),
	.rfReadAddr_p0(rfReadAddr_p0),
	.rfReadEn_p0(rfReadEn_p0),

	.rfReadData_p1(rfReadData_p1),
	.rfReadAddr_p1(rfReadAddr_p1),
	.rfReadEn_p1(rfReadEn_p1),

	.rfWriteData_p0(rfWriteData_p0),
	.rfWriteAddr_p0(rfWriteAddr_p0),
	.rfWriteEn_p0(rfWriteEn_p0),

	.clk(clk),
	.rst(rst)
);

initial begin
clk = 1'b1;
rst = 1'b0;
end

initial begin
iCacheReadData = 32'h01_4B_48_20;

#40
iCacheReadData = 32'h01_4B_48_24;

#40
iCacheReadData = 32'h01_4B_48_25;

#40
iCacheReadData = 32'h01_4B_48_25;

$finish();
end

always begin
#2
clk = ~clk;
end

endmodule;








