//`include "structures.sv"

module execute( input clk, 
		input rst, 
		input instr_structure alu_op_iCont, 
		input [31:0]op1, 
		input [31:0]op2, 

		
		output reg [63:0]result, 
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
$display(alu_op_iCont.f_dec.alu_func);
$display(op2);
$display(alu_op_iCont.signImm);
//operand2 = op2;

operandShift = alu_op_iCont.shamt;
end


always @(posedge clk) begin

if(done_in == 1'b1) begin
	$display("--->Enter Execute");
	case(alu_op_iCont.f_dec.alu_func)  
		ALU_FUNC_ADD	: begin 
					result  <= operand1 + operand2; 
					$display("ADD-ing %d and %d ; RESULT = %d ",operand1,operand2,result); 
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

	case(alu_op_iCont.f_dec.br)
		EQ: begin 
		$display("branch equal");
		zeroFlag = (result == 64'd0) ? 1'b1 : 1'b0;
		
 		end

		NEQ: begin 
		$display("branch not-eq");
		zeroFlag = (result != 64'd0) ? 1'b1 : 1'b0;
			
		end

		GTZ: begin 
		$display("branch greater than zero");
		zeroFlag = (result > 64'd0) ? 1'b1 : 1'b0;
		end
		
		default: begin
		zeroFlag = 1'b0;
			$display("no branch operations. PC remains unaffected");
		end
	endcase

	PC_out <= (zeroFlag == 1'b1) ? alu_op_iCont.br_addr : PC_in; 
	

	done_out <= done_in;
	iCont_out <= alu_op_iCont;
	hold_op2 <= op2;
	$display("<===Exit Execute\n");
end // for if(done_in==1'b1)

else if(done_in == 1'b0) begin
	done_out <= 1'b0;
end

end //always


//assign PC_next = (zeroFlag == 1'b1) ? alu_op_iCont.br_addr : PC_next; 
 
endmodule;


