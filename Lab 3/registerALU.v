`timescale 1ns / 1ns

module registeredALU (SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input [9:0] SW;
	input [3:0] KEY;
	output [7:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire [7:0] noreg_out;
	wire [7:0] reg_out;
	
	alu alu0 (
		.A(SW[3:0]),
		.B(reg_out[3:0]),
		.func(KEY[3:1]),
		.ALUout(noreg_out)
	);
	
	parallelPETFlipFlop r0 (
		.d(noreg_out),
		.clock(KEY[0]),
		.reset_n(SW[9]),
		.q(reg_out)
	);
	
	assign LEDR[7:0] = reg_out;
	
	hexdisplay hx0 (.hex_digit(SW[3:0]), .segments(HEX0[6:0]));
	hexdisplay hx1 (.hex_digit(4'b0000), .segments(HEX1[6:0]));
	hexdisplay hx2 (.hex_digit(4'b0000), .segments(HEX2[6:0]));
	
	hexdisplay hx3 (.hex_digit(4'b0000), .segments(HEX3[6:0]));
	hexdisplay hx4 (.hex_digit(reg_out[7:4]), .segments(HEX5[6:0]));
	hexdisplay hx5 (.hex_digit(reg_out[3:0]), .segments(HEX4[6:0]));
endmodule

module alu (A, B, func, ALUout);
	input [3:0] A, B;
	input [2:0] func;
	output [7:0] ALUout;
	reg [7:0] ALUout;
	wire [3:0] case_0_out;
	wire carry;
	
	fourbitadder fba0 (.A(A[3:0]), .B(B[3:0]), .C_i(1'b0), .C_o(carry), .S(case_0_out));
	
	always @(*)
	begin
		case(func)
			3'b000: 
				begin
					ALUout[3:0] = case_0_out;
					ALUout[4] = carry;
					ALUout[7:5] = 3'b000;
				end	
			3'b001: ALUout = A + B;
			3'b010: ALUout = {A ^ B, A | B};
			3'b011: ALUout = | {A, B};
			3'b100: ALUout = & {A, B};
			3'b101: ALUout = B << A;
			3'b110: ALUout = B >> A;
			3'b111: ALUout = A * B;
			default: ALUout = 8'b00000000;
		endcase
	end
endmodule

module parallelPETFlipFlop(d, clock, reset_n, q);
	input [7:0] d;
	input clock, reset_n;
	output [7:0] q;
	reg [7:0] q;

	always @(posedge clock)
	begin
		if(reset_n == 1'b0)
			q <= 0;
		else
			q <= d;
	end
endmodule

module fourbitadder(A, B, C_i, C_o, S);
	input [3:0] A, B;
	input C_i;
	output C_o;
	output [3:0] S;
	wire c_1;
	wire c_2;
	wire c_3;
	
	fulladder FA0 (
		.a(A[0]),
		.b(B[0]),
		.c_i(C_i),
		.s(S[0]),
		.c_o(c_1)
	);
	
	fulladder FA1 (
		.a(A[1]),
		.b(B[1]),
		.c_i(c_1),
		.s(S[1]),
		.c_o(c_2)
	);
	
	fulladder FA2 (
		.a(A[2]),
		.b(B[2]),
		.c_i(c_2),
		.s(S[2]),
		.c_o(c_3)
	);
	
	fulladder FA3 (
		.a(A[3]),
		.b(B[3]),
		.c_i(c_3),
		.s(S[3]),
		.c_o(C_o)
	);
endmodule

module fulladder(a, b, c_i, s, c_o);
	input a, b, c_i;
	output s, c_o;
	
	assign s = (a ^ b) ^ c_i;
	assign c_o = b & ~(a ^ b) | c_i & (a ^ b);
endmodule

module hexdisplay(hex_digit, segments);
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
