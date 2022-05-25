/**
 *
 * @author : 409410090
 * @latest change : 2022/5/18 21:13
 */

`define length 6

module lab8(input clk,
            input reset,
            input give_valid,
            input [7:0]dataX,
            input [7:0]dataY,
            output reg [7:0]ansX,
            output reg [7:0]ansY,
            output reg out_valid);

integer i;
reg [7:0]inX[0:`length-1];
reg [7:0]inY[0:`length-1];
reg [7:0]negcount[0:`length-1];
reg signed [7:0]tempX[0:`length-1];
reg signed [7:0]tempY[0:`length-1];

reg [3:0]count[0:`length-1];
reg [3:0]address[0:`length-1];
reg [3:0]state;
reg [7:0]cnt; // cnt for the loop-alike block
reg [7:0]vector2_idx; // another cnt for sorting

initial begin
    $dumpfile("Lab.vcd");
    $dumpvars(0, lab8tb);
    for(i = 0; i < `length; i = i+1)
        $dumpvars(1, inX[i], inY[i], tempX[i], tempY[i], count[i]);
end

always@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        state <= 1;
        for (i = 0; i < `length; i = i + 1)
        begin
            inX[i] <= 0;
            inY[i] <= 0;
            tempX[i] <= 0;
            tempY[i] <= 0;
            count[i] <= i;
            address[i] <= 0;
            negcount[i] <= 0;
        end
        cnt <= 0;
        vector2_idx <= 0;
        out_valid <= 0;
    end
    else
    begin
        case(state)
            4'd0:begin      // initial state
                state <= 1;
                for (i = 0; i < `length; i = i + 1)
                begin
                    inX[i] <= 0;
                    inY[i] <= 0;
                    tempX[i] <= 0;
                    tempY[i] <= 0;
                    count[i] <= i;
                    address[i] <= 0;
                    negcount[i] <= 0;
                end
                cnt <= 0;
                vector2_idx <= 0;
            end
            4'd1:begin      // read data
                if(cnt == `length)
                begin
                    state <= 2;
                    cnt <= 0;
                end
                else if(give_valid)
                begin
                    inX[cnt] <= dataX;
                    inY[cnt] <= dataY;
                    cnt <= cnt + 1;
                end
            end
            4'd2:begin      // calculate vector from given data
                if(cnt == `length)
                begin
                    state <= 3;
                    cnt <= 0;
                end
                else
                begin
                    tempX[cnt] <= inX[cnt] - inX[0];
                    tempY[cnt] <= inY[cnt] - inY[0];
                    cnt <= cnt + 1;
                end
            end
            4'd3:begin      // count the offset between vectors (counterclockwise)
                if (cnt == `length-1)
                begin
                    if(vector2_idx == `length-1)
                    begin
                        state <= 4;
                        cnt <= 0;
                    end
                    else
                        vector2_idx <= vector2_idx+1;
                    cnt <= 0;
                end
                else
                    cnt <= cnt+1;

                if((tempX[cnt] * tempY[vector2_idx] - tempX[vector2_idx] * tempY[cnt]) < 0)
                    negcount[cnt] <= negcount[cnt] + 1;
            end
            4'd4:begin      // sort the position of vectors
                if(cnt > `length)
                begin
                    state <= 5;
                    cnt <= 0;
                end
                else
                begin
                    address[negcount[cnt] + 1] <= cnt;
                    cnt <= cnt + 1;
                end
            end
            4'd5:begin      // output answer and back to initial state
                if(cnt == `length)
                begin
                    state <= 0; // turn it to initial state to reset all data
                    out_valid <= 0; // set output signal to low
                end
                else
                begin
                    if(out_valid == 0)
                        out_valid <= 1;
                    ansX <= inX[address[cnt]];
                    ansY <= inY[address[cnt]];
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

endmodule

/*==================================*/