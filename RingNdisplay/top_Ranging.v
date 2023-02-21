module top_Ranging(
input	CLK_50M,
input RST,

input wire Echo,
output Trig,

output [6:0] seg_duan,
output [6:0] seg_duan1,
output [6:0] seg_duan2,
output [6:0] seg_duan3,
output [2:0] seg_sel,
output wire [15:0] o_data_o
);

wire  [15:0] data;

assign o_data_o = data;


measurement U1(
		.CLK_50M(CLK_50M),
		.RST (RST),
		.Echo (Echo),
		.Trig (Trig) ,
		.data(data)
);

display U2(
		.CLK_50M	(CLK_50M),
		.RST 		(RST),
		.data(data),
		.seg_duan (seg_duan),
		.seg_duan1 (seg_duan1),
		.seg_duan2 (seg_duan2),
		.seg_duan3 (seg_duan3),
		.seg_sel (seg_sel)
		
);

endmodule


