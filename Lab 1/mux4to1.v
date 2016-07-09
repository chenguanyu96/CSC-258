`timescale 1ns / 1ns

/* SW[0] - U
 * SW[1] - V
 * SW[2] - W
 * SW[3] - X
 * SW[8] - S0
 * SW[9] - S1
*/

module mux4to1(SW, LEDR);
	input [9:0] SW;
	output [9:0] LEDR;
	wire u_mux_w;
	wire v_mux_x;
	
	// First 2-to-1 multiplexer to choose between U and W using S0
	mux2to1 m1(
		.x(SW[0]),
		.y(SW[2]),
		.s(SW[8]),
		.m(u_mux_w)
	);
	
	// Second 2-to-1 multiplexer to choose between V and X using S0
	mux2to1 m2(
		.x(SW[1]),
		.y(SW[3]),
		.s(SW[8]),
		.m(v_mux_x)
	);

	// Last 2-to-1 multiplexer to choose between the output of the first and second multiplexer using S1
	mux2to1 m3(
		.x(u_mux_w),
		.y(v_mux_x),
		.s(SW[9]),
		.m(LEDR[0])
	);
endmodule

module mux2to1(x, y, s, m);
	input x;
	input y;
	input s;
	output m;
	
	assign m = x & ~s | y & s;
endmodule
