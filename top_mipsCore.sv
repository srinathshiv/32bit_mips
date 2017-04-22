`include "regFile.sv"
`include "dCache.sv"
`include "iCache.sv"
 
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

// SELF-TEST
logic rInst;
logic [31:0]inst;
logic [5:0]opcode;
logic [5:0]funct;

logic [31:0]src1_val;
logic [31:0]src2_val;
logic [31:0]result;



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

dCache dC( clk, dCacheAddr, dCacheWriteEn, dCacheReadEn, dCacheWriteData, dCacheReadData);

iCache iC( clk, iCacheReadAddr, iCacheReadData );

initial begin
clk = 1'b1;
rst = 1'b0;

end


initial begin 
#30
/*
//SELF-TEST BEGIN

for (int pc=0 ; pc<100; pc=pc+4) begin
	iCacheReadAddr = pc;
	inst  = iCacheReadData;
	rInst = ( inst[31:26] == 6'h00) ? 1'b1: 1'b0;
	opcode = inst[31:26];
	funct =inst[5:0];

	$display("rinst: %b",rInst);
	
	if(!rInst) begin
		src1_val = rfReadData_p0[rfReadAddr_p0]; 
		src2_val = {( inst[15]==1'b1 ) ? 16'hffff:16'h0000 ,inst[15:0]};  

		$display("src1: %d",src1_val);
		$display("src2: %d",src2_val);
		
		case(opcode)
			6'h08: begin
				result = src1_val + src2_val ; 
				$display("ADDI");
				end

			6'h0c: begin
				result = src1_val & src2_val;
				end
		endcase
	#8
		if(rfWriteData_p0 == result) begin
		$display("SUCCESS");
		end
	end
end
//SELF-TEST END

*/
$finish();
end

always begin
#1
clk = ~clk;
end

endmodule;








