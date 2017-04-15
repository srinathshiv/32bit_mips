//`include "structures.sv"

module memAccess(input clk, input [31:0]addr, 
		 input [4:0]rfReadAddr_p1,input [31:0]rfReadData_p1, 
		 input [31:0]dCacheAddr, input [31:0] dCacheWriteData,
		 input [31:0]dCacheReadData,
		 input  instr_structure mem_iCont,
		 output reg [31:0]loadedData);

logic [31:0]data;
assign  rfReadAddr_p1 = mem_iCont.reg_dest;
assign dCacheAddr = addr ;

always @(posedge clk) begin
$display("--->Entering mem access");
$display(mem_iCont.f_dec.mem_op); 
	case (mem_iCont.f_dec.mem_op)
		MEM_OP_SW: begin
			$display("operation: STORE_WORD");
			 data <= rfReadData_p1;
		end
		
		MEM_OP_LW: begin
			$display("operation: LOAD WORD");
			loadedData <= dCacheReadData;	
		end
		
		MEM_OP_NONE: begin
			$display("NOT A MEMORY OPERATION");
			data <= data;
		end
		
	endcase
	
$display("<===Exiting mem access");
end

assign dCacheWriteData = (mem_iCont.f_dec.mem_op == MEM_OP_SW) ? data : 0 ;

endmodule;