`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:40:18 08/14/2024
// Design Name:   full_adder_8_bit
// Module Name:   C:/Users/Student/Desktop/caua 2024/verilog/verilog/full_adder_8_bit_tb.v
// Project Name:  verilog
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: full_adder_8_bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module full_adder_8_bit_tb;
	reg [7:0]a;
	reg [7:0]b;
	reg cin;
	// Outputs
	wire cout; 
	wire [7:0]s;

	// Instantiate the Unit Under Test (UUT)
	full_adder_8_bit uut (
		.s(s),
		.cout(cout),
		.cin(cin),
		.a(a),
		.b(b)
	);

	initial begin
		// Initialize Inputs
		$monitor($time, "  a=%d, b=%d, cin=%d, sum=%d, cout=%d", a, b, cin, s, cout);
		a=0;
		b=0;
		cin=0;
		#100;
        
		a=200;
		b=3;
		cin=1;
		#100;
		
		a=39;
		b=30;
		cin=0;
		#100;
		
		a=10;
		b=32;
		cin=1;
		#100;
	end
      
endmodule

