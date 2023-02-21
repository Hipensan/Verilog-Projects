module tb_KeyPad();


	reg i_Clk;
	reg i_Rst;
	reg [3:0] i_Col;
	reg i_Btn;
	wire [3:0] o_Row;
	wire [3:0] o_Num;
	wire [2:0] debug_State;
	wire [3:0] debug_Col;
	wire [3:0] debug_Row;
	wire debug_fPush;
	wire o_fDone;


KeyPad KeyPad(
	i_Clk,
	i_Rst,
	i_Col,
	o_Row,
	o_Num,
	o_fDone
	);


always begin
	#10 i_Clk = ~i_Clk;
end

initial 
begin
	i_Clk = 0; i_Rst = 0; i_Col = 4'b1111;
	@(negedge i_Clk) i_Rst = 1;
	#10 i_Col = 4'b0111;
	#30000000 i_Col = 4'b1111;
	#30000100 i_Col = 4'b1101;
	#60000000 i_Col = 4'b1111;
end
endmodule