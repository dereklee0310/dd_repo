module seven_seg(clk, seg_number, seg_data);
input  clk;
input  [2:0]seg_number;
output reg [7:0]seg_data;

always@(posedge clk) 
begin
	case(seg_number)
			//	dp|gfe_dcba
			3'd1:seg_data <= 8'b1100_0110; // c
			3'd3:seg_data <= 8'b1001_0010; // s
			3'd5:seg_data <= 8'b1100_1111; // i
			3'd7:seg_data <= 8'b1000_0110; // e
			default:seg_data <= 8'b1111_1111; // all dark
	endcase
end

endmodule 