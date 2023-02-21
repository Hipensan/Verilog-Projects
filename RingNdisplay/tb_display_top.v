`timescale 1ns / 1ns
module tb_display_top();
	
	reg Clk;
	reg Rst;
	reg Echo;

	wire hsync;
	wire vsync;
	wire blank;
	wire Red;
	wire Green;
	wire Blue; 

	wire Trig;
	wire seg_duan;
	wire seg_duan1;
	wire seg_duan2;
	wire seg_duan3;
	wire seg_sel;
	wire [7:0] data;
	wire [7:0] Led;

Display_Top Display(Clk, data, o_Clk, hsync, vsync, blank, o_sync,Red, Green, Blue, Led);
top_Ranging Rang(Clk, Rst, Echo, Trig, seg_duan, seg_duan1, seg_duan2, seg_duan3, seg_sel, data);

always
	#20 Clk = ~Clk;

always
	#5_000_000 Echo = ~Echo;  // 5ms

	initial
	begin
		Clk = 0;

		
		Rst = 0;
		Echo = 1;

		@(negedge Clk) Rst = 1;

		
		
	end
	endmodule