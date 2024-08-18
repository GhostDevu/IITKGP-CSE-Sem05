`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:39 08/14/2024 
// Design Name: 
// Module Name:    full_adder_64_bit 
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
module full_adder_64_bit(s,  cout, cin, a, b
    );
input [63:0]a;
input [63:0]b;
input cin;
output [63:0]s;
output cout;

wire y;

full_adder_32_bit g1(s[31:0], y, cin, a[31:0], b[31:0]);
full_adder_32_bit g2(s[63:32], cout, y, a[63:32], b[63:32]);

endmodule
