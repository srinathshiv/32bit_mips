module top_execute();

logic clk;
logic reset;
logic [31:0] op1;
logic [31:0] op2;
logic [63:0]result;
logic zeroFlag;

execute ex(.clk(clk), .reset(reset), .op1(op1), .op2(op2), .result(result), .zeroFlag(zeroFlag));

initial begin
clk=1;
reset=0;
end

initial begin
op1=2'b10;
op2=2'b10;
#2
op1=2'b10;
op2=2'b10;
#2
op1=2'd0;
op2=2'd2;
#2
op1=2'd2;
op2=2'd0;
#2
op1=2'd0;
op2=2'd0;
#2
op2=2'd2;

$finish();
end

always begin
#1 clk = ~clk;
end

endmodule