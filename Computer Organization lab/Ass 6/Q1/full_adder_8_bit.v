`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:32:05 08/14/2024 
// Design Name: 
// Module Name:    full_adder_8_bit 
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
module full_adder_8_bit(s,  cout, cin, a, b
    );
input [7:0]a;
input [7:0]b;
input cin;
output [7:0]s;
output cout;

wire [6:0]y;

full_adder_behavioral g1(s[0:0],   y[0:0], cin, a[0:0], b[0:0]);
full_adder_behavioral g2(s[1:1],   y[1:1], y[0:0], a[1:1], b[1:1]);
full_adder_behavioral g3(s[2:2],   y[2:2], y[1:1], a[2:2], b[2:2]);
full_adder_behavioral g4(s[3:3],   y[3:3], y[2:2], a[3:3], b[3:3]);
full_adder_behavioral g5(s[4:4],   y[4:4], y[3:3], a[4:4], b[4:4]);
full_adder_behavioral g6(s[5:5],   y[5:5], y[4:4], a[5:5], b[5:5]);
full_adder_behavioral g7(s[6:6],   y[6:6], y[5:5], a[6:6], b[6:6]);
full_adder_behavioral g8(s[7:7],   cout, y[6:6], a[7:7], b[7:7]);

endmodule
