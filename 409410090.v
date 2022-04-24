`include "sample.v"

module Lab4(
	input [3:0] a,
	input [3:0] b,
	output [7:0]result
	);
	wire [3:0] m1;
	wire [3:0] m2;
	wire [3:0] m3;
	wire [3:0] m4;
	wire [3:0] carry1;
	wire [3:0] carry2;
	wire [3:0] carry3;
	wire [4:0] sum1;
	wire [4:0] sum2;
	wire [4:0] sum3;

	// use for loop instead?
	MULTIPLY M1(.mtpend(a), .mtpier(b[0]), .product(m1));
	MULTIPLY M2(.mtpend(a), .mtpier(b[1]), .product(m2));
	MULTIPLY M3(.mtpend(a), .mtpier(b[2]), .product(m3));
	MULTIPLY M4(.mtpend(a), .mtpier(b[3]), .product(m4));
	
	//	assign result[0] = m1[0];
	AND2X1 R0(.A(m1[0]), .B(m1[0]), .Y(result[0]));

	// add m1 and m2
	FULL_ADDER C1_0(.bit1(m1[1]), .bit2(m2[0]), .cin(1'b0), .sum(sum1[0]), .cout(carry1[0]));
	FULL_ADDER C1_1(.bit1(m1[2]), .bit2(m2[1]), .cin(carry1[0]), .sum(sum1[1]), .cout(carry1[1]));
	FULL_ADDER C1_2(.bit1(m1[3]), .bit2(m2[2]), .cin(carry1[1]), .sum(sum1[2]), .cout(carry1[2]));
	FULL_ADDER C1_3(.bit1(1'b0), .bit2(m2[3]), .cin(carry1[2]), .sum(sum1[3]), .cout(carry1[3])); // for the next FULL_ADDER
	
	//	assign sum1[4] = carry1[3];
	AND2X1 S1_4(.A(carry1[3]), .B(carry1[3]), .Y(sum1[4]));
	// assign result[1] = sum1[0];
	AND2X1 R1(.A(sum1[0]), .B(sum1[0]), .Y(result[1]));

	// add sum1 and m3
	FULL_ADDER C2_0(.bit1(sum1[1]), .bit2(m3[0]), .cin(1'b0), .sum(sum2[0]), .cout(carry2[0]));
	FULL_ADDER C2_1(.bit1(sum1[2]), .bit2(m3[1]), .cin(carry2[0]), .sum(sum2[1]), .cout(carry2[1]));
	FULL_ADDER C2_2(.bit1(sum1[3]), .bit2(m3[2]), .cin(carry2[1]), .sum(sum2[2]), .cout(carry2[2]));
	FULL_ADDER C2_3(.bit1(sum1[4]), .bit2(m3[3]), .cin(carry2[2]), .sum(sum2[3]), .cout(carry2[3]));
	
	// assign sum2[4] = carry2[3];
	AND2X1 S2_4(.A(carry2[3]), .B(carry2[3]), .Y(sum2[4]));
	// assign result[2] = sum2[0];
	AND2X1 R_2(.A(sum2[0]), .B(sum2[0]), .Y(result[2]));
	

	// add sum2 and m4
	FULL_ADDER C3_0(.bit1(sum2[1]), .bit2(m4[0]), .cin(1'b0), .sum(sum3[0]), .cout(carry3[0]));
	FULL_ADDER C3_1(.bit1(sum2[2]), .bit2(m4[1]), .cin(carry3[0]), .sum(sum3[1]), .cout(carry3[1]));
	FULL_ADDER C3_2(.bit1(sum2[3]), .bit2(m4[2]), .cin(carry3[1]), .sum(sum3[2]), .cout(carry3[2]));
	FULL_ADDER C3_3(.bit1(sum2[4]), .bit2(m4[3]), .cin(carry3[2]), .sum(sum3[3]), .cout(carry3[3]));

	//	assign sum3[4] = carry3[3];
	AND2X1 S3_4(.A(carry3[3]), .B(carry3[3]), .Y(sum3[4]));
	
	// assign sum3 to result
	//	assign result[3] = sum3[0];
	//	assign result[4] = sum3[1];
	//	assign result[5] = sum3[2];
	//	assign result[6] = sum3[3];
	//	assign result[7] = sum3[4];
	AND2X1 R3(.A(sum3[0]), .B(sum3[0]), .Y(result[3]));
	AND2X1 R4(.A(sum3[1]), .B(sum3[1]), .Y(result[4]));
	AND2X1 R5(.A(sum3[2]), .B(sum3[2]), .Y(result[5]));
	AND2X1 R6(.A(sum3[3]), .B(sum3[3]), .Y(result[6]));
	AND2X1 R7(.A(sum3[4]), .B(sum3[4]), .Y(result[7]));
endmodule

module MULTIPLY(
	mtpend,
	mtpier,
	product
	);
	input [3:0] mtpend;
	input mtpier;
	output [3:0] product;

	// use for loop instead?
	AND2X1 P1(.A(mtpend[0]), .B(mtpier), .Y(product[0]));
	AND2X1 P2(.A(mtpend[1]), .B(mtpier), .Y(product[1]));
	AND2X1 P3(.A(mtpend[2]), .B(mtpier), .Y(product[2]));
	AND2X1 P4(.A(mtpend[3]), .B(mtpier), .Y(product[3]));
endmodule

module FULL_ADDER(
	bit1,
	bit2,
	cin,
	sum,
	cout
	);
	input bit1;
	input bit2;
	input cin;
	output sum;
	output cout;
	wire tmp1;
	wire tmp2;
	wire tmp3;
	// calculate the sum using two bits and carry from low bit
	XOR2X1 T1(.A(bit1), .B(bit2), .Y(tmp1));
	XOR2X1 S(.A(tmp1), .B(cin), .Y(sum));

	// calculate the carry using two bits and carry from low bit
	AND2X1 T2(.A(bit1), .B(bit2), .Y(tmp2));
	AND2X1 T3(.A(tmp1), .B(cin), .Y(tmp3));
	OR2X1 COUT(.A(tmp2), .B(tmp3), .Y(cout));
endmodule

