module Display_Top(
	input Clk,
	input [1:0] colorSel,
	
	output o_Clk,
	output wire hsync,
	output wire vsync,
	output wire blank,
	output o_sync,
	output wire [7:0] Red,
	output wire [7:0] Green,
	output wire [7:0] Blue
	);


	reg [1:0] r_signal;

	wire hsync_out;
	wire vsync_out;
	wire hblank;
	wire vblank;
	wire [1:0] color_signal;

	assign hsync = hsync_out;
	assign vsync = vsync_out;
	assign color_signal = r_signal;
	assign blank = ~(hblank || vblank);		// blank 가 1일때 신호 out



	ClkDiv clk25m(Clk, o_Clk);
	hsync hs(o_Clk, hsync_out, hblank, newline_out);
	vsync vs(newline_out, vblank, vsync_out);
	color clr(Clk, blank, color_signal, Red, Green, Blue);

//main
	

		always@* begin

		r_signal = colorSel;
	end		
 
	
endmodule
