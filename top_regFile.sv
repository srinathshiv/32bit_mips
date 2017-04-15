module top_regFile();

logic clk;
logic wr_en;
logic [4:0]rpa_num;
logic [4:0]rpb_num;
logic [4:0]wp_num;
logic [31:0]wp_data;
logic [31:0]rpa_out;
logic [31:0]rpb_out;

regFile rf(.clk(clk), .wr_en(wr_en), .rpa_num(rpa_num), .rpb_num(rpb_num), .wp_num(wp_num), .wp_data(wp_data), .rpa_out(rpa_out), .rpb_out(rpb_out));

initial begin
	clk=1;
end

initial begin
#10
wr_en = 1'b1;
wp_num = 5'b00000;
wp_data= 32'd3;
$display("wp_num = %d \t wp_data = %d wr_en = %d ",wp_num,wp_data, wr_en);
#10		
wp_num = 5'b00001;
wp_data= 32'd6;
$display("wp_num = %d \t wp_data = %d wr_en = %d ",wp_num,wp_data, wr_en);
#10
wp_num = 5'b00010;
wp_data= 32'd9;
$display("wp_num = %d \t wp_data = %d wr_en = %d ",wp_num,wp_data, wr_en);
#10
wr_en = 1'b0;
wp_num = 5'b00011;
wp_data= 32'd12;
$display("wp_num = %d \t wp_data = %d wr_en = %d ",wp_num,wp_data, wr_en);
#10
wr_en = 1'b1;
wp_num = 5'b00100;
wp_data= 32'd15;
$display("wp_num = %d \t wp_data = %d wr_en = %d ",wp_num,wp_data, wr_en);


	
#20
rpa_num = 5'd0;
rpb_num = 5'd1;
#10
$display("rpa_data = %d rpb_data = %d",rpa_out,rpb_out);
#40
rpa_num = 5'd2;
rpb_num = 5'd3;
#10
$display("rpa_data = %d rpb_data = %d",rpa_out,rpb_out);
#40
rpa_num = 5'd4;
rpb_num = 5'd5;
#10
$display("rpa_data = %d rpb_data = %d",rpa_out,rpb_out);

$finish();

end

always begin
#4 clk = ~clk;
end

endmodule;
