`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:13:29 08/13/2024 
// Design Name: 
// Module Name:    full_adder 
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
module full_adder(s, cout, cin, a, b
    );
input cin, a, b;
output s, cout;
wire t1, t2, t3, t4, t5;
xor g1(t1, a, b);
xor g2 (s, t1, cin);
and a1(t2, a, b);
and a2(t3, a, cin);
and a3(t4, b, cin);
or o1(t5, t2, t3);
or o2(cout, t5, t4);

endmodule
