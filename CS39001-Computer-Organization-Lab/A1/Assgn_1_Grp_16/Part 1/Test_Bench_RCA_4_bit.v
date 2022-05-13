
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 01 -- Test-benches
// 		File Summary : Test-bench for "RCA_4_bit" module
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)


`timescale 1ns / 1ps


// [[ Part (c) ]] -- Test Bench for 4 bit Ripple Carry Adder

module Test_Bench_RCA_4_bit;

	// Inputs
	reg [3:0] x;
	reg [3:0] y;
	reg carry_in;

	// Outputs
	wire [3:0] sum;
	wire carry_out;

	// Instantiate the Unit Under Test (UUT)
	RCA_4_bit uut (
		.x(x), 
		.y(y), 
		.carry_in(carry_in), 
		.sum(sum), 
		.carry_out(carry_out)
	);

	initial begin
		$monitor($time, "		x = %d, y = %d, carry_in = %b, sum = %d, carry_out = %b \n", x, y, carry_in, sum, carry_out);
		
		// Initialize Inputs
		x = 0;
		y = 0;
		carry_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		// Check these in unisigned decimal
		x = 5;
		y = 1;
		carry_in = 0;
		// sum = 6, carry_out = 0
		
		#100;
		
		x = 3;
		y = 2;
		carry_in = 1;
		// sum = 6, carry_out = 0
		
		#100;
		
		x = 11;
		y = 1;
		carry_in = 0;
		// sum = 12, carry_out = 0
		
		#100;
		
		x = 12;
		y = 3;
		carry_in = 0;
		// sum = 15, carry_out = 0
		
		#100;
		
		x = 15;
		y = 1;
		carry_in = 0;
		// sum = 0, carry_out = 1
		
		#100;
		
		x = 11;
		y = 12;
		carry_in = 0;
		// sum = 7, carry_out = 1
		
		#100;
		
		// Critical Path
		x = 15;
		y = 15;
		carry_in = 1;
		// sum = 15, carry_out = 1
		
		#100;
		$finish;
	end
      
endmodule

