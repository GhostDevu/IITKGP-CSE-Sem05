`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:10:53 08/14/2024 
// Design Name: 
// Module Name:    full_adder_behavioral 
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
module full_adder_behavioral(s, cout, cin, a, b
    );
input cin, a, b;
output s, cout;
assign s = a^b^cin;
assign cout = a&b | b&cin | cin&a;

endmodule
