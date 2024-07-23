
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 01 -- Test-benches
// 		File Summary : Test-bench for "RCA_32_bit" module
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)


`timescale 1ns / 1ps


// [[ Part (c) ]] -- Test Bench for 32 bit Ripple Carry Adder

module Test_Bench_RCA_32_bit;

	// Inputs
	reg [31:0] x;
	reg [31:0] y;
	reg carry_in;

	// Outputs
	wire [31:0] sum;
	wire carry_out;

	// Instantiate the Unit Under Test (UUT)
	RCA_32_bit uut (
		.x(x), 
		.y(y), 
		.carry_in(carry_in), 
		.sum(sum), 
		.carry_out(carry_out)
	);

	initial begin
		$monitor($time, "		x = %15d, y = %15d, carry_in = %b, sum = %15d, carry_out = %b \n", x, y, carry_in, sum, carry_out);
		
		// Initialize Inputs
		x = 0;
		y = 0;
		carry_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		// Check these in unsigned decimal
		x = 4200000021;
		y = 980000;	
		carry_in = 0;
		// sum = 4200980021, carry_out = 0
		
		#100;
		
		x = 12500002;
		y = 3100030;
		carry_in = 1;
		// sum = 15600032, carry_out = 0
		
		#100;
		
		x = 1430002310;
		y = 22000980;
		carry_in = 0;
		// sum = 1452003290, carry_out = 0
		
		#100;
		
		x = 114009567;
		y = 2000321;
		carry_in = 1;
		// sum = 116009889, carry_out = 0
		
		#100;
		
		x = 4294967295;
		y = 1;
		carry_in = 0;
		// sum = 0, carry_out = 1
		
		#100;
		
		x = 4294000000;
		y = 1967295;
		carry_in = 0;
		// sum = 999999, carry_out = 1
		
		#100;
		
		x = 4294967295;
		y = 4294967295;
		carry_in = 1;
		// sum = 4294967295, carry_out = 1
		
		#100;
		$finish;
	end
      
endmodule
