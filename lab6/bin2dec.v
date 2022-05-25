module bin2dec(A, D2, D1, D0);
input	 [7:0]A;
output [3:0]D2;
output [3:0]D1;
output [3:0]D0;

wire	 [6:0]remaind;

assign D2 = A / 100;
assign remaind = A % 100;
assign D1 = remaind / 10;
assign D0 = remaind % 10;

endmodule 