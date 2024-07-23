
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 01 -- Test-benches
// 		File Summary : Test-bench for "CLA_16_bit_with_Rippling_Carry" module
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)


`timescale 1ns / 1ps


// [[ Part (c)(iii) ]] -- Test Bench for 16-Bit Carry LookAhead Adder with RIPPLING carry

module Test_Bench_CLA_16_bit_with_Rippling_Carry;

	// Inputs
	reg [15:0] a;
	reg [15:0] b;
	reg c_in;

	// Outputs
	wire [15:0] s;
	wire c_out;

	// Instantiate the Unit Under Test (UUT)
	CLA_16_bit_with_Rippling_Carry uut (
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
		a = 1060;
		b = 11000;	
		c_in = 0;
		// s = 12060, c_out = 0
		
		#100;
		
		a = 12500;
		b = 3100;
		c_in = 1;
		// s = 15601, c_out = 0
		
		#100;
		
		a = 30143;
		b = 2200;
		c_in = 0;
		// s = 32343, c_out = 0
		
		#100;
		
		a = 1140;
		b = 21000;
		c_in = 1;
		// s = 22141, c_out = 0
		
		#100;
		
		a = 65505;
		b = 31;
		c_in = 0;
		// s = 0, c_out = 1
		
		#100;
		
		a = 32005;
		b = 33533;
		c_in = 0;
		// s = 2, c_out = 0
		
		#100;
		
		// Critical Path
		a = 65535;
		b = 65535;
		c_in = 1;
		// s = 65535, c_out = 1
		
		#100;
		$finish;
	end
      
endmodule

