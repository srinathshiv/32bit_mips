//`include "structures.sv"
 
module memAccess(input clk, 
		 input logic [31:0] storeData,
		 input [31:0]addr, 
		 input [4:0]rfReadAddr_p1,
  		 input [31:0]rfReadData_p1, 
		 input logic [31:0]dCacheAddr, 
		 input logic dCacheWriteEn,
		 input logic dCacheReadEn, 
		 input logic [31:0]dCacheReadData,
		 input  instr_structure mem_iCont,
		 
		 output logic [31:0]dCacheWriteData,
	 	 output logic [31:0]loadedData,
		 output logic [31:0]resultOut,
		 output instr_structure iCont_out,

		input logic    done_in,
		output logic    done_out
		);
 
logic [31:0]data;
//assign rfReadAddr_p1 = mem_iCont.reg_dest;
//assign dCacheAddr = addr ;
assign dCacheWriteEn = 1'b1;

always @(posedge clk) begin

if(done_in == 1'b1) begin

	$display("--->Entering mem access");
	//$display("calculated address: %d",addr);
	//$display("dCache details:");
	//$display("dCache write enable: %d",dCacheWriteEn);
	//$display("dCacheAddr: %h(hex) %d(dec)",dCacheAddr,dCacheAddr);
	//$display("dCacheWriteData: %d",dCacheWriteData);
	//$display("dCacheReadData : %d",dCacheReadData);

	case (mem_iCont.f_dec.mem_op)
		MEM_OP_SW: begin
			$display("operation: STORE_WORD");
			 //data <= rfReadData_p1;
			dCacheWriteData <= storeData;
			$display("storing data,  rfReadData_p1= %d  into dCache addr %d", rfReadData_p1, dCacheAddr);
		end
		
		MEM_OP_LW: begin
			$display("operation: LOAD WORD");
			loadedData <= dCacheReadData;	
			$display("loading data,  loadedData = %d , dCacheReadData = %d from dCache addr %d", loadedData, dCacheReadData, dCacheAddr);
		end
		
		MEM_OP_NONE: begin
			$display("NOT A MEMORY OPERATION");
			data <= data;
		end
		
	endcase
	
	$display("<===Exiting mem access");
	done_out   <= done_in;
	resultOut <= addr ; 
	iCont_out <= mem_iCont;

end // if

else if(done_in == 1'b0) begin
	done_out <= 1'b0;
end

end

//assign dCacheWriteData = (mem_iCont.f_dec.mem_op == MEM_OP_SW) ? data : 0 ;

endmodule;