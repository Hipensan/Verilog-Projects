module measurement(
input CLK_50M,
input RST,
input Echo,
output reg Trig,
output  [15:0] data

);

reg [23:0] cnt_trig;
always @ (posedge CLK_50M or negedge RST)
begin
	if(!RST)
		cnt_trig<=1'b0;
	else
		if(cnt_trig =='d500) begin	
			Trig<=0;
			cnt_trig<=cnt_trig+1'b1;
			end
		else 
			begin
				if(cnt_trig=='d1_000_000)
					begin
						Trig<=1;
						cnt_trig<=0;
					end				
				else
					cnt_trig<=cnt_trig+1'b1;
			end
end





reg Echo_2 , Echo_1, cnt_en, flag;
wire p_Echo,n_Echo;
assign p_Echo = (~Echo_2)&&Echo_1;
assign n_Echo = Echo_2&&(~Echo_1);
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10; 
reg[1:0] curr_state;
reg [15:0] cnt;
reg [15:0] dis_reg;
reg [15:0] cnt_17k;
always @ (posedge CLK_50M or negedge RST)
begin
	if(!RST)
		begin
			Echo_1 <= 1'b0;
			Echo_2 <= 1'b0;
			cnt_17k <=1'b0;
			dis_reg <=1'b0;
			curr_state <= S0;
		end
	else	
		begin
			Echo_1<=Echo;
			Echo_2<=Echo_1;
			case(curr_state)
			S0:begin
					if (p_Echo)
						curr_state <= S1;
					else
						begin
							cnt <= 1'b0;
						end
				end
			S1:begin
					if(n_Echo)
						curr_state <= S2;
					else
						begin
							if(cnt_17k <16'd2940)
							begin
								cnt_17k <= cnt_17k + 1'b1;
								
							end
							else
							begin
								cnt_17k <= 1'b0;
								cnt[3:0] <= cnt[3:0] +1'b1;
							end
								if(cnt[3:0] >= 'd10)
								begin
									cnt [3:0] <=1'b0;
									cnt [7:4]<=cnt[7:4]+1'b1;
								end
								if (cnt[7:4] >= 'd10)
								begin
									cnt[7:4]<=1'b0;
									cnt[11:8]<=cnt[11:8]+1'b1;
								end
								if (cnt[11:8]>='d10)
								begin
									cnt[11:8]<=1'b0;
									cnt[15:12]<=cnt[15:12]+1'b1;
								end
								
								if(cnt[15:12]>='d10)
								begin
									cnt[15:12]<=1'b0;
								end					
						end				
				end
			S2:begin
				dis_reg =cnt;
				cnt =1'b0;
				curr_state = S0;
				end
			endcase	
		end
end

assign data = dis_reg ; 
endmodule



