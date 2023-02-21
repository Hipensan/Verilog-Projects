// 변수 재정의
// 한번씩만 정의해야 함
// 변수가 너무 많음

// 분기가 다른 경우에만 같은 값을 

// && 를 참고해서 사용하자
//  ? 는 and로 변환되니까 주의
/*---------------------------------------------------

	KeyExpansion.v

Top module에서 Cipher Key를 받아 와서 Round Key 생성
31:0 의 32 비트를 RotWord 하고 sbox에 넣어서 치환한 결과를 레지스터에 저장 (라운드 마다)


	date : 01/30/23 (mm-dd-yy)
	Author : YH J

----------------------------------------------------*/


module KeyExpansion(
	input [127:0] 	i_Key,
	input [3:0] 	Rnd,
	input 			i_fDec, //1이면 dec, 0이면 enc
	input 			i_fRKey,
	output [127:0] 	Round_Key
	);


reg [127:0] rKey, o_rKey;
reg [31:0] i_sbox;
reg [7:0] Rcon;

wire [31:0] sbox_in, sbox_out;
assign sbox_in = i_sbox;


aes_sbox rKey_SBOX0(sbox_in[31:24]	, 	sbox_out[31:24]);
aes_sbox rKey_SBOX1(sbox_in[23:16]	, 	sbox_out[23:16]);
aes_sbox rKey_SBOX2(sbox_in[15:8]	, 	sbox_out[15:8]);
aes_sbox rKey_SBOX3(sbox_in[7:0]	, 	sbox_out[7:0]);

assign Round_Key = o_rKey;

always@* begin
	
	if(i_fRKey) begin  //decryption

		// 이전 라운드 키 구하기
		rKey[31:0] = i_Key[31:0] ^ i_Key[63:32];
		rKey[63:32] = i_Key[63:32] ^ i_Key[95:64];
		rKey[95:64] = i_Key[95:64] ^ i_Key[127:96];
	
		// RotWord
		o_rKey[31:0] = { rKey[23:0], rKey[31:24] };
		i_sbox = o_rKey[31:0];
		rKey[127:96] = i_Key[127:96] ^ sbox_out ^ {Rcon, 24'b0};

		o_rKey = rKey;
// 복호화에서 127:96 부분이 문제가 있는데..


	end else begin //i_fDec = 0일 때, encryption
	
		// RotWord
		i_sbox = {i_Key[23:0], i_Key[31:24]};
	
		//Generate Round Key
		
		//rKey[127:120] = rKey[127:120] ^ Rcon;       재정의시에는 겹친 부분이 사라짐(하위 아랫순위)
		o_rKey[127:96] 	= i_Key[127:96] 	^ sbox_out 	^ {Rcon, 24'b0};
		o_rKey[95:64] 	= o_rKey[127:96] 	^ i_Key[95:64];
		o_rKey[63:32] 	= o_rKey[95:64] 	^ i_Key[63:32];
		o_rKey[31:0] 	= o_rKey[63:32] 	^ i_Key[31:0];
		
end

end

always@* begin
	case(Rnd)
		4'h0	: Rcon = 8'h01;
		4'h1	: Rcon = 8'h02;
		4'h2	: Rcon = 8'h04;
		4'h3	: Rcon = 8'h08;
		4'h4	: Rcon = 8'h10;
		4'h5	: Rcon = 8'h20;
		4'h6	: Rcon = 8'h40;
		4'h7	: Rcon = 8'h80;
		4'h8	: Rcon = 8'h1b;
		default	: Rcon = 8'h36;
		
	endcase
end

endmodule


