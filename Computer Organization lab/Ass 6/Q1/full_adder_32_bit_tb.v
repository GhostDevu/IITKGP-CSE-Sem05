`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:13:58 08/14/2024
// Design Name:   full_adder_32_bit
// Module Name:   C:/Users/Student/Desktop/caua 2024/verilog/verilog/full_adder_32_bit_tb.v
// Project Name:  verilog
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: full_adder_32_bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module full_adder_32_bit_tb;

	// Inputs
	reg cin;
	reg [31:0] a;
	reg [31:0] b;

	// Outputs
	wire [31:0] s;
	wire cout;

	// Instantiate the Unit Under Test (UUT)
	full_adder_32_bit uut (
		.s(s), 
		.cout(cout), 
		.cin(cin), 
		.a(a), 
		.b(b)
	);

	initial begin
		$monitor($time, "		a = %15d, b = %15d, cin = %b, s = %15d, cout = %b \n", a, b, cin, s, cout);
		
		// Initialize Inputs
		a = 0;
		b = 0;
		cin = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		a = 4200000021;
		b = 980000;	
		cin = 0;
		
		#100;
		
		a = 12500002;
		b = 3100030;
		cin = 1;
		
		#100;
		
		a = 1430002310;
		b = 22000980;
		cin = 0;
		
		#100;
		
		a = 114009567;
		b = 2000321;
		cin = 1;
		
		#100;
		
		a = 4294967295;
		b = 1;
		cin = 0;
		
		#100;
		
		a = 4294000000;
		b = 1967295;
		cin = 0;
		
		#100;
		
		a = 4294967295;
		b = 4294967295;
		cin = 1;
		
		#100;
		$finish;
	end
      
endmodule

