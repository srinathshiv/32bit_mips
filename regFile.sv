module regFile(
	input clk,
	input wr_en,
	input [4:0]rpa_num, input [4:0]rpb_num, input [4:0]wp_num, input [31:0]wp_data,
	output [31:0]rpa_out,output  [31:0]rpb_out);


reg [31:0]rf[31:0];


assign rpa_out = rf [rpa_num];
assign rpb_out = rf [rpb_num];


always @(posedge clk) begin
	rf[0] <= 1'b0;
		if (wr_en==1'b1 && wp_num != 1'b0) begin
			rf[wp_num] <=  wp_data;
		end
end

endmodule;