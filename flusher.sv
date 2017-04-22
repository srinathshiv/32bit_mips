//`include "structures.sv"

module flusher( input clk,input rst,
		input jumpFlag,input zFlag,

		output instr_structure iContent,
		output instr_structure toMem_iCont,
		output logic [31:0]fetched_val);

always @(posedge clk) begin
	fetched_val <= ( jumpFlag || zFlag ) ? 32'd0 : fetched_val ;	
	iContent    <= ( jumpFlag || zFlag ) ? 0 : iContent ; 
	toMem_iCont <= ( zFlag) ? 0 : toMem_iCont;
end

endmodule;