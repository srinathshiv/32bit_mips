//`include "structures.sv"

module execute( input clk, input reset, input instr_structure alu_op_iCont, input [31:0]op1, input [31:0]op2, output reg [63:0]result, output wire zeroFlag);

logic [31:0] operand1;
logic [31:0] operand2;

assign operand1 = op1;
assign operand2 = (alu_op_iCont.f_dec.opb == OPB_SIGNIMM) ? alu_op_iCont.signImm : op2 ; 


always @(posedge clk) begin

	case(alu_op_iCont.f_dec.alu_func)  
		ALU_FUNC_ADD	: begin result  <= operand1 + operand2; $display("adding")       ; end 	// ADD 
		ALU_FUNC_SUB	: begin result  <= operand1 - operand2; $display("subtracting")  ; end	// SUB
		ALU_FUNC_AND	: begin result  <= operand1 & operand2; $display("ANDing")       ; end	// AND
		ALU_FUNC_OR	: begin result  <= operand1 | operand2; $display("ORing")        ; end 	// OR
		ALU_FUNC_XOR	: begin result  <= operand1 ^ operand2; $display("xoring")       ; end	// XOR
		ALU_FUNC_NOR	: begin	result  <= ~(operand1|operand2); $display("noring")      ; end	// NOR
		
		default : begin result <= result    ; $display("NO-OPERATION") ; end
	endcase
end
 

endmodule;
