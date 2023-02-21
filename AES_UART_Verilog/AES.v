module AES(
	input i_Clk,
	input i_Rst,
	input i_Start,
	input i_fDec,
	input [127:0] i_Key,
	input [127:0] i_Text,
	output o_fDone,
	output [127:0] o_Text
	);


parameter 	IDLE 		= 3'b000,
			INIT 		= 3'b001,
			ROUND 		= 3'b010,
			LSTROUND 	= 3'b011,
			DONE 		= 3'b100;

reg [3:0] c_Rnd, n_Rnd;
reg [2:0] c_State, n_State;
reg [127:0] c_Text, n_Text;
reg [127:0] c_Key, n_Key;

wire [127:0] i_SB_E, o_SB_E, i_SB_D, o_SB_D;
wire [127:0] i_SRs_E, o_SRs_E, i_SRs_D, o_SRs_D;
wire [127:0] i_MC, o_MC, i_MC_D;
wire 		 i_fRKey;
wire [127:0] i_RKey, o_RKey;

// KeyExpansion
// i_Key, Rnd, i_fDec, i_fRKey, Round_Key
KeyExpansion	KeyEx0(i_RKey, c_Rnd, i_fDec, i_fRKey, o_RKey);

// Subbyte
// 8-data input, output : Transform i_Text
aes_sbox	SB0(i_SB_E[	127:120], o_SB_E[127:120]);
aes_sbox	SB1(i_SB_E[	119:112], o_SB_E[119:112]);
aes_sbox	SB2(i_SB_E[	111:104], o_SB_E[111:104]);
aes_sbox	SB3(i_SB_E[	103:96]	, o_SB_E[103:96]);
aes_sbox	SB4(i_SB_E[	95:88]	, o_SB_E[95:88]);
aes_sbox	SB5(i_SB_E[	87:80]	, o_SB_E[87:80]);
aes_sbox	SB6(i_SB_E[	79:72]	, o_SB_E[79:72]);
aes_sbox	SB7(i_SB_E[	71:64]	, o_SB_E[71:64]);
aes_sbox	SB8(i_SB_E[	63:56]	, o_SB_E[63:56]);
aes_sbox	SB9(i_SB_E[	55:48]	, o_SB_E[55:48]);
aes_sbox	SB10(i_SB_E[47:40]	, o_SB_E[47:40]);
aes_sbox	SB11(i_SB_E[39:32]	, o_SB_E[39:32]);
aes_sbox	SB12(i_SB_E[31:24]	, o_SB_E[31:24]);
aes_sbox	SB13(i_SB_E[23:16]	, o_SB_E[23:16]);
aes_sbox	SB14(i_SB_E[15:8]	, o_SB_E[15:8]);
aes_sbox	SB15(i_SB_E[7:0]	, o_SB_E[7:0]);

// Inv_Subbyte
// 8-data input, output
Inv_aes_sbox	SBD0(i_SB_D[127:120], o_SB_D[127:120]);
Inv_aes_sbox	SBD1(i_SB_D[119:112], o_SB_D[119:112]);
Inv_aes_sbox	SBD2(i_SB_D[111:104], o_SB_D[111:104]);
Inv_aes_sbox	SBD3(i_SB_D[103:96]	, o_SB_D[103:96]);
Inv_aes_sbox	SBD4(i_SB_D[95:88]	, o_SB_D[95:88]);
Inv_aes_sbox	SBD5(i_SB_D[87:80]	, o_SB_D[87:80]);
Inv_aes_sbox	SBD6(i_SB_D[79:72]	, o_SB_D[79:72]);
Inv_aes_sbox	SBD7(i_SB_D[71:64]	, o_SB_D[71:64]);
Inv_aes_sbox	SBD8(i_SB_D[63:56]	, o_SB_D[63:56]);
Inv_aes_sbox	SBD9(i_SB_D[55:48]	, o_SB_D[55:48]);
Inv_aes_sbox	SBD10(i_SB_D[47:40]	, o_SB_D[47:40]);
Inv_aes_sbox	SBD11(i_SB_D[39:32]	, o_SB_D[39:32]);
Inv_aes_sbox	SBD12(i_SB_D[31:24]	, o_SB_D[31:24]);
Inv_aes_sbox	SBD13(i_SB_D[23:16]	, o_SB_D[23:16]);
Inv_aes_sbox	SBD14(i_SB_D[15:8]	, o_SB_D[15:8]);
Inv_aes_sbox	SBD15(i_SB_D[7:0]	, o_SB_D[7:0]);

