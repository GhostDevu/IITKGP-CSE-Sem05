
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 01 -- Test-benches
// 		File Summary : Test-bench for "RCA_8_bit" module
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)


`timescale 1ns / 1ps


// [[ Part (c) ]] -- Test Bench for 8 bit Ripple Carry Adder

module Test_Bench_RCA_8_bit;

	// Inputs
	reg [7:0] x;
	reg [7:0] y;
	reg carry_in;

	// Outputs
	wire [7:0] sum;
	wire carry_out;

	// Instantiate the Unit Under Test (UUT)
	RCA_8_bit uut (
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
		x = 50;
		y = 100;
		carry_in = 0;
		// sum = 150, carry_out = 0
		
		#100;
		
		x = 30;
		y = 20;
		carry_in = 0;
		// sum = 50, carry_out = 0
		
		#100;
		
		x = 40;
		y = 100;
		carry_in = 0;
		// sum = 140, carry_out = 0
		
		#100;
		
		x = 250;
		y = 40;
		carry_in = 0;
		// sum = 34, carry_out = 1
		
		#100;
		
		x = 100;
		y = 150;
		carry_in = 1;
		// sum = 251, carry_out = 0
		
		#100;
		
		x = 150;
		y = 103;
		carry_in = 1;
		// sum = 254, carry_out = 0
		
		#100;
		
		// Critical Path
		x = 255; 
		y = 255;
		carry_in = 1;
		// sum = 255, carry_out = 1
		
		#100;
		$finish;
	end
      
endmodule

