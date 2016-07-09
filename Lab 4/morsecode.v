`timescale 1ns / 1ns // `timescale time_unit/time_precision

module MorseCode(CLOCK_50, LEDR, SW, KEY);
	input CLOCK_50;
	input [2:0] SW;
	input [1:0] KEY;	
	output [0:0] LEDR;

	wire [27:0] Q;
	wire clk;
	
	wire [11:0] morse_code;
	wire out;
	LUT lut(SW[2:0], morse_code);
	RteDivider rd0(CLOCK_50, KEY[0], 28'b0001011111010111100000111111, Q);
	
	assign clk = (Q == 0 ? 1 : 0);
	ShiftRegister r0(morse_code, KEY[0], KEY[1], clk, 1'b0, 1'b1, out);
	
	assign LEDR[0] = out;
endmodule

module LUT(letter, morse_code);
	input [2:0] letter;
	output reg [11:0] morse_code;

	always @(letter)
	begin
	case(letter)
		3'b000: morse_code = 12'b000000011101;
		3'b001: morse_code = 12'b000101010111;
		3'b010: morse_code = 12'b010111010111;
		3'b011: morse_code = 12'b000001010111;
		3'b100: morse_code = 12'b000000000001;
		3'b101: morse_code = 12'b000101110101;
		3'b110: morse_code = 12'b000101110111;
		3'b111: morse_code = 12'b000001010101;
	endcase
	end
endmodule

module RteDivider(clk, reset, timer, Q);
	input clk, reset;
	input [27:0] timer;
	output reg [27:0] Q;

	always @(posedge clk)
	begin
		if(reset == 1'b0) 
			Q <= 0;
		else if(Q == 0)
			Q <= timer;
		else 
			Q <= Q - 1'b1;
	end
endmodule

module ShiftRegister(Load_Val, reset, load, clk, in, shift, Q);
	input [11:0] Load_Val;
	input reset, in, shift;
	input load;
	input clk;
	output Q;

	wire [11:0] bit;
	assign Q = bit[0];
	
	ShifterBit sb11(in, Load_Val[11], shift, load, reset, clk, bit[11]);
	ShifterBit sb10(bit[11], Load_Val[10], shift, load, reset, clk, bit[10]);
	ShifterBit sb9(bit[10], Load_Val[9], shift, load, reset, clk, bit[9]);
	ShifterBit sb8(bit[9], Load_Val[8], shift, load, reset, clk, bit[8]);
	ShifterBit sb7(bit[8], Load_Val[7], shift, load, reset, clk, bit[7]);
	ShifterBit sb6(bit[7], Load_Val[6], shift, load, reset, clk, bit[6]);
	ShifterBit sb5(bit[6], Load_Val[5], shift, load, reset, clk, bit[5]);
	ShifterBit sb4(bit[5], Load_Val[4], shift, load, reset, clk, bit[4]);
	ShifterBit sb3(bit[4], Load_Val[3], shift, load, reset, clk, bit[3]);
	ShifterBit sb2(bit[3], Load_Val[2], shift, load, reset, clk, bit[2]);
	ShifterBit sb1(bit[2], Load_Val[1], shift, load, reset, clk, bit[1]);
	ShifterBit sb0(bit[1], Load_Val[0], shift, load, reset, clk, bit[0]);

endmodule

module ShifterBit (in, load_val, shift, load_n, reset_n, clk, out);
	input in, load_val, shift, load_n, reset_n, clk;
	output out;
	
	wire mux_out;
	mux2to1 mux1(out, in, shift, mux_out);
	mux2to1 mux2(load_val, mux_out, load_n, mux2_out);
	DFlipFlop dff(reset_n, clk, mux2_out, out);
endmodule

module DFlipFlop(reset, clk, d, Q);
	input clk, reset, d;
	output reg Q;

	always @(posedge clk)
	begin 
		if (reset == 1'b0)
			Q <= 1'b0;
		else
			Q <= d;
	end
endmodule

module mux2to1(x, y, s, m);
    input x;
    input y; 
    input s; 
    output m; 
  
    assign m = s & y | ~s & x;

endmodule