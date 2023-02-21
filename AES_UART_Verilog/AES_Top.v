module AES_Top(
	input i_Clk,
	input i_Rst,
	input i_Rx,
	output o_Tx,
	output [8:0] o_LED
	);


// params
parameter 	IDLE		= 3'h0,
			RX_KEY		= 3'h1,
			RX_TEXT 	= 3'h2,
			START_AES 	= 3'h3,
			WAIT_AES 	= 3'h4,
			TX_RES 		= 3'h5,
			TX_TEXT 	= 3'h6;


reg [1:0] 	 c_Cmd,		n_Cmd;
reg [127:0]  c_Key,		n_Key;
reg [127:0]  c_Text, 	n_Text;
reg [2:0] 	 c_State, 	n_State;
reg [3:0] 	 c_ByteCnt,	n_ByteCnt;

wire 		 o_Rx_fDone;
wire [7:0] 	 o_Rx_Data;

wire 		 i_fTx;
wire 		 o_Tx_fDone, o_Tx_fRdy;
wire [7:0] 	 o_Tx;

wire 		 i_AES_fStart, i_AES_fDec;
wire [127:0] i_AES_Key, i_AES_Text;
wire 		 o_AES_fDone;
wire [127:0] o_AES_Text;

UART_RX RX0(i_Clk, i_Rst, i_Rx, o_Rx_fDone, o_Rx_Data);
UART_TX TX0(i_Clk, i_Rst, i_fTx, i_Tx_Data, o_Tx_fDone, o_Tx_fRdy, o_Tx);
AES AES0(i_Clk, i_Rst, i_AES_fStart, i_AES_fDec, i_AES_Key, i_AES_Text, o_AES_fDone, o_AES_Text);


assign i_fTx = o_Tx_fRdy && (c_State == TX_RES || c_State == TX_TEXT);
assign i_Tx_Data = c_State == TX_RES ? c_Cmd : c_Text[127:120];
assign i_AES_fStart = c_State == START_AES;
assign i_AES_fDec = c_Cmd[0];
assign i_AES_Key = c_State == RX_KEY ? (o_Rx_fDone && c_ByteCnt) ? c_Key : i_AES_Key : i_AES_Key;
// assign i_AES_Key = c_State == START_AES ? c_Key : 0;
assign i_AES_Text = c_State == RX_TEXT ? (o_Rx_fDone && c_ByteCnt) ? c_Text : i_AES_Text : i_AES_Text;
// assign i_AES_Text = c_State == START_AES ? c_Text : 0;

assign o_LED = {c_Cmd, c_State, c_ByteCnt};  //2, 3, 4  ->9bits

always@(posedge i_Clk, negedge i_Rst)
	if(!i_Rst) begin
		c_State = IDLE;
		c_Cmd = 0;
		c_Key = 0;
		c_Text = 0;
		c_ByteCnt = 0;
	end else begin
		c_State = n_State;
		c_Cmd = n_Cmd;
		c_Key = n_Key;
		c_Text = n_Text;
		c_ByteCnt = n_ByteCnt;
	end


always@* begin
	// Sustain
	n_State = c_State;
	n_ByteCnt = 0;
	//n_ByteCnt = c_ByteCnt;
	n_Cmd = c_Cmd;
	n_Text = c_Text;
	n_Key = c_Key;

	case(c_State) 
		IDLE: begin
			if(o_Rx_fDone) begin
				n_Cmd = o_Rx_Data;
				if(o_Rx_Data[1]) 	n_State = RX_TEXT;
				else				n_State = RX_KEY;
			end
		end

		RX_KEY: begin
			n_Key = o_Rx_fDone ? {c_Key[119:0], o_Rx_Data} : c_Key;
			n_ByteCnt = o_Rx_fDone ? c_ByteCnt + 1 : c_ByteCnt;
			n_State = (o_Rx_fDone && &c_ByteCnt) ? TX_RES : RX_KEY;
			// if(o_Rx_fDone) begin
				// n_Key = {c_Key[119:0], o_Rx_Data};
				// n_ByteCnt = c_ByteCnt + 1;
				// if(&c_ByteCnt) n_State = TX_RES;
				// c_ByteCnt는 1111 도달시 n_State가 변경되지만 n_ByteCnt의 다음 상태는 0000으로 초기화
				// 따라서 n_ByteCnt는 IDLE상태에서 한번 초기화 해주는 과정만 있으면 될 듯 하다(사실 필요없을듯 함)
		end

		RX_TEXT: begin
			n_Text = o_Rx_fDone ? {c_Text[119:0], o_Rx_Data} : c_Text;
			n_ByteCnt = o_Rx_fDone ? c_ByteCnt + 1 : c_ByteCnt;
			n_State = (o_Rx_fDone && &c_ByteCnt) ? START_AES : RX_TEXT;
			// if(o_Rx_fDone) begin
				// n_Text = {c_Text[119:0], o_Rx_Data};
				// n_ByteCnt = c_ByteCnt + 1;
				// if(&c_ByteCnt) n_State = START_AES;
				
		end

		START_AES: begin
			n_State = WAIT_AES;
		end

		WAIT_AES: begin
			n_Text = o_AES_fDone ? o_AES_Text : c_Text;
			n_State = o_AES_fDone ? TX_RES : WAIT_AES;
			// if(o_AES_fDone) begin
				// n_Text = o_AES_Text;
				// n_State = TX_RES;
		end

		TX_RES: begin
			n_State = o_Tx_fDone ? c_Cmd[1] ? TX_TEXT : IDLE : TX_RES;
		end

		TX_TEXT: begin
			n_Text = o_Tx_fDone ? {c_Text[119:0], o_Rx_Data} : c_Text;
			n_ByteCnt = o_Tx_fDone ? c_ByteCnt + 1 : c_ByteCnt;
			n_State = (o_Tx_fDone && &c_ByteCnt) ? IDLE : TX_TEXT;
			// if(o_Tx_fDone) begin
				// n_Text = {c_Text[119:0], o_Rx_Data};
				// n_ByteCnt = c_ByteCnt + 1;
				// if(&c_ByteCnt) n_State = IDLE;

		end
	endcase
end
endmodule