`timescale 1ns / 1ns

module mainalu(SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input [7:0] SW;
	input [2:0] KEY;
	output [7:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	aluunit alu0 (
		.A(SW[7:4]),
		.B(SW[3:0]),
		.func(KEY[2:0]),
		.ALUout(LEDR[7:0])
	);
	
	hexdisplay hx0 (
		.C_0(SW[0]),
		.C_1(SW[1]),
		.C_2(SW[2]),
		.C_3(SW[3]),
		.out0(HEX0[0]),
		.out1(HEX0[1]),
		.out2(HEX0[2]),
		.out3(HEX0[3]),
		.out4(HEX0[4]),
		.out5(HEX0[5]),
		.out6(HEX0[6])
	);
	
	hexdisplay hx1 (
		.C_0(1'b0),
		.C_1(1'b0),
		.C_2(1'b0),
		.C_3(1'b0),
		.out0(HEX1[0]),
		.out1(HEX1[1]),
		.out2(HEX1[2]),
		.out3(HEX1[3]),
		.out4(HEX1[4]),
		.out5(HEX1[5]),
		.out6(HEX1[6])
	);
	
	hexdisplay hx2 (
		.C_0(SW[4]),
		.C_1(SW[5]),
		.C_2(SW[6]),
		.C_3(SW[7]),
		.out0(HEX2[0]),
		.out1(HEX2[1]),
		.out2(HEX2[2]),
		.out3(HEX2[3]),
		.out4(HEX2[4]),
		.out5(HEX2[5]),
		.out6(HEX2[6])
	);
	
	hexdisplay hx3 (
		.C_0(1'b0),
		.C_1(1'b0),
		.C_2(1'b0),
		.C_3(1'b0),
		.out0(HEX3[0]),
		.out1(HEX3[1]),
		.out2(HEX3[2]),
		.out3(HEX3[3]),
		.out4(HEX3[4]),
		.out5(HEX3[5]),
		.out6(HEX3[6])
	);
	
	hexdisplay hx4 (
		.C_0(LEDR[0]),
		.C_1(LEDR[1]),
		.C_2(LEDR[2]),
		.C_3(LEDR[3]),
		.out0(HEX4[0]),
		.out1(HEX4[1]),
		.out2(HEX4[2]),
		.out3(HEX4[3]),
		.out4(HEX4[4]),
		.out5(HEX4[5]),
		.out6(HEX4[6])
	);
	
	hexdisplay hx5 (
		.C_0(LEDR[4]),
		.C_1(LEDR[5]),
		.C_2(LEDR[6]),
		.C_3(LEDR[7]),
		.out0(HEX5[0]),
		.out1(HEX5[1]),
		.out2(HEX5[2]),
		.out3(HEX5[3]),
		.out4(HEX5[4]),
		.out5(HEX5[5]),
		.out6(HEX5[6])
	);
	
endmodule

module aluunit(A, B, func, ALUout);
	input [3:0] A;
	input [3:0] B;
	input [2:0] func;
	output [7:0] ALUout;	
	reg [7:0] ALUout;
	wire [3:0] case_0_out;
	wire carry;
	wire [2:0] f;
	assign f[0] = ~func[0];
	assign f[1] = ~func[1];
	assign f[2] = ~func[2];
	
	fourbtadder fba1 (
		.A(A[3:0]),
		.B(B[3:0]),
		.C_i(1'b0),
		.C_o(carry),
		.S(case_0_out)
	);
	
	always @(*)
	begin
		case(f)
			3'b000: 
				begin
					ALUout[3:0] = case_0_out;
					ALUout[4] = carry;
					ALUout[7:5] = 3'b000;
				end
			3'b001: ALUout = {4'b0000, A + B};
			3'b010: ALUout = {A | B, A ^ B};
			3'b011: ALUout = (A | B != 4'b0000) ? 8'b00000001 : 8'b00000000;
			3'b100: ALUout = & {A,B};//(A & B == 4'b1111) ? 8'b00000001 : 8'b00000000; 
			3'b101: ALUout = {A, B};
			default: ALUout = 8'b00000000;
		endcase
	end
endmodule

module hexdisplay(C_0, C_1, C_2, C_3, out0, out1, out2, out3, out4, out5, out6);
	input C_0;
	input C_1;
	input C_2;
	input C_3;
	output out0, out1, out2, out3, out4, out5, out6;
	
	assign out0 = ~((C_3 | C_2 | C_1 | ~C_0) & (C_3 | ~C_2 | C_1 | C_0) & (~C_3 | C_2 | ~C_1 | ~C_0) & (~C_3 | ~C_2 | C_1 | ~C_0));
	assign out1 = (C_2 & C_1 & ~C_0)  | (C_3 & C_1 & C_0)  | (C_3 & C_2 & ~C_0)  | (~C_3 & C_2 & ~C_1 & C_0);
	assign out2 = (C_3 & C_2 & ~C_0)  | (C_3 & C_2 & C_1)  | (~C_3 & ~C_2 & C_1 & ~C_0);
	assign out3 = ~((~C_2 | ~C_1 | ~C_0) & (C_3 | C_2 | C_1 | ~C_0) & (C_3 | ~C_2 | C_1 | C_0) & (~C_3 | C_2 | ~C_1 | C_0));
	assign out4 = (~C_3 & C_0)  | (~C_2 & ~C_1 & C_0)  | (~C_3 & C_2 & ~C_1);
	assign out5 = (~C_3 & ~C_2 & C_0)  | (~C_3 & ~C_2 & C_1)  | (~C_3 & C_1 & C_0)  | (C_3 & C_2 & ~C_1 & C_0);
	assign out6 = ~((C_3 | C_2 | C_1) & (C_3 | ~C_2 | ~C_1 | ~C_0) & (~C_3 | ~C_2 | C_1 | C_0));
endmodule

module fourbtadder(A, B, C_i, C_o, S);
	input [3:0] A, B;
	input C_i;
	output C_o;
	output [3:0] S;
	wire c_1;
	wire c_2;
	wire c_3;
	
	fadder FA0 (
		.a(A[0]),
		.b(B[0]),
		.c_i(C_i),
		.s(S[0]),
		.c_o(c_1)
	);
	
	fadder FA1 (
		.a(A[1]),
		.b(B[1]),
		.c_i(c_1),
		.s(S[1]),
		.c_o(c_2)
	);
	
	fadder FA2 (
		.a(A[2]),
		.b(B[2]),
		.c_i(c_2),
		.s(S[2]),
		.c_o(c_3)
	);
	
	fadder FA3 (
		.a(A[3]),
		.b(B[3]),
		.c_i(c_3),
		.s(S[3]),
		.c_o(C_o)
	);
endmodule

module fadder(a, b, c_i, s, c_o);
	input a, b, c_i;
	output s, c_o;
	
	assign s = (a ^ b) ^ c_i;
	assign c_o = b & ~(a ^ b) | c_i & (a ^ b);
endmodule
