//`include "structures.sv"

module execute( input clk, input reset, input instr_structure alu_op_iCont, input [31:0]op1, input [31:0]op2, output reg [63:0]result, output wire zeroFlag);

logic [31:0] operand1;
logic [31:0] operand2;
logic [4:0] operandShift;
 
assign operand1 = op1;
assign operand2 = (alu_op_iCont.f_dec.opb == OPB_SIGNIMM) ? alu_op_iCont.signImm : op2 ; 
assign operandShift = alu_op_iCont.shamt;

always @(posedge clk) begin
$display("--->Enter Execute");

	case(alu_op_iCont.f_dec.alu_func)  
		ALU_FUNC_ADD	: begin 
					result  <= operand1 + operand2; 
					$display("ADD-ing %d and %d",operand1,operand2); 
				  end // ADD 

		ALU_FUNC_SUB	: begin 
					result  <= operand1 - operand2; 
					$display("SUBTRACT-ing %d and %d",operand1,operand2); 
				  end	// SUB

		ALU_FUNC_AND	: begin 
					result  <= operand1 & operand2;
					$display("AND-ing %d and %d ",operand1,operand2); 
				  end	// AND

		ALU_FUNC_OR	: begin 
					result  <= operand1 | operand2;
					$display("OR-ing %d and %d", operand1, operand2); 
				  end 	// OR

		ALU_FUNC_XOR	: begin 
					result  <= operand1 ^ operand2;
					$display("XOR-ing %d and %d", operand1, operand2); 
				  end	// XOR

		ALU_FUNC_NOR	: begin	
					result  <= ~(operand1|operand2); 
					$display("NOR-ing %d and %s", operand1, operand2)      ; 
				end	// NOR

		ALU_FUNC_SHIFT	: begin
					result <= operand2 >> operandShift;
					$display("SRA: shifting %d by %d",operand1,operandShift);
				end
		
		default : begin result <= result    ; $display("NO-OPERATION") ; end
	endcase
$display("<===Exit Execute\n");
end
 
 
endmodule;
