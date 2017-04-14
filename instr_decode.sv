`include "structures.sv"

module instr_decode(
	input clk, 
	input rst,
	input [31:0]instr, 
	output instr_structure iCont, 
	output [6:0]opcode_funct );

typedef enum {FALSE=0, TRUE=1} BOOLEAN;

reg [5:0] opcode;

reg [5:0]funct;

//wire [6:0] opcode_funct;
BOOLEAN r_inst;

assign r_inst = (opcode == 6'b0) ? TRUE : FALSE ;
assign opcode_funct = { r_inst, (r_inst) ? funct: opcode };

always @(posedge clk) begin
 opcode <= instr[31:26];
 iCont.reg1  <= instr[25:21];
 iCont.reg2  <= instr[20:16];
 iCont.imm <= instr[15:0];
 funct <= instr[5:0];
 
 iCont.reg_dest <= (r_inst) ? instr[15:11] : instr[20:16];
 iCont.signImm <=  { (instr[15]==1'b1) ? 16'hffff:16'h0000 , instr[15:0] };
 iCont.shamt <= (funct==6'b000011) ? iCont.shamt[4:0] : 5'b0 ;

case (opcode_funct)
/*add*/		7'h60:  iCont.f_dec = { ALU_FUNC_ADD, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO} ;
/*sub*/		7'h62:  iCont.f_dec = { ALU_FUNC_SUB, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO} ;
/*and*/		7'h64:  iCont.f_dec = { ALU_FUNC_AND, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO} ;
/*or*/		7'h65:  iCont.f_dec = { ALU_FUNC_OR, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO } ;
/*sra*/		7'h63:  ;
/*xor*/		7'h66:  iCont.f_dec = { ALU_FUNC_XOR, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO } ;
/*nor*/		7'h67:  iCont.f_dec = { ALU_FUNC_NOR, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO } ;
/*addi*/	7'h08:  iCont.f_dec = { ALU_FUNC_ADD, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, BR_NO} ;
/*andi*/	7'h0c:  iCont.f_dec = { ALU_FUNC_AND, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, BR_NO};
/*ori*/		7'h0d:  iCont.f_dec = { ALU_FUNC_OR, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, BR_NO};
/*xori*/	7'h0e:  iCont.f_dec = { ALU_FUNC_XOR, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, BR_NO};
/*slti*/	7'h0a: $display( "slti");
/*j*/		7'h02:  iCont.f_dec = { ALU_FUNC_ADD, MEM_OP_NONE, OPB_REG, JMP_J, BR_NO};
/*beq*/		7'h04: ;
/*bne*/		7'h05: ;
/*bgtz*/	7'h07: ;
/*jr*/		7'h68: ;
/*lw*/		7'h23: iCont.f_dec = { ALU_FUNC_ADD, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, BR_NO};
/*sw*/		7'h27: iCont.f_dec = { ALU_FUNC_ADD, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, BR_NO};
	
/*no-op*/	default: $display ("nop");
endcase

end




endmodule
