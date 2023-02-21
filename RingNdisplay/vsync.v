module vsync(
	input Clk,
	output vblank,
	output vsync_out
	);


// regs
	reg [9:0] vCounter = 10'b0_000_000_000;
	reg blank;
	reg vsync;


// nets
	assign vblank = blank;
	assign vsync_out = vsync;


// main

// hsync 처럼 vsync에 대해 대입

always@(posedge Clk) begin
	if(vCounter < 525) vCounter = vCounter + 1;
	else vCounter = 0;
end

always@(posedge Clk) begin
	if(vCounter >= 480) blank = 1;
	else blank = 0;
end

always@(posedge Clk) begin
	if(vCounter < 490 || vCounter >= 492)	vsync = 1;
	else vsync = 0;
end
endmodule