module lab(	input  CLOCK_50,
				input	 [1:0]KEY,
				input  [9:0]SW,
				output [9:0]LEDR,
				output [7:0]HEX0,
				output [7:0]HEX1,
				output [7:0]HEX2,
				output [7:0]HEX3,
				output [7:0]HEX4,
				output [7:0]HEX5);

	//		declaration 
	wire	press;
	wire	rst;
	wire [8:0]bright;
	reg  [3:0]state;
	reg  [3:0]nstate;
	reg  [3:0]counter;
	reg  [4:0]num[0:5];
	//		end of declaration
	reg [4:0]tmp;
	
	//		assignment 		//dont touch
	assign bright = SW[9:1];
	assign clk = CLOCK_50;
	assign {rst, press} = KEY;
	//		end of assignment
	
	//		sample
	// assign LEDR[0] = state[0] & state[1];
	//
	
	
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)		state <= 0;
		else 			state <= nstate;
	end
	
	always@(negedge press or negedge rst)
	begin
		if(!rst)		nstate <= 0;
		else
		begin
			case(state)
				4'h0: nstate <= (SW[0]) ? 4'h1 : 4'h0;
				4'h1: nstate <= (SW[0]) ? 4'h1 : 4'h2;
				4'h2: nstate <= (SW[0]) ? 4'h3 : 4'h0;
				4'h3: nstate <= (SW[0]) ? 4'h1 : 4'h4;
				4'h4: nstate <= (SW[0]) ? 4'h3 : 4'h5;
				4'h5: nstate <= (SW[0]) ? 4'h6 : 4'h0;
				4'h6: nstate <= (SW[0]) ? 4'h1 : 4'h7;
				4'h7: nstate <= (SW[0]) ? 4'h3 : 4'h0;
				default: nstate <= nstate;
			endcase
		end
	end
	
	always@(posedge clk or negedge rst)
	begin  
		if(!rst) counter <= 0;
		else if(counter == 10)
			counter <= 0;
		else
			counter <= counter + 1;
	end

	always@(posedge clk or negedge rst)
	begin  
		if(!rst)
		begin
			num[0] <= 0;
			num[1] <= 10;
			num[2] <= 10;
			num[3] <= 10;
			num[4] <= 10;
			num[5] <= 10;
		end
		else if(state == 7 && counter >= tmp)
		begin
			num[0] <= state;
			num[2] <= 11;
			num[3] <= 12;
			num[4] <= 13;
			num[5] <= 14;
		end
		else if(counter >= tmp)
			num[0] <= state;
		else
		begin
			num[0] <= 10;
			num[2] <= 10;
			num[3] <= 10;
			num[4] <= 10;
			num[5] <= 10;
		end
	end
	
	always@(posedge clk or negedge rst)
	begin
		casex(bright)
			9'b1xxxxxxxx: tmp <= 9;
			9'bx1xxxxxxx: tmp <= 8;
			9'bxx1xxxxxx: tmp <= 7;
			9'bxxx1xxxxx: tmp <= 6;
			9'bxxxx1xxxx: tmp <= 5;
			9'bxxxxx1xxx: tmp <= 4;
			9'bxxxxxx1xx: tmp <= 3;
			9'bxxxxxxx1x: tmp <= 2;
			9'bxxxxxxxx1: tmp <= 1;
			default: tmp <= 0;
		endcase
	end
	
	//		clock divider				//	dont touch
	div_clk		xc0(.clk(clk), .rst(rst), .clk_1hz(clk_1hz));
		
	//		seven segment decoder	//	dont touch
	seven_seg 	xs0(.clk(clk), .seg_number(num[0]), .seg_data(HEX0));
	seven_seg 	xs1(.clk(clk), .seg_number(num[1]), .seg_data(HEX1));
	seven_seg 	xs2(.clk(clk), .seg_number(num[2]), .seg_data(HEX2));
	seven_seg 	xs3(.clk(clk), .seg_number(num[3]), .seg_data(HEX3));
	seven_seg 	xs4(.clk(clk), .seg_number(num[4]), .seg_data(HEX4));
	seven_seg 	xs5(.clk(clk), .seg_number(num[5]), .seg_data(HEX5));

endmodule

// these entries are added into seven_seg.v 
//	4'd11:seg_data <= 8'b1010_1011; // n
//	4'd12:seg_data <= 8'b1000_0110; // e
//	4'd13:seg_data <= 8'b1000_1100; // p
//	4'd14:seg_data <= 8'b1010_0011; // o
 



