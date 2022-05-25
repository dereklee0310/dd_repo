module CLA(clk, rst, A, B, carry, Y);
input  clk;
input  rst;
input  [3:0]A;
input  [3:0]B;
input  carry;
output [4:0]Y;

reg	 [3:0]P;
reg	 [3:0]G;
reg	 [4:0]S;
reg	 [4:0]C;

assign	Y = S;

always@(posedge clk or negedge rst)
begin  
	if(!rst)
	begin
		P <= 4'd0;
		G <= 4'd0;
		S <= 5'd0;
		C <= 5'd0;
	end
	else
	begin
		// do things here
		P[0] <= A[0] ^ B[0];
		G[0] <= A[0] & B[0];
		
		P[1] <= A[1] ^ B[1];
		G[1] <= A[1] & B[1];
		
		P[2] <= A[2] ^ B[2];
		G[2] <= A[2] & B[2];
		
		P[3] <= A[3] ^ B[3];
		G[3] <= A[3] & B[3];

		S[0] <= carry^ P[0];
		S[1] <= C[1] ^ P[1];
		S[2] <= C[2] ^ P[2];
		S[3] <= C[3] ^ P[3];
		S[4] <= G[3] | (P[3] & C[3]);
		
		C[0] <= carry;
		C[1] <= G[0] | (P[0] & C[0]);
		C[2] <= G[1] | (P[1] & (G[0] | (P[0] & C[0])));
		C[3] <= G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))));
	end
end

endmodule 