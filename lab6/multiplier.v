module multiplier(clk, rst, A, B, Y);
input	 clk;
input	 rst;
input	 [3:0]A;
input  [2:0]B;
output [7:0]Y;

reg [7:0]m1;
reg [7:0]m2;
reg [7:0]m3;

reg [7:0]tmp;


assign Y = tmp;

always@(posedge clk or negedge rst)
begin  
	if(!rst)
	begin
		tmp <= 8'b0;
	end
	else
	begin
		m1 <= A[3:0] & {4{B[0]}};
		m2 <= A[3:0] & {4{B[1]}};
		m3 <= A[3:0] & {4{B[2]}};
		
		tmp <= m1 + (m2 << 1) + (m3 << 2);
	end
end


endmodule 