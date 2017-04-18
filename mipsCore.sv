`include "structures.sv"

`include "instr_decode.sv"
`include "execute.sv"
`include "memAccess.sv"
`include "writeBack.sv"
    
module mipsCore( 
	//ICache Ifc
	input  logic [31:0]        iCacheReadData,
	output logic [31:0]        iCacheReadAddr,

	//DCache Ifc
	input  logic [31:0]        dCacheReadData,
	output logic [31:0]        dCacheWriteData,
	output logic [31:0]        dCacheAddr,
	output logic               dCacheWriteEn,
	output logic               dCacheReadEn,

	//Register File Ifc
	input  logic [31:0]       rfReadData_p0,
	output logic [4:0]        rfReadAddr_p0,
	output logic              rfReadEn_p0,

	input  logic [31:0]        rfReadData_p1,
	output logic [4:0]         rfReadAddr_p1,
	output logic               rfReadEn_p1,

	output logic [31:0]        rfWriteData_p0,
	output logic [4:0]         rfWriteAddr_p0,
	output logic               rfWriteEn_p0,

	// Globals
	input  logic                    clk,
	input  logic    		rst
);

instr_structure iContent;
instr_structure toMem_iCont;
instr_structure toWB_iCont;

logic [31:0]PC = 32'd0; 		// Instruction To-be Executed Counter
logic [31:0]PC_next = 32'd0;
logic [31:0]PC_id;
logic [31:0]PC_ex;
logic [31:0]fetched_val;	//holds the fetched value during instruction fetch stage

logic [6:0]decoded_op;	// value that decides ALU operation
logic [31:0]resultALU;	//result from ALU operation
logic [31:0]result_fromMEM;
logic [31:0]Ldata;	//data from lw instruction

//RS AND RT
logic [31:0]i_rs;
logic [31:0]i_rt;
logic [31:0]op1_id;
logic [31:0]op2_id;
logic [31:0]op2_ALU;
 

//CTRLS 
wire ctrl_memTOreg;
wire ctrl_regWrite;
wire ctrl_memRead; 
wire ctrl_memWrite;
logic ctrl_branch;

//assign ctrl_mem2reg = (iContent.f_dec.mem_op == MEM_OP_NONE) ? 1'b0: 1'b1;


//FLAGS 
logic zFlag = 1'b0;
logic jumpFlag = 1'b0;

integer clock_count = 0;

// im done signals: imdone_if high indicates fetch is done and decode can begin
logic imdone_if, imdone_id, imdone_ex, imdone_mem, imdone_wb ;


//----- RF READ PORTS ------//

assign rfReadAddr_p0  = iCacheReadData[25:21];
assign rfReadAddr_p1  = iCacheReadData[20:16];
//assign rfWriteAddr_p0 = iContent.reg_dest;
  
assign   i_rs= rfReadData_p0;
assign   i_rt= rfReadData_p1;

assign rfReadEn_p0 = 1'b1;
assign rfReadEn_p1 = 1'b1;


//----- RF WRITE PORTS -----//
assign rfWriteEn_p0 =  1'b1;

//----- D CACHE -----//
assign dCacheReadEn  = 1'b1;
assign dCacheWriteEn = 1'b1;

assign dCacheAddr = resultALU;
assign Ldata = dCacheReadData; 

 
//STAGE 1:INSTRUCTION FETCH
assign iCacheReadAddr = PC_next;

always @(posedge clk) begin
clock_count  = clock_count +1;
$display("--------------------\n| clock-cycle = %d \n--------------------",clock_count);

	fetched_val  <= iCacheReadData;
$display("PC VALUE = %d ; instruction fetch: %h", PC_next, iCacheReadData);	

	case({zFlag,jumpFlag})

		2'b00: begin
		PC_next <= PC_next + 3'd4;
		end
	
		2'b01: begin
		PC_next <= PC_id;
		end
	
		2'b10: begin
		PC_next <= PC_ex;
		end

		default: begin
		PC_next <= PC_next + 3'd4; // don't fetch if both the flags are not zero (ie. x or z)
		end	
	
	endcase

	imdone_if <= 1'b1;
end
// INSTRUCTION FETCH ENDS 

   
//STAGE 2:INSTRUCTION DECODE
instr_decode id (.clk(clk), .rst(rst),  
		 .instr(fetched_val), .i_rs(i_rs) , .i_rt(i_rt) ,
		
		.iCont_toALU(iContent) , .opcode_funct(decoded_op), 
		.op1( op1_id), .op2( op2_id), .jFlag(jumpFlag),

		.PC_in(PC_next), .PC_out(PC_id),
		.done_in(imdone_if), .done_out(imdone_id)
		);


//STAGE 3:EXECUTE
execute ex(.clk(clk) , .rst(rst) ,
	    .alu_op_iCont(iContent), .op1(op1_id), .op2(op2_id), 

	   .result(resultALU) , .zeroFlag(zFlag), .hold_op2(op2_ALU), .iCont_out(toMem_iCont),
	   

	   .PC_in(PC_id), .PC_out(PC_alu),
	   .done_in(imdone_id), .done_out(imdone_ex)
	  );
    
//STAGE 4:MEMORY
memAccess mem(  .clk(clk) , .storeData(op2_ALU), .addr(resultALU) , 
		.rfReadAddr_p1(rfReadAddr_p1),.rfReadData_p1(rfReadData_p1), 
		.dCacheAddr(dCacheAddr), .dCacheWriteEn(dCacheWriteEn), 
		.dCacheReadEn(dCacheReadEn),.dCacheReadData(dCacheReadData),
		 .mem_iCont(toMem_iCont) , 

		.dCacheWriteData(dCacheWriteData), .loadedData(Ldata), .resultOut(result_fromMEM), .iCont_out(toWB_iCont),

		.done_in(imdone_ex), .done_out(imdone_mem)
	);
 

//STAGE 5:WRITE-BACK
writeBack wb(   .clk(clk), .lData(Ldata), 
		.result_fromALU(result_fromMEM), .ctrl_mem2reg(ctrl_memTOreg), 
		.wb_iCont(toWB_iCont), 

		.rfWriteData_p0(rfWriteData_p0), 
		.rfWriteAddr_p0(rfWriteAddr_p0),

		.done_in(imdone_mem),.done_out(imdone_wb)
		); 

 
endmodule;