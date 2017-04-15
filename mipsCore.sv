`include "instr_decode.sv"
`include "execute.sv"
`include "memAccess.sv"
`include "writeBack.sv"

module mipsCore( 
	//ICache Ifc
	input  logic [31:0]        iCacheReadData,
	output logic [31:0]        iCacheReadAddr,

	//DCache Ifc
	input  logic [31:0]        dCacheReadData,
	output logic [31:0]        dCacheWriteData,
	output logic [31:0]        dCacheAddr,
	output logic               dCacheWriteEn,
	output logic               dCacheReadEn,

	//Register File Ifc
	input  logic [31:0]       rfReadData_p0,
	output logic [4:0]        rfReadAddr_p0,
	output logic              rfReadEn_p0,

	input  logic [31:0]        rfReadData_p1,
	output logic [4:0]         rfReadAddr_p1,
	output logic               rfReadEn_p1,

	output logic [31:0]        rfWriteData_p0,
	output logic [4:0]         rfWriteAddr_p0,
	output logic               rfWriteEn_p0,

	// Globals
	input  logic                    clk,
	input  logic    		rst
);

instr_structure iContent;

reg [31:0]itec; 	// Instruction To-be Executed Counter
reg [31:0]fetched_val;	//holds the fetched value during instruction fetch stage

reg [6:0]decoded_op;	// value that decides ALU operation
reg [31:0]resultALU;	//result from ALU operation

reg [31:0]Ldata;

wire ctrl_memTOreg;
wire zFlag;


// INSTRUCTION FETCH
always @(posedge clk) begin
	itec	       <= iCacheReadAddr;
	fetched_val    <= iCacheReadData;
	itec	       <= itec + 4;	
end
 

assign rfReadData_p0 = regFile[iContent.reg1];
assign rfReadData_p1 = regFile[iContent.reg2];

//INSTRUCTION DECODE
instr_decode id (.clk(clk), .rst(rst), .instr(fetched_val), .iCont(iContent) , .opcode_funct(decoded_op));

//EXECUTE
execute ex(.clk(clk) , .reset(rst) , .alu_op_iCont(iContent), .op1(rfReadData_p0), .op2(rfReadData_p1), .result(resultALU) , .zeroFlag(zFlag));

//MEMORY
memAccess mem(.clk(clk) , .addr(result) , .mem_iCont(alu_op_iCont) , .loadedData(Ldata));

//WRITE-BACK
writeBack wb(.clk(clk), .lData(loadedData), .result_fromALU(result), .ctrl_mem2reg(ctrl_memTOreg), .wb_iCont(alu_op_iCont));


endmodule;