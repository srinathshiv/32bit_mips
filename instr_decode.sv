//`include "structures.sv"

module instr_decode(
	input clk, 
	input rst,
	/*input logic freezeID,*/
	input [31:0]instr, 
	input logic [31:0]op1_in,
	input logic [31:0]op2_in,

	output instr_structure iCont_toALU, 
	output logic [4:0]rfReadAddr_p0,
	output logic [4:0]rfReadAddr_p1,
	output logic [6:0]opcode_funct ,
	output logic [31:0]op1,
	output logic [31:0]op2,
	output logic jFlag,

	input logic [31:0]PC_in,
	output logic [31:0]PC_out,

	input logic  done_in  ,
	output logic done_out
);

typedef enum {FALSE=0, TRUE=1} BOOLEAN;

instr_structure iCont;

logic [5:0] opcode;
logic [5:0]funct;

BOOLEAN r_inst;

always_comb begin 
	opcode = instr[31:26];
	funct = instr[5:0];

	r_inst = (opcode == 6'b0) ? TRUE : FALSE ;
	opcode_funct = { r_inst, (r_inst) ? funct: opcode }; 

	iCont.reg1  = instr[25:21];
	iCont.reg2  = instr[20:16];
	   rfReadAddr_p0  = iCont.reg1;		//iCacheReadData[25:21]; /* iContent.reg1;*/
	   rfReadAddr_p1  = iCont.reg2;		//iCacheReadData[20:16]; /* iContent.reg2;*/
	iCont.reg_dest = (r_inst) ? instr[15:11] : instr[20:16];

	iCont.imm = instr[15:0]; 
	iCont.signImm =  { (instr[15]==1'b1) ? 16'hffff:16'h0000 , instr[15:0] };
 
	iCont.shamt = (funct==6'b000011) ? instr[4:0] : 5'b0 ;

	iCont.jAddr = instr[25:0] << 2; 
	iCont.br_addr = PC_in + (iCont.signImm <<< 2) ;

 

		case (opcode_funct)
/*add*/		7'h60:  begin 
			iCont.f_dec = { ALU_FUNC_ADD, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO} ;
			end

/*sub*/		7'h62:  begin 
			iCont.f_dec = { ALU_FUNC_SUB, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO} ;
			end

/*sra*/		7'h43:  begin
			iCont.f_dec = { ALU_FUNC_SHIFT, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO } ;
			end

/*and*/		7'h64:  begin
			iCont.f_dec = { ALU_FUNC_AND, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO} ;
			end

/*or*/		7'h65:  begin
			iCont.f_dec = { ALU_FUNC_OR, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO } ;
			end

/*xor*/		7'h66:  begin
			iCont.f_dec = { ALU_FUNC_XOR, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO } ;
			end
 
/*nor*/		7'h67:  begin
			iCont.f_dec = { ALU_FUNC_NOR, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO } ;
			end

/*addi*/	7'h08:  begin
			iCont.f_dec = { ALU_FUNC_ADD, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, BR_NO} ;
			end

/*andi*/	7'h0c:  begin 
			iCont.f_dec = { ALU_FUNC_AND, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, BR_NO};
			end

/*ori*/		7'h0d:  begin
			iCont.f_dec = { ALU_FUNC_OR, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, BR_NO};
			end

/*xori*/	7'h0e:  begin
			iCont.f_dec = { ALU_FUNC_XOR, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, BR_NO};
			end

/*slti*/	7'h0a: begin
			$display( "slti");
			end

/*j*/		7'h02:  begin
			iCont.f_dec = { ALU_FUNC_NOP, MEM_OP_NONE, OPB_REG, JMP_J, BR_NO};
			end

/*beq*/		7'h04: begin
			iCont.f_dec = { ALU_FUNC_SUB, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, EQ}; 
			end

/*bne*/		7'h05: begin
			iCont.f_dec = { ALU_FUNC_SUB, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, NEQ}; 
			end

/*bgtz*/	7'h07: begin
			iCont.f_dec = { ALU_FUNC_SUB, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, GTZ}; 
			end

/*jr*/		7'h68: begin
			iCont.f_dec = { ALU_FUNC_NOP, MEM_OP_NONE, OPB_REG, JMP_JR, BR_NO};
			end

/*lw*/		7'h23: 	begin
			iCont.f_dec = { ALU_FUNC_ADD, MEM_OP_LW, OPB_SIGNIMM, JMP_NO, BR_NO};
			end

/*sw*/		7'h2b: 	begin
			iCont.f_dec = { ALU_FUNC_ADD, MEM_OP_SW, OPB_SIGNIMM, JMP_NO, BR_NO};
			end
	
/*no-op*/	default: begin
			iCont.f_dec = { ALU_FUNC_NOP, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO};
			end

		endcase
 

end // always_comb
 
always_comb begin
	case(iCont.f_dec.jmp) 
		JMP_J: begin PC_out =  {PC_in[31:28], iCont.jAddr} ; end

		JMP_JR: begin PC_out = op1_in; end

		default: begin PC_out = PC_in; end
	endcase
end // always_comb

always @(posedge clk) begin
	if( /*!freezeID &&*/ done_in == 1'b1) begin
 		op1 <= op1_in; 
		//op2 <= (iCont.f_dec.opb == OPB_SIGNIMM)  ? iCont.signImm : op2_in ;
		op2 <= op2_in;
		iCont_toALU <= iCont;
	end
		done_out <= done_in; 
end //always @(posedge clk)

assign jFlag = (iCont.f_dec.jmp != JMP_NO) ? 1'b1: 1'b0;

endmodule
