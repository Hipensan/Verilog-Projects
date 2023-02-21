module Hexkeypad(
	input Clk,
	input Rst,
	input [3:0] read,
	output reg [3:0] scan,
	output reg [6:0] display,
	output [9:0] o_LED
	);

parameter LST_CLK = 1_000_000 / 20 - 1; // 0.02s

reg [19:0] count;
reg [1:0] state;


assign o_LED = {read, scan, state};


always@(posedge Clk)
begin
	count = count + 1;
	state = (count == LST_CLK) ? state + 1 : state;
end

always@(state)
begin
	case(state)
		2'b00: scan = 4'b1110;
		2'b01: scan = 4'b1101;
		2'b10: scan = 4'b1011;
		default: scan = 4'b0111;
	endcase // state
end


always@(scan, read)
begin
	case(scan)
		4'b1110:
			case(read)
				4'b0111: display = 7'b_0000001; //0
				4'b1011: display = 7'b_1001100; //4
				4'b1101: display = 7'b_0000000; //8
				4'b1110: display = 7'b_0110001; //c
				default: display = 7'b1111111;
			endcase
		4'b1101:
			case(read)
				4'b0111: display = 7'b_1001111; //1
				4'b1011: display = 7'b_0100100; //5
				4'b1101: display = 7'b_0000100; //9
				4'b1110: display = 7'b_1000010; //d
				default: display = 7'b1111111;
			endcase
		4'b1011:
			case(read)
				4'b0111: display = 7'b_0010010; //2
				4'b1011: display = 7'b_0100000; //6
				4'b1101: display = 7'b_0001000; //a
				4'b1110: display = 7'b_0110000; //e
				default: display = 7'b1111111;
			endcase
		4'b0111:
			case(read)
				4'b0111: display = 7'b_0000110; //3
				4'b1011: display = 7'b_0001111; //7
				4'b1101: display = 7'b_1100000; //b
				4'b1110: display = 7'b_0111000; //f
				default: display = 7'b1111111;
			endcase
		default: display = 7'b1111111;

	endcase
	end

endmodule