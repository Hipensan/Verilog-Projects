module HA(
	input i_A, 
	input i_B,
	output o_S,
	output o_C
	);

	assign o_S = i_A ^ i_B;
	assign o_C = i_A & i_B;
endmodule


module FA(
	input i_A, 
	input i_B, 
	input i_C,
	output o_S,
	output o_C
	);

	wire HA0_o_S, HA0_o_C;
	wire HA1_o_S, HA1_o_C;

	HA HA0(i_A, i_B, HA0_o_S, HA0_o_C);
	HA HA1(HA0_o_S, i_C, HA1_o_S, HA1_o_C);

	assign 	o_S = HA1_o_S,
			o_C = HA0_o_C | HA1_o_C;

endmodule

module Add4b(
	input [3:0] i_A,
	input [3:0] i_B,
	output wire [3:0] o_S,
	output wire o_C
	);
wire [2:0] cout;

FA HA0(i_A[0], i_B[0], 1'b0, o_S[0], cout[0]);
FA HA1(i_A[1], i_B[1], cout[0], o_S[1], cout[1]);
FA HA2(i_A[2], i_B[2], cout[1], o_S[2], cout[2]);
FA HA3(i_A[3], i_B[3], cout[2], o_S[3], o_C);
endmodule




