//`include"structures.sv"

module writeBack( input clk, input [31:0]lData, input [31:0]result_fromALU, input ctrl_mem2reg, input instr_structure wb_iCont);

assign ctrl_mem2reg = (wb_iCont.f_dec.mem_op != MEM_OP_NONE) ? 1:0;

always @(posedge clk) begin
	case (ctrl_mem2reg)
	1'b0: regFile[wb_iCont.reg_dest] <= result_fromALU;
	1'b1: regFile[wb_iCont.reg_dest] <= lData;
	endcase
end

endmodule;
