`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:09:34 08/14/2024 
// Design Name: 
// Module Name:    half_adder_structural 
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
module half_adder_structural(s, c, a, b
    );
input a, b;
output s, c;

xor g1(s, a, b);
and g2(c, a, b);

endmodule
