`timescale 1ns / 1ns

module fourbitadder(SW, LEDR);
	input [8:0] SW;
	output [9:0] LEDR;
	wire c_1;
	wire c_2;
	wire c_3;
	
	fulladder FA0 (
		.a(SW[4]),
		.b(SW[0]),
		.c_i(SW[8]),
		.s(LEDR[0]),
		.c_o(c_1)
	);
	
	fulladder FA1 (
		.a(SW[5]),
		.b(SW[1]),
		.c_i(c_1),
		.s(LEDR[1]),
		.c_o(c_2)
	);
	
	fulladder FA2 (
		.a(SW[6]),
		.b(SW[2]),
		.c_i(c_2),
		.s(LEDR[2]),
		.c_o(c_3)
	);
	
	fulladder FA3 (
		.a(SW[7]),
		.b(SW[3]),
		.c_i(c_3),
		.s(LEDR[3]),
		.c_o(LEDR[9])
	);
endmodule

module fulladder(a, b, c_i, s, c_o);
	input a, b, c_i;
	output s, c_o;
	
	assign s = (a ^ b) ^ c_i;
	assign c_o = b & ~(a ^ b) | c_i & (a ^ b);
endmodule
