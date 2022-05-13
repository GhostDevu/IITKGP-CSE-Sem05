
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 01 -- Test-benches
// 		File Summary : Test-bench for "Half_Adder" module
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)


`timescale 1ns / 1ps


// [[ Part (a) ]] -- Test Bench for Half Adder

module Test_Bench_Half_Adder;

	// Inputs
	reg a;
	reg b;

	// Outputs
	wire sum;
	wire carry_out;

	// Instantiate the Unit Under Test (UUT)
	Half_Adder uut (
		.a(a), 
		.b(b), 
		.sum(sum), 
		.carry_out(carry_out)
	);

	initial begin
		$monitor($time, "		a = %b, b = %b, sum = %b, carry_out = %b \n", a, b, sum, carry_out);
		
		// Initialize Inputs
		a = 0;
		b = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		a = 0;
		b = 1;
		// sum = 1, carry_out = 0
		
		#100;
		
		a = 1;
		b = 0;
		// sum = 1, carry_out = 0
		
		#100;

		// Critical Path
		a = 1;
		b = 1;
		// sum = 1, carry_out = 1
		
		#100;
		$finish;
	end
      
endmodule

