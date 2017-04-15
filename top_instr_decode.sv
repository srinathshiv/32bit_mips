

module top_instr_decode();

logic clk;
logic rst;
logic [31:0] instr;

instr_decode id(.clk(clk), .rst(rst), .instr(instr));

initial begin
clk=1;
rst=0;
end

initial begin
instr = 32'h01_4b_48_20;
#4
instr = 32'h01_4b_48_24;
#4
instr = 32'h01_4b_48_25;
#4
instr = 32'h01_4b_48_25;
#4
instr = 32'h21_49_00_05;
#4
instr = 32'h21_49_00_05;
#4
instr = 32'h21_49_00_05;
#4
instr = 32'h21_49_00_05;
#4
instr = 32'h21_49_00_05;

$finish();
end

always begin
#2 clk = ~clk;
end

endmodule
