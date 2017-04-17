//`include "structures.sv"

module instr_decode(
	input clk, 
	input rst,
	input [31:0]instr, 
	output instr_structure iCont, 
	output [6:0]opcode_funct ,
	output logic [31:0]op1_toALU,
	output logic [31:0]op2_toALU,
	input [31:0]PC_next
);

typedef enum {FALSE=0, TRUE=1} BOOLEAN;

reg [5:0] opcode;

reg [5:0]funct;

//wire [6:0] opcode_funct;
BOOLEAN r_inst;

assign r_inst = (opcode == 6'b0) ? TRUE : FALSE ;
assign opcode_funct = { r_inst, (r_inst) ? funct: opcode };

/*JUMP*/   assign PC_next = (iCont.f_dec.jmp == JMP_J ) ? {PC_next[31:28], iCont.jAddr} : PC_next ;
/*JUMP-R*/ assign PC_next = (iCont.f_dec.jmp == JMP_JR) ? op1_toALU : PC_next ;

always_comb begin 
$display("\n********************\n--->Enter instruction decode");

 opcode = instr[31:26];
 iCont.reg1  = instr[25:21];
 iCont.reg2  = instr[20:16];
 iCont.imm = instr[15:0];
 funct = instr[5:0];
 iCont.jAddr = instr[25:0] << 2;

 
 iCont.reg_dest = (r_inst) ? instr[15:11] : instr[20:16];
 iCont.signImm =  { (instr[15]==1'b1) ? 16'hffff:16'h0000 , instr[15:0] };
 iCont.shamt = (funct==6'b000011) ? instr[4:0] : 5'b0 ;

 iCont.br_addr = PC_next + (iCont.signImm << 2) ;



 

case (opcode_funct)
/*add*/		7'h60:  begin 
			iCont.f_dec = { ALU_FUNC_ADD, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO} ;
			$display("decoded instr: add");
			$display("rs: %d",iCont.reg1);
			$display("rt: %d",iCont.reg2);
			$display("dest :%d",iCont.reg_dest);
			end

/*sub*/		7'h62:  begin 
			iCont.f_dec = { ALU_FUNC_SUB, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO} ;
			$display("decoded instr: sub");
			$display(iCont.reg1);
			$display(iCont.reg2);
			$display(iCont.reg_dest);
			end

/*sra*/		7'h43:  begin
			iCont.f_dec = { ALU_FUNC_SHIFT, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO } ;
			$display("decoded instr: SRA");
			$display("rs: %d",iCont.reg1);
			$display("rt: %d",iCont.reg2);
			$display("dest: %d",iCont.reg_dest);
			$display("shift amount: %d",iCont.shamt);
			end

/*and*/		7'h64:  begin
			iCont.f_dec = { ALU_FUNC_AND, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO} ;
			$display("decoded instr: AND");
			$display(iCont.reg1);
			$display(iCont.reg2);
			$display(iCont.reg_dest);
			end

/*or*/		7'h65:  begin
			iCont.f_dec = { ALU_FUNC_OR, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO } ;
			$display("decoded instr: OR");
			$display(iCont.reg1);
			$display(iCont.reg2);
			$display(iCont.reg_dest);
			end

/*xor*/		7'h66:  begin
			iCont.f_dec = { ALU_FUNC_XOR, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO } ;
			$display("decoded instr: XOR");
			$display(iCont.reg1);
			$display(iCont.reg2);
			$display(iCont.reg_dest);
			end
 
/*nor*/		7'h67:  begin
			iCont.f_dec = { ALU_FUNC_NOR, MEM_OP_NONE, OPB_REG, JMP_NO, BR_NO } ;
			$display("decoded instr: NOR");
			$display(iCont.reg1);
			$display(iCont.reg2);
			$display(iCont.reg_dest);
			end

/*addi*/	7'h08:  begin
			iCont.f_dec = { ALU_FUNC_ADD, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, BR_NO} ;
			$display("decoded instr: ADD-IMM");
			$display("reg 1 = %d",iCont.reg1);
			$display("reg dest = %d",iCont.reg_dest);
			$display("value  = %d",iCont.signImm);
			end

/*andi*/	7'h0c:  begin 
			iCont.f_dec = { ALU_FUNC_AND, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, BR_NO};
			$display("decoded instr: ANDI-IMM");
			$display(iCont.reg1);
			$display(iCont.reg_dest);
			$display(iCont.signImm);
			end

/*ori*/		7'h0d:  begin
			iCont.f_dec = { ALU_FUNC_OR, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, BR_NO};
			$display("decoded instr: OR-IMM");
			$display(iCont.reg1);
			$display(iCont.reg2);
			$display(iCont.reg_dest);
			$display(iCont.signImm);
			end

/*xori*/	7'h0e:  begin
			iCont.f_dec = { ALU_FUNC_XOR, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, BR_NO};
			$display("decoded instr: XOR-IMM");
			$display(iCont.reg1);
			$display(iCont.reg2);
			$display(iCont.reg_dest);
			$display(iCont.signImm);
			end

/*slti*/	7'h0a: $display( "slti");
/*j*/		7'h02:  begin
			iCont.f_dec = { ALU_FUNC_NOP, MEM_OP_NONE, OPB_REG, JMP_J, BR_NO};
			$display("decoded instr: JUMP (J). Oh fuck!. ");
			//$display(iCont.reg1);
			//$display(iCont.reg2);
			//$display(iCont.reg_dest);
			//$display(iCont.signImm);
			end

/*beq*/		7'h04: begin
			iCont.f_dec = { ALU_FUNC_SUB, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, EQ}; 
			$display("decoded instr: Branch Equal ");
			$display("Possible branch address (in hex): %h",iCont.br_addr);
			//$display(iCont.reg2);
			//$display(iCont.reg_dest);
			//$display(iCont.signImm);
			end

/*bne*/		7'h05: begin
			iCont.f_dec = { ALU_FUNC_SUB, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, NEQ}; 
			$display("decoded instr: Branch Not equal ");
			$display("Possible branch address (in hex): %h",iCont.br_addr);
			//$display(iCont.reg2);
			//$display(iCont.reg_dest);
			//$display(iCont.signImm);
			end

/*bgtz*/	7'h07: begin
			iCont.f_dec = { ALU_FUNC_SUB, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, GTZ}; 
			$display("decoded instr: Branch on Greater than zero ");
			$display("Possible branch address (in hex): %h",iCont.br_addr);
			//$display(iCont.reg2);
			//$display(iCont.reg_dest);
			//$display(iCont.signImm);
			end

/*jr*/		7'h68: begin
			iCont.f_dec = { ALU_FUNC_NOP, MEM_OP_NONE, OPB_REG, JMP_JR, BR_NO};
			$display("decoded instr: JUMP REG (JR). Oh fuck!. ");
			//$display(iCont.reg1);
			//$display(iCont.reg2);
			//$display(iCont.reg_dest);
			//$display(iCont.signImm);
			end

/*lw*/		7'h23: 	begin
			iCont.f_dec = { ALU_FUNC_ADD, MEM_OP_LW, OPB_SIGNIMM, JMP_NO, BR_NO};
			$display(iCont.f_dec.mem_op);
			$display("decoded instr: LOAD-WORD");
			$display(iCont.reg1);
			$display(iCont.reg2);
			$display(iCont.reg_dest);
			$display(iCont.signImm);
			end

/*sw*/		7'h2b: 	begin
			iCont.f_dec = { ALU_FUNC_ADD, MEM_OP_SW, OPB_SIGNIMM, JMP_NO, BR_NO};
			$display("decoded instr: STORE-WORD");
			$display(iCont.reg1);
			$display(iCont.reg2);
			$display(iCont.reg_dest);
			$display(iCont.signImm);
			end
	
/*no-op*/	default: $display ("nop");

endcase

$display("<===Exit instruction decode\n");

end

always @(posedge clk) begin
 	op1_toALU <= iCont.reg1; 
	op2_toALU <= iCont.reg2; 
end


endmodule
