`include "regFile.sv"
`include "dCache.sv"

module top_mipsCore();

logic clk;
logic rst;
logic [31:0]iCacheReadData;
logic [31:0]iCacheReadAddr;

logic	[31:0]dCacheReadData;
logic	[31:0]dCacheWriteData;
logic	[31:0]dCacheAddr;
logic	dCacheWriteEn;
logic	dCacheReadEn;

logic [31:0]rfReadData_p0;
logic [4:0]rfReadAddr_p0;
logic rfReadEn_p0;

logic [31:0]rfReadData_p1;
logic [4:0]rfReadAddr_p1;
logic rfReadEn_p1;

logic [31:0]   rfWriteData_p0;
logic [4:0]    rfWriteAddr_p0;
logic          rfWriteEn_p0;

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

regFile rf(
	.clk(clk),
	.wr_en(rfWriteEn_p0),
	.rpa_num(rfReadAddr_p0), .rpb_num(rfReadAddr_p1), .wp_num(rfWriteAddr_p0),
	.wp_data(rfWriteData_p0),
	.rpa_out(rfReadData_p0), .rpb_out(rfReadData_p1));

dCache dC( clk, dCacheAddr, dCacheWriteEn, dCacheReadEn, rfReadData_p1, dCacheReadData);


initial begin
clk = 1'b1;
rst = 1'b0;

rfWriteEn_p0 = 1'b1;


end



/*initial begin
rfWriteAddr_p0 = 5'd1;
rfWriteData_p0 = 32'd20;

rfWriteAddr_p0 = 5'd2;
rfWriteData_p0 = 32'd20;

rfWriteAddr_p0 = 5'd3;
rfWriteData_p0 = 32'd20;

rfWriteAddr_p0 = 5'd4;
rfWriteData_p0 = 32'd20;
end*/

initial begin 

iCacheReadData = 32'h20_01_00_02;
#14

/*iCacheReadData = 32'h20_22_00_02;
#12

iCacheReadData = 32'h20_43_00_02;
#20

iCacheReadData = 32'h00_22_20_20;	//ADD $1,$2,$4
#20

iCacheReadData = 32'h00_81_28_20;	//ADD $5,$4,$2
#20

iCacheReadData = 32'hac_41_00_00;	//SW $1, 0($2)
#20

iCacheReadData = 32'h8c_46_00_00;	//LW $6, 0($2)
#40

iCacheReadData = 32'h20_c6_00_00;	//ADDI $6,$6,0
#30
*/
/*iCacheReadData = 32'h21_29_00_05;	// ADDI
#20

iCacheReadData = 32'h21_2A_00_05;
#20

iCacheReadData = 32'h21_2B_00_05;
#20
 
iCacheReadData = 32'h21_2C_00_05;
#20

iCacheReadData = 32'h8d_49_00_04;	//lw t1, 4(t2)
#20

iCacheReadData = 32'had_49_00_04;	//sw t1, 4(t2)
#20

iCacheReadData = 32'h00_0a_48_c3;	//SRA t1 t2 03
#20

iCacheReadData = 32'h01_4B_48_25;	//OR $1,$2,$3
#20

iCacheReadData = 32'h01_4B_48_25;	//OR 
*/
$finish();
end

always begin
#1
clk = ~clk;
end

endmodule;








