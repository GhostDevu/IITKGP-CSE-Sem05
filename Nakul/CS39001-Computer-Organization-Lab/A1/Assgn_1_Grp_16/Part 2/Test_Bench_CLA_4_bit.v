// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 01 -- Test-benches
// 		File Summary : Test-bench for "CLA_4_bit" module
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)


`timescale 1ns / 1ps


// [[ Part (a) ]] -- Test Bench for 4-Bit Carry LookAhead Adder
// Check the correctness of the 4-bit Carry LookAhead Adder

module Test_Bench_CLA_4_bit;

	// Inputs
	reg [3:0] a;
	reg [3:0] b;
	reg c_in;

	// Outputs
	wire [3:0] s;
	wire c_out;

	// Instantiate the Unit Under Test (UUT)
	CLA_4_bit uut ( 
		.s(s), 
		.c_out(c_out), 
		.a(a), 
		.b(b), 
		.c_in(c_in)
	);

	initial begin
		$monitor($time, "		a = %d, b = %d, c_in = %b, sum = %d, c_out = %b \n", a, b, c_in, s, c_out);
		
		// Initialize Inputs
		a = 0;
		b = 0;
		c_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		// Check these in unisigned decimal
		a = 5;
		b = 1;
		c_in = 0;
		// s = 6, c_out = 0
		
		#100;
		
		a = 3;
		b = 2;
		c_in = 1;
		// s = 6, c_out = 0
		
		#100;
		
		a = 11;
		b = 1;
		c_in = 0;
		// s = 12, c_out = 0
		
		#100;
		
		a = 12;
		b = 3;
		c_in = 0;
		// s = 15, c_out = 0
		
		#100;
		
		a = 15;
		b = 1;
		c_in = 0;
		// s = 0, c_out = 1
		
		#100;
		
		a = 11;
		b = 12;
		c_in = 0;
		// s = 7, c_out = 1
		
		#100;
		
		// Critical Path
		a = 15;
		b = 15;
		c_in = 1;
		// s = 15, c_out = 1
		
		#100;
		$finish;
	end
      
endmodule

