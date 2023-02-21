module tb_segment;
	reg [3:0] selector;
	wire [6:0] segment;

	FND U0(selector, segment);


	initial
	begin
		selector = 0;
		#10 selector = 1;
		#10 selector = 2;
		#10 selector = 3;
		#10 selector = 4;
		#10 selector = 5;
		#10 selector = 6;
		#10 selector = 7;
		#10 selector = 8;
		#10 selector = 9;
		#10 selector = 10;
	end
endmodule