module FND(
	input [3:0] sel,
	output [6:0] out 
	);
//parameter 추가도 가능하긴 함

reg [6:0] signal_out;

assign out = signal_out;

always@*
begin
	case(sel)
		4'h0 : signal_out = 7'b_0000001;
		4'h1 : signal_out = 7'b_1001111;
		4'h2 : signal_out = 7'b_0010010;
		4'h3 : signal_out = 7'b_0000110;
		4'h4 : signal_out = 7'b_1001100;
		4'h5 : signal_out = 7'b_0100100;
		4'h6 : signal_out = 7'b_1100000;
		4'h7 : signal_out = 7'b_0001111;
		4'h8 : signal_out = 7'b_0000000;
		4'h9 : signal_out = 7'b_0001100;
		
		4'hA : signal_out = 7'b_0001000;
		4'hB : signal_out = 7'b_1100000; 
		4'hC : signal_out = 7'b_0110001;
		4'hD : signal_out = 7'b_1000010;
		4'hE : signal_out = 7'b_0110000;
		4'hF : signal_out = 7'b_0111000;
		
		default : signal_out = 7'b_1111110;
		endcase // sel
end
endmodule