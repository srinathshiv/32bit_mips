

typedef enum { ALU_FUNC_ADD, ALU_FUNC_SUB, ALU_FUNC_AND, ALU_FUNC_OR, ALU_FUNC_XOR, ALU_FUNC_NOR, ALU_FUNC_SLT, ALU_FUNC_NOP } ALU_FUNC;
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
	reg  [4:0]reg1;
	reg  [4:0]reg2;
	reg  [4:0]reg_dest; 
	reg  [4:0]shamt;
	reg [15:0]imm;
	reg [31:0]signImm;
	fullDecode f_dec;
} instr_structure;

reg [31:0]regFile[31:0];


