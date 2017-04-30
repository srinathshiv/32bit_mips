module iCache(input clk,input [31:0]iCacheReadAddr, output logic [31:0]iCacheReadData);

logic [31:0]icache[128:0];

always@(posedge clk) begin
	iCacheReadData <= icache[iCacheReadAddr];
end

//---------------------jump check---------------------------------------------------------
/*assign icache[0]   = 32'h20_01_00_0f;  //ADDI reg0+ 0x000f to reg1
assign icache[4]   = 32'h08_00_00_08;  //JUMP to addr 0x20(decimal 32)
assign icache[8]   = 32'h20_02_00_08;  //ADDI reg0+ 0x0008 to reg2
assign icache[12]    = 32'h20_03_00_09; //ADDI reg0+ 0x0009 to reg3
assign icache[16]   = 32'h20_04_00_09; //ADDI reg0+ 0x0009 to reg4
assign icache[20]   = 32'h20_06_00_09;
assign icache[24]   = 32'h20_07_00_09;
assign icache[28]   = 32'hac_41_00_00; // store word from reg1 (contains f) to reg2+0(addr 8) 
assign icache[32]    = 32'h20_03_00_09;
assign icache[36]   = 32'h20_04_00_09;
assign icache[40]   = 32'h20_05_00_09;
assign icache[44]   = 32'h20_06_00_09;
*/

//--------------------- arithmetic and mem instructions ---------------------------------------
/*assign icache[0]   = 32'h20_01_00_0f;  //ADDI reg0+ 0x000f to reg1
assign icache[4]   = 32'h20_02_00_08;  //ADDI reg0+ 0x0008 to reg2
assign icache[8]    = 32'h20_03_00_09; //ADDI reg0+ 0x0009 to reg3
assign icache[12]   = 32'h20_04_00_09; //ADDI reg0+ 0x0009 to reg4
assign icache[16]   = 32'h20_05_00_09;
assign icache[20]   = 32'h20_06_00_09;
assign icache[24]   = 32'h20_07_00_09;
assign icache[28]   = 32'hac_41_00_00; // store word from reg1 (contains f) to reg2+0(addr 8) 
assign icache[32]    = 32'h20_03_00_09;
assign icache[36]   = 32'h20_04_00_09;
assign icache[40]   = 32'h20_05_00_09;
assign icache[44]   = 32'h20_06_00_09;
assign icache[48]   = 32'h20_07_00_09;
assign icache[52]   = 32'h8c_41_00_00; // load word from reg2+0(addr 8) to reg1
assign icache[56]    = 32'h20_03_00_09;
assign icache[60]   = 32'h20_04_00_09;
assign icache[64]   = 32'h20_05_00_09;
assign icache[68]   = 32'h20_06_00_09;
assign icache[72]   = 32'h20_07_00_09;
assign icache[76]   = 32'h20_08_00_09;
assign icache[80]   = 32'h00_43_08_20; // add contents in reg2 and reg3 and store it in reg1
*/

//---------------------- Stall - load dependency check------------------------------------------------------
assign icache[0]   = 32'h20_01_00_0f;  //ADDI reg0+ 0x000f to reg1
assign icache[4]   = 32'h20_02_00_08;  //ADDI reg0+ 0x0008 to reg2
assign icache[8]    = 32'h20_03_00_09; //ADDI reg0+ 0x0009 to reg3
assign icache[12]   = 32'h20_04_00_09; //ADDI reg0+ 0x0009 to reg4
assign icache[16]   = 32'h20_05_00_09;
assign icache[20]   = 32'h20_06_00_09;
assign icache[24]   = 32'h20_07_00_09;
assign icache[28]   = 32'hac_41_00_00; // store word from reg1 (contains f) to reg2+0(addr 8) 
assign icache[32]    = 32'h20_03_00_09;
assign icache[36]   = 32'h20_04_00_09;
assign icache[40]   = 32'h20_05_00_09;
assign icache[44]   = 32'h20_06_00_09;
assign icache[48]   = 32'h20_07_00_09;
assign icache[52]   = 32'h8c_41_00_00; // load word from reg2+0(addr 8) to reg1
assign icache[56]   = 32'h00_22_20_20;




endmodule;
