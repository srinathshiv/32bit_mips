`include "instr_decode.sv"
`include "execute.sv"

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


typedef enum { ALU_FUNC_ADD, ALU_FUNC_SUB, ALU_FUNC_AND, ALU_FUNC_OR, ALU_FUNC_SLT, ALU_FUNC_NOP } ALU_FUNC;
typedef enum { MEM_OP_LW, MEM_OP_SW, MEM_OP_NONE } MEM_OP;
typedef enum { OPB_REG, OPB_IMM, OPB_SIGNIMM } OPB;
typedef enum { JMP_NO, JMP_J, JMP_JR } JMP;
typedef enum { BR_NO, EQ, NEQ, GTZ} BR;

typedef struct packed{
	ALU_FUNC	alu_func;
	MEM_OP		mem_op;
	OPB		opb;
	JMP		jmp;
	BR		br;
} fullDecode;


typedef struct packed{
	reg [4:0]reg1;
	reg [4:0]reg2;
	reg [4:0]reg_dest; 
	reg [4:0]shamt;
	reg [15:0] imm;
	reg [31:0] signimm;
	fullDecode f_dec;
} instr_structure;


instr_structure iContent;

reg [31:0]itec; 	// Instruction To-be Executed Counter
reg [31:0]fetched_val;	//holds the fetched value during instruction fetch stage

reg [6:0]decoded_op;	// value that decided ALU operation
reg [31:0]resultALU;	//result from ALU operation

wire zFlag;


// INSTRUCTION FETCH
always @(posedge clk) begin
	itec	       <= iCacheReadAddr;
	fetched_val    <= iCacheReadData;
	itec	       <= itec + 4;	
end
 

assign rfReadData_p0 = regFile[iContent.reg1];
assign rfReadData_p1 = regFile[iContent.reg2];

instr_decode id (.clk(clk), .rst(rst), .instr(fetched_val), .iCont(iContent) , .opcode_funct(decoded_op));

execute ex(.clk(clk) , .reset(rst) , .alu_op_iCont(iContent), .op1(rfReadData_p0), .op2(rfReadData_p1), .result(resultALU) , .zeroFlag(zFlag));




endmodule;