//ShiftRows / InvShiftRows
// 128-data input, output
ShiftRows		SRs0(i_SRs_E, o_SRs_E);
Inv_ShiftRows	InvSRs0(i_SRs_D, o_SRs_D);

// MixColumns
// 32-data input, i_fDec, 32-data output
MixCol 		MC0(i_MC[127:96], i_fDec, o_MC[127:96]);
MixCol 		MC1(i_MC[95:64]	, i_fDec, o_MC[95:64]);
MixCol 		MC2(i_MC[64:32]	, i_fDec, o_MC[63:32]);
MixCol 		MC3(i_MC[31:0]	, i_fDec, o_MC[31:0]);

assign	i_SB_E	= i_fDec ? 0 : c_Text;
assign 	i_SB_D	= i_fDec ? c_Text : 0;
assign	i_SRs_E	= i_fDec ? 0 : o_SB_E;
assign	i_SRs_D	= i_fDec ? o_SB_D : 0;
assign	i_MC_D 	= i_fDec ? o_SRs_D ^ o_RKey : 0 ;
assign	i_MC	= i_fDec ? i_MC_D : o_SRs_E;
assign	i_RKey 	= c_Key;

assign	i_fRKey = i_fDec ? ( c_State == 3'b010 || c_State == 3'b011) ? 1 : 0 : 0; 
assign o_fDone 	= c_State == DONE;
assign o_Text  	= o_fDone ? c_Text : 0;


always@(posedge i_Clk, negedge i_Rst) begin
	if(!i_Rst) begin
		c_State = IDLE;
		c_Text 	= 0;
		c_Key 	= 0;
		c_Rnd	= 0;
	end else begin
		c_State = n_State;
		c_Text	= n_Text;
		c_Key	= n_Key;
		c_Rnd	= n_Rnd;
	end
end


always@* begin
	n_Key 	= c_Key;
	n_Text 	= c_Text;
	n_State = c_State;
	n_Rnd 	= 0;
	case(c_State)
		IDLE: begin
			if(i_Start) begin
				n_Key = i_Key;

				if(i_fDec) begin
					n_Text = i_Text;		// Dec 단계
					n_State = INIT;
				end else begin
					n_Text = i_Text ^ i_Key;		// Enc 단계
					n_State = ROUND;
				end
			end
		end
		
		INIT: begin
			n_Rnd = c_Rnd + 1;
			n_Key = o_RKey;

			if(c_Rnd == 9) begin
				n_Text = c_Text ^ o_RKey;
				n_Rnd = c_Rnd;
				n_State = ROUND;
			end
		end
		
		ROUND: begin
			n_Key = o_RKey;
			if(i_fDec) begin
				n_Rnd = c_Rnd - 1;
				n_Text = o_MC;

				if(c_Rnd == 1) begin
					n_State = LSTROUND;
				end
			end else begin
				n_Rnd = c_Rnd + 1;
				n_Text = o_MC ^ o_RKey;

				if(c_Rnd == 8) begin
					n_State = LSTROUND;
				end
			end
		end
		
		LSTROUND: begin
			n_Key = o_RKey;
			n_State = DONE;

			if(i_fDec) begin
				n_Text = o_SRs_D ^ o_RKey;
			end else begin
				n_Text = o_SRs_E ^ o_RKey;
			end			
		end

		DONE: begin
			n_State = IDLE;
		end
endcase
end
endmodule