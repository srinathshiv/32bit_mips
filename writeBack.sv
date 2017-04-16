//`include"structures.sv"

module writeBack( input clk, input [31:0]lData, input [31:0]result_fromALU, input ctrl_mem2reg, input instr_structure wb_iCont, output reg [31:0]rfWriteData_p0,output logic [4:0]rfWriteAddr_p0);
 
assign rfWriteAddr_p0 = wb_iCont.reg_dest;
assign ctrl_mem2reg = (wb_iCont.f_dec.mem_op == MEM_OP_NONE) ? 1'b0: 1'b1;
always@(posedge clk) begin
$display("--->Enter WRITEBACK");
	case (ctrl_mem2reg) 
	1'b0: begin 
		rfWriteData_p0 <= result_fromALU;
		$display("writing data %d from ALU to reg %d ; data to be written = %d",result_fromALU,rfWriteAddr_p0, rfWriteData_p0);
	      end
	
	1'b1: begin
		if(wb_iCont.f_dec.mem_op == MEM_OP_LW) begin
			rfWriteData_p0 <= lData;
			$display("writing data %d from memory for lw",rfWriteData_p0); 
		end
		else begin 
			$display("operation sw: this stage is useless");
		end
	      end
	default: begin
		$display("NOP in writeback");
	end
	endcase
$display("<===Exit WRITEBACK\n********************\n");
end

endmodule;
 