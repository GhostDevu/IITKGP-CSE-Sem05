
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 01 -- Test-benches
// 		File Summary : Test-bench for "RCA_64_bit" module
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)


`timescale 1ns / 1ps

// [[ Part (c) ]] -- Test Bench for 32 bit Ripple Carry Adderr

module Test_Bench_RCA_64_bit;

	// Inputs
	reg [63:0] x;
	reg [63:0] y;
	reg carry_in;

	// Outputs
	wire [63:0] sum;
	wire carry_out;

	// Instantiate the Unit Under Test (UUT)
	RCA_64_bit uut (
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
		x = 420000021;
		y = 500009800;	
		carry_in = 0;
		// sum = 920009821, carry_out = 0
		
		#100;
		
		x = 12500002;
		y = 31030099;
		carry_in = 1;
		// sum = 43530102, carry_out = 0
		
		#100;
		
		x = 14302310;
		y = 220098098;
		carry_in = 0;
		// sum = 234400408, carry_out = 0
		
		#100;
		
		x = 11409567;
		y = 20032123;
		carry_in = 1;
		// sum =  31441691, carry_out = 0
		
		#100;
		
		x = 42967295;
		y = 10055555;
		carry_in = 0;
		// sum = 53022850, carry_out = 0
		
		#100;
		
		x = 42944560;
		y = 1729550;
		carry_in = 0;
		// sum = 44674110, carry_out = 0
		
		#100;

		x = -1; // -1 is used because Xilinx ISim Simulator gives error "Decimal constant 18446744073709551615 is too large, using -1 instead"
		y = 1;
		carry_in = 0;
		// sum = 0, carry_out = 1
		
		#100;
		
		x = -1; // -1 is used because Xilinx ISim Simulator gives error "Decimal constant 18446744073709551615 is too large, using -1 instead"
		y = 1;
		carry_in = 1;
		// sum = 1, carry_out = 1
		
		#100;
		
		// Critical Path
		x = -1; // -1 is used because Xilinx ISim Simulator gives error "Decimal constant 18446744073709551615 is too large, using -1 instead"
		y = -1;
		carry_in = 1;
		// sum = -1 (18446744073709551615), carry_out = 1

		#100;
		$finish;
	end
      
endmodule
