`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:17:12 08/14/2024
// Design Name:   full_adder_64_bit
// Module Name:   C:/Users/Student/Desktop/caua 2024/verilog/verilog/full_adder_64_bit_tb.v
// Project Name:  verilog
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: full_adder_64_bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module full_adder_64_bit_tb;

	// Inputs
	reg cin;
	reg [63:0] a;
	reg [63:0] b;

	// Outputs
	wire [63:0] s;
	wire cout;

	// Instantiate the Unit Under Test (UUT)
	full_adder_64_bit uut (
		.s(s), 
		.cout(cout), 
		.cin(cin), 
		.a(a), 
		.b(b)
	);

	initial begin
		// Initialize Inputs
		$monitor($time, "		a = %15d, b = %15d, cin = %b, s = %15d, cout = %b \n", a, b, cin, s, cout);
		
		// Initialize Inputs
		a = 0;
		b = 0;
		cin = 0;

		#100;
        
		a = 420000021;
		b = 500009800;	
		cin = 0;
		
		#100;
		
		a = 12500002;
		b = 31030099;
		cin = 1;
		
		#100;
		
		a = 14302310;
		b = 220098098;
		cin = 0;
		
		#100;
		
		a = 11409567;
		b = 20032123;
		cin = 1;
		
		#100;
		
		a = 42967295;
		b = 10055555;
		cin = 0;
		
		#100;
		
		a = 42944560;
		b = 1729550;
		cin = 0;

		#100;
		$finish;
	end
      
endmodule

