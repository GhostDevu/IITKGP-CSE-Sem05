`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:53:06 08/14/2024 
// Design Name: 
// Module Name:    full_adder_16_bit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module full_adder_16_bit(s,  cout, cin, a, b
    );
input [15:0]a;
input [15:0]b;
input cin;
output [15:0]s;
output cout;

wire y;

full_adder_8_bit g1(s[7:0], y, cin, a[7:0], b[7:0]);
full_adder_8_bit g2(s[15:8], cout, y, a[15:8], b[15:8]);

endmodule
