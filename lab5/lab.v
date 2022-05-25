module lab(clk, rst, seg);
input	 clk;
input	 rst;
output[7:0]seg;
reg [2:0]cnt; // 3bits to utilize overflow
wire clk_1hz;

always@(posedge clk_1hz or negedge rst)
begin
	if(!rst)
	begin
		cnt <= 0; // all dark
	end
	else
	begin
			cnt <= cnt + 1;
	end
end

div_clk		(.clk(clk), .rst(rst), .clk_1hz(clk_1hz));
seven_seg 	(.clk(clk), .seg_number(cnt), .seg_data(seg));

endmodule 
