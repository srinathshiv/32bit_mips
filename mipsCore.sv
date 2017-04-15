`include "structures.sv"

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

logic [31:0]PC; 	// Instruction To-be Executed Counter
logic [31:0]fetched_val;	//holds the fetched value during instruction fetch stage

reg [6:0]decoded_op;	// value that decides ALU operation
reg [31:0]resultALU;	//result from ALU operation
reg [31:0]Ldata;	//data from lw instruction

//RS AND RT
logic [31:0]i_rs;
logic [31:0]i_rt;

//CTRLS
wire ctrl_memTOreg;
wire ctrl_regWrite;
wire ctrl_memRead; 
wire ctrl_memWrite;


//ZERO-FLAG
wire zFlag;

//----- RF READ PORTS ------//
assign   i_rs= rfReadData_p0;
assign   i_rt= rfReadData_p1;

assign rfReadAddr_p0 = iContent.reg1;
assign rfReadAddr_p1 = iContent.reg2;
  

//----- RF WRITE PORTS -----//
assign rfWriteEn_p0 =  ctrl_regWrite;

//----- D CACHE -----//
assign dCacheReadEn  = ctrl_memRead;
assign dCacheWriteEn = ctrl_memWrite;


 
// STAGE 1:INSTRUCTION FETCH
assign iCacheReadAddr = PC;
assign fetched_val    = iCacheReadData;	

 
//STAGE 2:INSTRUCTION DECODE
instr_decode id (.clk(clk), .rst(rst), .instr(fetched_val), .iCont(iContent) , .opcode_funct(decoded_op));

//STAGE 3:EXECUTE
execute ex(.clk(clk) , .reset(rst) , .alu_op_iCont(iContent), .op1(i_rs), .op2(i_rt), .result(resultALU) , .zeroFlag(zFlag));
  
//STAGE 4:MEMORY
memAccess mem(.clk(clk) , .addr(result) , 
		.rfReadAddr_p1(rfReadAddr_p1), .rfReadData_p1(rfReadData_p1),
		.dCacheAddr(dCacheAddr), 
		.dCacheWriteData(dCacheWriteData), 
		.dCacheReadData(dCacheReadData), 
		.mem_iCont(iContent) , .loadedData(Ldata));

//STAGE 5:WRITE-BACK
writeBack wb(.clk(clk), .lData(loadedData), .result_fromALU(result), .ctrl_mem2reg(ctrl_memTOreg), .wb_iCont(iContent), 
.rfWriteData_p0(rfWriteData_p0), .rfWriteAddr_p0(rfWriteAddr_p0)); 

 

endmodule;