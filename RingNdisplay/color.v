module color(
	input Clk,
	input blank,
	input [1:0] signal,
	output [7:0] o_red,
	output [7:0] o_green,
	output [7:0] o_blue
	);

// parameters
	parameter RED = 2'b00;
	parameter YELLOW = 2'b01;
	parameter GREEN = 2'b10;

// regs
	reg [7:0] r_red;
	reg [7:0] r_green;
	reg [7:0] r_blue;
// nets
	assign o_red = r_red;
	assign o_green = r_green;
	assign o_blue = r_blue;


//main
	
	always@* begin
		case(signal)
			RED:  begin // signal, RED out  
				r_red = 8'b11111111;
				r_green = 8'b00000000;
				r_blue = 8'b00000000;
			end

			YELLOW:  begin // signal, Yellow out
				r_red = 8'b11111111;
				r_green = 8'b11111111;
				r_blue = 8'b00000000;
			end
			GREEN:  begin // signal, green out
				r_red = 8'b00000000;
				r_green = 8'b11111111;
				r_blue = 8'b00000000;
			end

			default: begin  // default signal, white out
				r_red = 8'b11111111;
				r_green = 8'b11111111;
				r_blue = 8'b11111111;
			end
		endcase
	end
endmodule
