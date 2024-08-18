`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:18:53 08/13/2024
// Design Name:   full_adder
// Module Name:   C:/Users/Student/Desktop/caua 2024/verilog/verilog/full_adder_tb.v
// Project Name:  verilog
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: full_adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module full_adder_tb;
		
	reg a;
	reg b;
	reg cin;
	// Outputs
	wire s, cout;

	// Instantiate the Unit Under Test (UUT)
	full_adder uut (
		.s(s),
		.cout(cout),
		.cin(cin),
		.a(a),
		.b(b)
	);

	initial begin
		// Initialize Inputs
		a = 1;
		b = 0;
		cin = 1;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

