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
instr = 32'h00431020;
#2
instr = 32'h00431024;
#2
instr = 32'h00431022;
#2
instr = 32'h00431025;
#2
instr = 32'h20420002;
#2
instr = 32'h00431020;
#2
instr = 32'h00431025;
$finish();
end

always begin
#1 clk = ~clk;
end

endmodule
