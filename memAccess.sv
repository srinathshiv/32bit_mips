//`include "structures.sv"

module memAccess(input clk, input [31:0]addr, input  instr_structure mem_iCont, output reg [31:0]loadedData);

logic [31:0]data;

always @(posedge clk) begin
 
	case (mem_iCont.f_dec.mem_op)
		MEM_OP_SW: begin
			 data <= regFile[mem_iCont.reg_dest];
			 dCache[addr] <= data;
		end
		
		MEM_OP_LW: begin
			loadedData <= dCache[addr];
			//mem2reg = 1'b1;
		end
		
		default: begin
			data <= data;
		end
		
	endcase
	

end


endmodule;