`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:56:50 08/14/2024 
// Design Name: 
// Module Name:    full_adder_32_bit 
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
module full_adder_32_bit(s,  cout, cin, a, b
    );
input [31:0]a;
input [31:0]b;
input cin;
output [31:0]s;
output cout;

wire y;

full_adder_16_bit g1(s[15:0], y, cin, a[15:0], b[15:0]);
full_adder_16_bit g2(s[31:16], cout, y, a[31:16], b[31:16]);

endmodule
