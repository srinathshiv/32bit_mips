//`include "structures.sv"
 
module memAccess(input clk, 
		 input logic [31:0] storeData,
		 input [31:0]addr, 
		 input [4:0]rfReadAddr_p1,
  		 input [31:0]rfReadData_p1, 
		 
		 input logic [31:0]dCacheReadData,
		 input  instr_structure mem_iCont,
		 
		 output logic [31:0]dCacheWriteData,
	 	 output logic [31:0]loadedData,
		 output logic [31:0]resultOut,
		 output instr_structure iCont_out,
		 output logic [31:0]dCacheAddr, 
		 output logic dCacheWriteEn,
		 output logic dCacheReadEn, 

		input logic    done_in,
		output logic    done_out
		);
 
logic [31:0]data;

assign dCacheAddr = addr ;
assign dCacheWriteEn = (mem_iCont.f_dec.mem_op == MEM_OP_SW) ? 1'b1: 1'b0;
assign dCacheReadEn  = (mem_iCont.f_dec.mem_op == MEM_OP_LW) ? 1'b1: 1'b0;

always_comb begin
	case (mem_iCont.f_dec.mem_op)
	MEM_OP_SW: begin dCacheWriteData = storeData; end
	endcase
end

always @(posedge clk) begin

	if(done_in == 1'b1) begin

		case (mem_iCont.f_dec.mem_op)
		
		MEM_OP_LW: begin loadedData <= dCacheReadData; end
		
		MEM_OP_NONE: begin $display(""); end
		
		endcase
	
		done_out   <= done_in;
		resultOut <= addr ; 
		iCont_out <= mem_iCont;

	end // if(done_in == 1'b1)

	else if(done_in == 1'b0) begin
	done_out <= 1'b0;
	end

end

endmodule;