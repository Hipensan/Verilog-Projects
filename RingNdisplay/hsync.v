module hsync(
	input Clk,
	output hsync_out,
	output hblank,
	output newline_out
	);

// params
// no Parameters

// regs
	reg hsync;
	reg blank;
	reg newline;
	reg [9:0] hCounter = 10'b_0_000_000_000;

// nets
	assign hsync_out = hsync;
	assign hblank = blank;
	assign newline_out = newline;
	


// main

// hsync = 1, 0~639 픽셀 visible area
// hsync = 1, 640 ~ 655 픽셀 front proch
// hsync = 0, 656 ~ 751 픽셀 sync pulse
// hsync = 1, 752 ~ 799 픽셀 back porch

// newline 정의, hCounter == 0 도달한 경우 newline = 1, 새로운 라인 start


always@(posedge Clk) begin
	if(hCounter < 800) hCounter = hCounter + 1;
	else	hCounter = 0;
end

always@(posedge Clk) begin
	if(hCounter >= 640)  blank = 1;
	else blank = 0;
end

always@(posedge Clk) begin 
	if(hCounter == 0)  newline = 1;
	else newline = 0;	
end

always@(posedge Clk) begin
	if(hCounter < 656 || hCounter >= 752) 	hsync = 1;
	else hsync = 0;
end

endmodule