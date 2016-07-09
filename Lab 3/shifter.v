`timescale 1ns / 1ns

module Shifter (SW, KEY, LEDR);
	input [9:0] SW;
	input [3:0] KEY;
	output [7:0] LEDR;
	
	shifter s0 (
		.LoadVal(SW[7:0]),
		.Load_n(KEY[1]),
		.ShiftRight(KEY[2]),
		.ASR(KEY[3]),
		.clk(KEY[0]),
		.reset_n(SW[9]),
		.shifter_out(LEDR[7:0])
	);
endmodule

module shifter(LoadVal, Load_n, ShiftRight, ASR, clk, reset_n, shifter_out);
	input [7:0] LoadVal;
	input Load_n, ShiftRight, ASR, clk, reset_n;
	output [7:0] shifter_out;
	wire in_wire;
	
	mux21 mx0 (
		.x(ASR),
		.y(shifter_out[7]),
		.s(ASR),
		.m(in_wire)
	);
	
	ShifterBit sb0 (
		.load_val(LoadVal[0]),
		.in(shifter_out[1]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n),
		.out(shifter_out[0])
	);
	
	ShifterBit sb1 (
		.load_val(LoadVal[1]),
		.in(shifter_out[2]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n),
		.out(shifter_out[1])
	);
	
	ShifterBit sb2 (
		.load_val(LoadVal[2]),
		.in(shifter_out[3]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n),
		.out(shifter_out[2])
	);
	
	ShifterBit sb3 (
		.load_val(LoadVal[3]),
		.in(shifter_out[4]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n),
		.out(shifter_out[3])
	);
	
	ShifterBit sb4 (
		.load_val(LoadVal[4]),
		.in(shifter_out[5]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n),
		.out(shifter_out[4])
	);
	
	ShifterBit sb5 (
		.load_val(LoadVal[5]),
		.in(shifter_out[6]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n),
		.out(shifter_out[5])
	);
	
	ShifterBit sb6 (
		.load_val(LoadVal[6]),
		.in(shifter_out[7]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n),
		.out(shifter_out[6])
	);
	
	ShifterBit sb7 (
		.load_val(LoadVal[7]),
		.in(in_wire),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n),
		.out(shifter_out[7])
	);
endmodule

module ShifterBit(load_val, in, shift, load_n, clk, reset_n, out);
	input load_val, in, shift, load_n, clk, reset_n;
	output out;
	wire output_from_mux;
	wire flipflop_input;
	
	mux21 m0(.x(out), .y(in), .s(shift), .m(output_from_mux));
	mux21 m1(.x(load_val), .y(output_from_mux), .s(load_n), .m(flipflop_input));
	DFlipFlop DFF1(.D(flipflop_input), .reset_n(reset_n), .clk(clk), .Q(out));
endmodule

module mux21(x, y, s, m);
	input x, y, s;
	output m;
	
	assign m = x & ~s | y & s;
endmodule

module DFlipFlop(D, reset_n, clk, Q);
	input D, reset_n, clk;
	output Q;
	reg Q;
	
	always @(posedge clk)
	begin
		if(reset_n == 1'b0)
			Q <= 0;
		else 
			Q <= D;
	end
endmodule

//module sign_ext(asr, s_out);
//	input asr;

//endmodule
