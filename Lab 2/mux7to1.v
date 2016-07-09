`timescale 1ns / 1ns

module mux(SW, LEDR);
	input [9:0] SW;
	output [1:0] LEDR;
	
	mux7to1 m0(
		.Input(SW[6:0]),
		.MuxSelect(SW[9:7]),
		.m(LEDR[0])
	);
endmodule

module mux7to1(Input, MuxSelect, m);
	input [6:0] Input;
	input [2:0] MuxSelect;
	output m;
	reg m;
	
	always @(*)
	begin
		case(MuxSelect)
			3'b000: m = Input[0];
			3'b001: m = Input[1];
			3'b010: m = Input[2];
			3'b011: m = Input[3];
			3'b100: m = Input[4];
			3'b101: m = Input[5];
			3'b110: m = Input[6];
			default: m = 1'b0;
		endcase
	end
endmodule
