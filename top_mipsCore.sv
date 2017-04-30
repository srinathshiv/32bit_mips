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
integer clk_count=1;
integer initialClk;
integer finalClk;

logic rInst;
logic [31:0]inst;
logic [5:0]opcode;
logic [5:0]funct;

logic [31:0]src1_i1;
logic [31:0]src2_i1;

logic [31:0]result_i1;
logic [31:0]result_i2;
logic [31:0]result_i3;



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
#80;
$finish();
/*SELF-TEST BEGIN

for (int pc=0 ; pc<100; pc=pc+4) begin
#2 // wait for fetched instruction to be decoded
initialClk = clk_count;
finalClk   = clk_count + 2'd3;

	iCacheReadAddr = pc;
	inst  = iCacheReadData;
	rInst = ( inst[31:26] == 6'h00) ? 1'b1: 1'b0;
	opcode = inst[31:26];
	funct =inst[5:0];
	
	
end

$finish();

end

always @(posedge clk) begin

	
	if(!rInst) begin
		src1_i1 <= rfReadData_p0[rfReadAddr_p0]; 
		src2_i1 <= {( inst[15]==1'b1 ) ? 16'hffff:16'h0000 ,inst[15:0]};  

		case(opcode)
			6'h08: begin result_i1 <= src1_i1 + src2_i1 ;$display("test: At clock cycle %d decoded ADDI",clk_count);end
			6'h0c: begin result_i1 <= src1_i1 & src2_i1; end
		endcase
	
		
	end

	else if(rInst) begin

	end
	$display("test: At clock cycle %d result_i1 %d \t result_i2 %d \t result_i3 %d", clk_count, result_i1, result_i2, result_i3);

	result_i2 <= result_i1;

	result_i3 <= result_i2;

	if(clk_count > 3'd4) begin
		if(rfWriteData_p0 == result_i3) begin
		$display("SUCCESS");
		end
	end

//SELF-TEST END*/
end



always begin
#1
clk = ~clk;
end

always begin
#2
clk_count = clk_count + 1;
end

endmodule;








