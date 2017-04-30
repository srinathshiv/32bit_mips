//`include "structures.sv"

module execute( input clk, 
		input rst, 
		input logic freezeEX,
		input instr_structure alu_op_iCont, 
		input [31:0]op1, 
		input [31:0]op2, 
	
		output reg [31:0]result, 
		output logic zeroFlag,
		output logic [31:0]hold_op2,
		output instr_structure iCont_out,
		
		input logic [31:0]PC_in,
		output logic [31:0]PC_out,

		input logic  done_in  ,
		output logic done_out
		);

logic [31:0] operand1;
logic [31:0] operand2;
logic [4:0] operandShift;

always_comb begin 
	operand1 = op1;
	operand2 = (alu_op_iCont.f_dec.opb == OPB_SIGNIMM) ?  alu_op_iCont.signImm : op2;
	operandShift = alu_op_iCont.shamt;
	

	
end


always @(posedge clk) begin

	if( !freezeEX && done_in == 1'b1) begin
	
		case(alu_op_iCont.f_dec.alu_func)  
			ALU_FUNC_ADD	: begin result  <= operand1 + operand2; end 

			ALU_FUNC_SUB	: begin result  <= operand1 - operand2; end 

			ALU_FUNC_AND	: begin result  <= operand1 & operand2; end 

			ALU_FUNC_OR	: begin result  <= operand1 | operand2; end 

			ALU_FUNC_XOR	: begin result  <= operand1 ^ operand2; end

			ALU_FUNC_NOR	: begin	result  <= ~(operand1|operand2); end 

			ALU_FUNC_SHIFT	: begin result <= operand2 >> operandShift; end

			ALU_FUNC_NOP	: begin $display("NO_OPERATION IN ALU"); end
		
			default 	: begin result <= result    ; $display("UNKNOWN ARITHMETIC INSTRUCTION") ; end
		endcase 
 
		done_out  <= done_in;
		iCont_out <= alu_op_iCont;
		hold_op2  <= op2;
	end // if( !freezeEX && done_in==1'b1)

	
	if(freezeEX) begin
		iCont_out.f_dec = { ALU_FUNC_NOP, MEM_OP_NONE, OPB_SIGNIMM, JMP_NO, BR_NO}; 
	end

	else if(done_in == 1'b0) begin
	done_out <= 1'b0;
	end

end //always@(posedge clk)

always_comb begin

	case(alu_op_iCont.f_dec.br)
		EQ : begin zeroFlag = (result == 32'd0) ? 1'b1 : 1'b0; end
 
		NEQ: begin zeroFlag = (result != 32'd0) ? 1'b1 : 1'b0; end

		GTZ: begin zeroFlag = (result > 32'd0)  ? 1'b1 : 1'b0; end
		
		default: begin zeroFlag = 1'b0; end
	endcase

end //always_comb

assign PC_out = (zeroFlag == 1'b1) ? alu_op_iCont.br_addr : PC_in; 
 
endmodule;


