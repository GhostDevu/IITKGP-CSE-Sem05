
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 01 -- Test-benches
// 		File Summary : Test-bench for "RCA_16_bit" module
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)


`timescale 1ns / 1ps


// [[ Part (c) ]] -- Test Bench for 16 bit Ripple Carry Adder

module Test_Bench_RCA_16_bit;

	// Inputs
	reg [15:0] x;
	reg [15:0] y;
	reg carry_in;

	// Outputs
	wire [15:0] sum;
	wire carry_out;

	// Instantiate the Unit Under Test (UUT)
	RCA_16_bit uut (
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
		x = 1060;
		y = 11000;	
		carry_in = 0;
		// sum = 12060, carry_out = 0
		
		#100;
		
		x = 12500;
		y = 3100;
		carry_in = 1;
		// sum = 15601, carry_out = 0
		
		#100;
		
		x = 30143;
		y = 2200;
		carry_in = 0;
		// sum = 32343, carry_out = 0
		
		#100;
		
		x = 1140;
		y = 21000;
		carry_in = 1;
		// sum = 22141, carry_out = 0
		
		#100;
		
		x = 65505;
		y = 31;
		carry_in = 0;
		// sum = 0, carry_out = 1
		
		#100;
		
		x = 32005;
		y = 33533;
		carry_in = 0;
		// sum = 2, carry_out = 0
		
		#100;
		
		// Critical Path
		x = 65535;
		y = 65535;
		carry_in = 1;
		// sum = 65535, carry_out = 1
		
		#100;
		$finish;
	end
      
endmodule

