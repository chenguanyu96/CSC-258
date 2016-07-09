`timescale 1ns / 1ns

module eightbitcounter (SW, KEY, HEX0, HEX1);
	input [1:0] SW;
	input [1:0] KEY;
	output [6:0] HEX0, HEX1;
	wire f0_out, f1_out, f2_out, f3_out, f4_out, f5_out, f6_out, f7_out;
	wire f1_in, f2_in, f3_in, f4_in, f5_in, f6_in, f7_in;
	wire [3:0] main_out_ms;
	wire [3:0] main_out_ls;
	
	TFlipFlop f0 (
		.T(SW[1]),
		.Q(f0_out),
		.clk(KEY[0]),
		.clear(SW[0])
	);
	
	and(f1_in, f0_out, SW[1]);
	
	TFlipFlop f1 (
		.T(f1_in),
		.Q(f1_out),
		.clk(KEY[0]),
		.clear(SW[0])
	);
	
	and(f2_in, f1_out, f1_in);
	
	TFlipFlop f2 (
		.T(f2_in),
		.Q(f2_out),
		.clk(KEY[0]),
		.clear(SW[0])
	);
	
	and(f3_in, f2_out, f2_in);
	
	TFlipFlop f3 (
		.T(f3_in),
		.Q(f3_out),
		.clk(KEY[0]),
		.clear(SW[0])
	);
	
	and(f4_in, f3_out, f3_in);
	
	TFlipFlop f4 (
		.T(f4_in),
		.Q(f4_out),
		.clk(KEY[0]),
		.clear(SW[0])
	);
	
	and(f5_in, f4_out, f4_in);
	
	TFlipFlop f5 (
		.T(f5_in),
		.Q(f5_out),
		.clk(KEY[0]),
		.clear(SW[0])
	);
	
	and(f6_in, f5_out, f5_in);
	
	TFlipFlop f6 (
		.T(f6_in),
		.Q(f6_out),
		.clk(KEY[0]),
		.clear(SW[0])
	);

	and(f7_in, f6_out, f6_in);
	
	TFlipFlop f7 (
		.T(f7_in),
		.Q(f7_out),
		.clk(KEY[0]),
		.clear(SW[0])
	);
	
	assign main_out_ms = {{{f7_out, f6_out}, f5_out}, f4_out};
	assign main_out_ls = {{{f3_out, f2_out}, f1_out}, f0_out};
	
	hexdisplay h0 (
		.hex_digit(main_out_ls),
		.segments(HEX0)
	);
	
	hexdisplay h1 (
		.hex_digit(main_out_ms),
		.segments(HEX1)
	);
	
endmodule

module TFlipFlop (T, Q, clk, clear);
	input T, clk, clear;
	output Q;
	reg Q;
	
	always @(posedge clk, negedge clear)
	begin
		if (clear == 1'b0) 
			Q <= 1'b0;
		else
		begin
			if (T == 1'b1)
				Q <= ~Q;
			else
				Q <= Q;
		end
	end
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
