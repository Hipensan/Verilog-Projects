module KeyPad(
	input 				i_Clk,
	input 				i_Rst,
	input 		[3:0] 	i_Col,
	output reg 	[3:0] 	o_Row,
	output reg 	[3:0] 	o_Num,
	output 				o_fDone,

	output 		[1:0]	debug_State,
	output		[3:0]	debug_Col,
	output		[3:0]	debug_Row,
	output				debug_fPush
	);

parameter 	LST_CNT = 100_000_00 / 20 - 1;	// 0.2s
// parameter	LST_CNT = 100 / 20 - 1; //simulation
parameter 	IDLE 	= 2'b00,
			SCAN	= 2'b01,
			ROW23 	= 2'b10,
			ROW13 	= 2'b11;

reg [1:0] 	c_State		, n_State;
reg [23:0] 	c_Cnt		, n_Cnt;
// reg [6:0]	c_Cnt		, n_Cnt; //sim
reg 		c_Pushed23	, n_Pushed23;
reg [3:0]	c_Num		, n_Num;
wire 		fPush;


assign fPush	= ~&i_Col;
assign o_fDone 	= c_State == ROW13;

assign debug_State	= c_State;
assign debug_Col	= i_Col;
assign debug_Row	= o_Row;
assign debug_fPush	= o_fDone;



always@(posedge i_Clk, negedge i_Rst) begin
	if(!i_Rst) begin
		c_State 	= IDLE;
		c_Cnt 		= 0;
		c_Pushed23 	= 0;
		c_Num		= 0;
	end else begin
		c_State 	= n_State;
		c_Cnt 		= n_Cnt;
		c_Pushed23 	= n_Pushed23;
		c_Num		= n_Num;
	end
end


always@* begin
	o_Num = c_Num;
	n_State = c_State;
	n_Cnt = c_Cnt;
	n_Pushed23 = c_Pushed23;
	n_Num = c_Num;

	case(c_State)
		IDLE: begin
			o_Row = 4'b0000;
			n_Cnt = 17'b0;
			n_State = fPush ? SCAN : IDLE;
		end

		SCAN: begin
			o_Row = 4'b0000;
			if(c_Cnt == LST_CNT) begin
				case(i_Col) 
					4'b0111: n_Num[1:0] = 2'b00; 4'b1011: n_Num[1:0] = 2'b01; 4'b1101: n_Num[1:0] = 2'b10; default: n_Num[1:0] = 2'b11;
				endcase
				n_State = ROW23;
			end else begin
				n_Cnt = n_Cnt + 1;
				n_State = fPush ? SCAN : IDLE;
			end
		end

		ROW23: begin
			o_Row = 4'b1100;
			n_Pushed23 = fPush;	
			n_State = ROW13;
		end

		ROW13: begin
			o_Row = 4'b1010;
			// if(c_Pushed23) begin
				//o_Row = fPush ? 4'b1110 : 4'b1101; 
				// Row = fPush ? 2'b11 : 2'b10;
			// 	n_Num[3:2] = fPush ? 2'b11 : 2'b10; 
			// end else begin
				// o_Row = fPush ? 4'b1011 : 4'b0111;
				// Row = fPush ? 2'b01 : 2'b00;
			// 	n_Num[3:2] = fPush ? 2'b01 : 2'b00;
			// end
			n_Num[3:2] = {c_Pushed23, fPush};
			
			// case(o_Row) 
			// 	4'b0111: Row = 2'b00; 4'b1011: Row = 2'b01; 4'b1101: Row = 2'b10; default: Row = 2'b11;
			// endcase
			n_State = IDLE;
		end	
	endcase
end
endmodule