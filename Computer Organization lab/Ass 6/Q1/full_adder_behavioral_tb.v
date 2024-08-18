`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:18:32 08/14/2024
// Design Name:   full_adder_behavioral
// Module Name:   C:/Users/Student/Desktop/caua 2024/verilog/verilog/full_adder_behavioral_tb.v
// Project Name:  verilog
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: full_adder_behavioral
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module full_adder_behavioral_tb;

	// Inputs
	reg cin;
	reg a;
	reg b;

	// Outputs
	wire s;
	wire cout;

	// Instantiate the Unit Under Test (UUT)
	full_adder_behavioral uut (
		.s(s), 
		.cout(cout), 
		.cin(cin), 
		.a(a), 
		.b(b)
	);

	initial begin
		// Initialize Inputs
		cin = 1;
		a = 1;
		b = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

