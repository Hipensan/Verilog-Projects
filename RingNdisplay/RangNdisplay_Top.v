
module RangNdisplay_Top(
	input Clk,
	input Rst,
	input Echo,

	output Trig,
	output [6:0] seg_duan,
	output [6:0] seg_duan1,
	output [6:0] seg_duan2,
	output [6:0] seg_duan3,
	output [2:0] seg_sel,

	output o_Clk,
	output wire hsync,
	output wire vsync,
	output wire blank,
	output o_sync,
	output wire [7:0] Red,
	output wire [7:0] Green,
	output wire [7:0] Blue,
	output wire [7:0] o_LED 
	);
	wire [15:0] data;

Display_Top Display(Clk, data, o_Clk, hsync, vsync, blank, o_sync, Red, Green, Blue, o_LED);
top_Ranging Rang(Clk, Rst, Echo, Trig, seg_duan, seg_duan1, seg_duan2, seg_duan3, seg_sel, data);



endmodule