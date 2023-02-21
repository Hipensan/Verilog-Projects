/*---------------------------------

	ShiftRows.v

	date : 01/30/23 (mm-dd-yy)
	Author : YH J
-----------------------------------



[	127 95 63 31
	119 87 55 23
	111 79 47 15
	103 71 39 7 ]

-----Shift 진행------

[	127 95 63 31
	87 55 23 119
	47 15 111 79
	7 103 71 39 ]
	↓  ↓  ↓  ↓
   (1)(2)(3)(4)


// 본래 형태 및 왼쪽 Shift 된 형태
// 아래로 내리면서 비트 저장
// Encryption 단계
*/

module ShiftRows(
	input [127:0] 	i_data,
	output reg [127:0] 	o_data
	);



always@* begin
		o_data = {	i_data[	127:120],	i_data[	87:80],		i_data[	47:40],		i_data[7:0],			
					i_data[	95:88], 	i_data[	55:48], 	i_data[	15:8], 		i_data[103:96], 		
					i_data[	63:56], 	i_data[	23:16], 	i_data[	111:104], 	i_data[71:64], 			
					i_data[	31:24],		i_data[	119:112], 	i_data[	79:72], 	i_data[39:32] 			
				};		
end
endmodule

/*

[	127 95 63 31
	119 87 55 23
	111 79 47 15
	103 71 39 7 ]

-----Shift 진행------

[	127 95 63 31
	23 119 87 55
	47 15 111 79
	71 39 7 103  ]
	↓  ↓  ↓  ↓
   (1)(2)(3)(4)

// 오른쪽 Shift 된 형태
// Decryption 단계
*/


module Inv_ShiftRows(
	input [127:0] 	i_data,
	output reg [127:0] 	o_data
	);


always@* 
begin
 		o_data = { 	i_data[	127:120], 	i_data[	23:16], 	i_data[	47:40], 	i_data[71:64],		
					i_data[	95:88], 	i_data[	119:112], 	i_data[	15:8], 		i_data[39:32],		
					i_data[	63:56], 	i_data[	87:80], 	i_data[	111:104], 	i_data[7:0],
					i_data[	31:24], 	i_data[	55:48], 	i_data[	79:72], 	i_data[103:96]};
end
endmodule
