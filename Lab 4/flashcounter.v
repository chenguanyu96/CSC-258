`timescale 1ns / 1ns

module FlashCounter(SW, HEX0, CLOCK_50);
	input [3:0] SW;
	output [6:0] HEX0;
	input CLOCK_50;
	wire [27:0] rd0_out, rd1_out, rd2_out, rd3_out;
	reg Enable;
	wire [3:0] dc0_out;
	
	RateDivider rd00(CLOCK_50, rd0_out, SW[2], 1'b0, 28'b0000000000000000000000000000, SW[3]);
	RateDivider rd01(CLOCK_50, rd1_out, SW[2], 1'b1, 28'b0010111110101111000001111111, SW[3]);
	RateDivider rd10(CLOCK_50, rd2_out, SW[2], 1'b1, 28'b0101111101011110000011111111, SW[3]);
	RateDivider rd11(CLOCK_50, rd3_out, SW[2], 1'b1, 28'b1011111010111100000111111111, SW[3]);
	//RateDivider rd11(CLOCK_50, rd3_out, SW[2], 1'b1, 28'b0000000000000000000000000001, SW[3]);
	
	always @(*)
	begin
		case(SW[1:0])
			2'b00: Enable = (rd0_out == 28'b0000000000000000000000000000) ? 1'b1 : 1'b0;
			2'b01: Enable = (rd1_out == 28'b0000000000000000000000000000) ? 1'b1 : 1'b0;
			2'b10: Enable = (rd2_out == 28'b0000000000000000000000000000) ? 1'b1 : 1'b0;
			2'b11: Enable = (rd3_out == 28'b0000000000000000000000000000) ? 1'b1 : 1'b0;
			default: Enable = 1'b0;
		endcase
	end
	
	DisplayCounter dc0(CLOCK_50, dc0_out, SW[2], Enable);
	hxdisplay hx0(dc0_out, HEX0);
endmodule

module RateDivider(clk, Q, clear, enable, d, ParLoad);
	input clk, enable, clear, ParLoad;
	input [27:0] d;
	output [27:0] Q;
	reg [27:0] Q;
	always @(posedge clk)
	begin
		if(clear == 1'b0)
			Q <= 0;
		else if(ParLoad == 1'b1)
			Q <= d;
		else if(Q == 28'b0000000000000000000000000000)
			Q <= d;
		else if(enable == 1'b1)
			Q <= Q - 1'b1;
		else if(enable == 1'b0)
			Q <= Q;
	end
endmodule

module DisplayCounter(clk, Q, clear, enable);
	input clk, enable, clear;
	output [3:0] Q;
	reg [3:0] Q;
	always @(posedge clk)
	begin
		if(clear == 1'b0)
			Q <= 0;
		else if(enable == 1'b1)
			Q <= Q + 1'b1;
		else if(enable == 1'b0)
			Q <= Q;
	end
endmodule

module hxdisplay(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule
