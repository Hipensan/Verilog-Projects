module tb_AES;

reg 	i_Clk;
reg 	i_Rst;
reg		AES_i_Start;
reg		AES_i_fDec;
reg		[127:0] AES_i_Key;
reg		[127:0] AES_i_Text;
wire	[127:0] AES_o_Text;
wire	AES_o_fDone;

parameter KEY	= 128'h2b7e151628aed2a6_abf7158809cf4f3c;
parameter PTEXT = 128'h3243f6a8885a308d_313198a2e0370734;
parameter CTEXT	= 128'h3925841d02dc09fb_dc118597196a0b32;

AES AES0(i_Clk, i_Rst, AES_i_Start, AES_i_fDec, AES_i_Key, AES_i_Text, AES_o_fDone, AES_o_Text);

always
	#50	i_Clk = ~i_Clk;

initial
begin
	i_Clk = 1;
	i_Rst = 0;
	AES_i_Start = 0;
	AES_i_fDec	= 0;
	AES_i_Key   = 0;
	AES_i_Text  = 0;
	
	@(posedge i_Clk)	#50 i_Rst = 1;
	@(posedge i_Clk)	AES_i_Start = 1; AES_i_Text = PTEXT; AES_i_Key = KEY; 
	@(posedge i_Clk)	AES_i_Start = 0;
	@(posedge AES_o_fDone);
	@(negedge i_Clk)
	if(AES_o_Text == CTEXT) begin 
	$display("%x", AES_o_Text); 
	end

	@(posedge i_Clk)	AES_i_fDec = 1; AES_i_Start = 1; AES_i_Text = CTEXT; AES_i_Key = KEY; 
	@(posedge i_Clk)	AES_i_Start = 0;
	@(posedge AES_o_fDone);
	@(negedge i_Clk)
	if(AES_o_Text == PTEXT) begin 
	$display("%x", AES_o_Text); 
	end

end
endmodule


