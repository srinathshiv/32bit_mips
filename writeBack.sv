//`include"structures.sv"

module writeBack( 
		input clk, 
		input [31:0]lData, 
		input [31:0]result_fromALU, 
		input ctrl_mem2reg, 
		input instr_structure wb_iCont, 
		
		output logic [31:0]rfWriteData_p0,
		output logic [4:0]rfWriteAddr_p0,
		output logic rfWriteEn_p0,

		input logic   done_in ,
		output logic  done_out
		);
 
assign ctrl_mem2reg = (wb_iCont.f_dec.mem_op == MEM_OP_NONE) ? 1'b0: 1'b1;
assign rfWriteEn_p0 = (wb_iCont.f_dec.mem_op == MEM_OP_NONE) ? 1'b1: 1'b0;

always_comb begin
rfWriteAddr_p0 = wb_iCont.reg_dest;

	if( done_in == 1'b1) begin

		case (ctrl_mem2reg) 

		1'b0: begin 
		
			rfWriteAddr_p0 = wb_iCont.reg_dest;
			rfWriteData_p0 = result_fromALU;
		
	     	end
	
		1'b1: begin
			if(wb_iCont.f_dec.mem_op == MEM_OP_LW) begin
			rfWriteAddr_p0 = wb_iCont.reg_dest;
			rfWriteData_p0 = lData;
			end
	    	end

		default: begin
			$display("NOP in writeback");
		end
		endcase
	
	done_out = done_in;	
	end // if( done_in == 1'b1)

	else if(done_in == 1'b0) begin
		done_out = 1'b0;
	end
end // always_comb

endmodule;
 