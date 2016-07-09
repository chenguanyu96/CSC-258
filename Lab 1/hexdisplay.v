`timescale 1ns / 1ns

/* C_3 - A
 * C_2 - B
 * C_1 - C
 * C_0 - D
*/

module hexdisplay(SW, HEX0);
	input [3:0] SW;
	output [6:0] HEX0;
	
	/* Map inputs to switches and outputs to HEX0 outputs - C_0 to SW[0]
	 * 																	- C_1 to SW[1]
	 *																		- C_2 to SW[2]
	 * 																	- C_3 to SW[3]
	 *																		- out0 to out6 - HEX0[0] to HEX0[6] respectively
	*/
	
	segment_0 seg_0(
		.C_0(SW[0]),
		.C_1(SW[1]),
		.C_2(SW[2]),
		.C_3(SW[3]),
		.out0(HEX0[0])
	);
	
	segment_1 seg_1(
		.C_0(SW[0]),
		.C_1(SW[1]),
		.C_2(SW[2]),
		.C_3(SW[3]),
		.out1(HEX0[1])
	);
	
	segment_2 seg_2(
		.C_0(SW[0]),
		.C_1(SW[1]),
		.C_2(SW[2]),
		.C_3(SW[3]),
		.out2(HEX0[2])
	);
	
	segment_3 seg_3(
		.C_0(SW[0]),
		.C_1(SW[1]),
		.C_2(SW[2]),
		.C_3(SW[3]),
		.out3(HEX0[3])
	);
	
	segment_4 seg_4(
		.C_0(SW[0]),
		.C_1(SW[1]),
		.C_2(SW[2]),
		.C_3(SW[3]),
		.out4(HEX0[4])
	);
	
	segment_5 seg_5(
		.C_0(SW[0]),
		.C_1(SW[1]),
		.C_2(SW[2]),
		.C_3(SW[3]),
		.out5(HEX0[5])
	);
	
	segment_6 seg_6(
		.C_0(SW[0]),
		.C_1(SW[1]),
		.C_2(SW[2]),
		.C_3(SW[3]),
		.out6(HEX0[6])
	);
	
endmodule

// Segment 0 of HEX display module
// Turns on at 0, 2, 3, 5, 7, 8, 9, C_3, C, E, F
module segment_0(C_0, C_1, C_2, C_3, out0);
	input C_0;
	input C_1;
	input C_2;
	input C_3;
	output out0;

	assign out0 = ~((C_3 | C_2 | C_1 | ~C_0) & (C_3 | ~C_2 | C_1 | C_0) & (~C_3 | C_2 | ~C_1 | ~C_0) & (~C_3 | ~C_2 | C_1 | ~C_0));
endmodule

// Segment 1 of HEX display module
// Turns on at 0, 2, 3, 4, 7, 8, 9, C_3, d
module segment_1(C_0, C_1, C_2, C_3, out1);
	input C_0;
	input C_1;
	input C_2;
	input C_3;
	output out1;

	assign out1 = (C_2 & C_1 & ~C_0)  | (C_3 & C_1 & C_0)  | (C_3 & C_2 & ~C_0)  | (~C_3 & C_2 & ~C_1 & C_0);
endmodule

// Segment 2 of HEX display module
// Turns on at 0, 3, 4, 5, 6, 7, 8, 9, C_3, b, d
module segment_2(C_0, C_1, C_2, C_3, out2);
	input C_0;
	input C_1;
	input C_2;
	input C_3;
	output out2;

	assign out2 = (C_3 & C_2 & ~C_0)  | (C_3 & C_2 & C_1)  | (~C_3 & ~C_2 & C_1 & ~C_0);
endmodule

// Segment 3 of HEX display module
// Turns on at 0, 2, 3, 5, 6, 8, 9, b, C, d, E
module segment_3(C_0, C_1, C_2, C_3, out3);
	input C_0;
	input C_1;
	input C_2;
	input C_3;
	output out3;

	assign out3 = ~((~C_2 | ~C_1 | ~C_0) & (C_3 | C_2 | C_1 | ~C_0) & (C_3 | ~C_2 | C_1 | C_0) & (~C_3 | C_2 | ~C_1 | C_0));
endmodule

// Segment 4 of HEX display module
// Turns on at 0, 1, 2, 6, 8, C_3, b, C, d, E, F
module segment_4(C_0, C_1, C_2, C_3, out4);
	input C_0;
	input C_1;
	input C_2;
	input C_3;
	output out4;

	assign out4 = (~C_3 & C_0)  | (~C_2 & ~C_1 & C_0)  | (~C_3 & C_2 & ~C_1);
endmodule


// Segment 5 of HEX display module
// Turns on at 0, 1, 4, 5, 6, 8, 9, C_3, b, C, E, F
module segment_5(C_0, C_1, C_2, C_3, out5);
	input C_0;
	input C_1;
	input C_2;
	input C_3;
	output out5;

	assign out5 = (~C_3 & ~C_2 & C_0)  | (~C_3 & ~C_2 & C_1)  | (~C_3 & C_1 & C_0)  | (C_3 & C_2 & ~C_1 & C_0);
endmodule

// Segment 6 of HEX display module
// Turns on at 2, 3, 5, 6, 8,9, C_3, b, d, E, F
module segment_6(C_0, C_1, C_2, C_3, out6);
	input C_0;
	input C_1;
	input C_2;
	input C_3;
	output out6;

	assign out6 = ~((C_3 | C_2 | C_1) & (C_3 | ~C_2 | ~C_1 | ~C_0) & (~C_3 | ~C_2 | C_1 | C_0));
endmodule

