
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 01 -- Test-benches
// 		File Summary : Test-bench for "LookAhead_Carry_Unit" module
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)


`timescale 1ns / 1ps


// [[ Part (c)(ii) ]] -- Test Bench for LookAhead Carry Unit Module

module Test_Bench_LookAhead_Carry_Unit;

	// Inputs
	reg [3:0] P;
	reg [3:0] G;
	reg c_in;

	// Outputs
	wire [3:0] C;
	wire BP, BG ;

	// Instantiate the Unit Under Test (UUT)
	LookAhead_Carry_Unit uut (
		.C(C), 
		.BP(BP),
		.BG(BG),
		.P(P), 
		.G(G), 
		.c_in(c_in)
	);

	initial begin
		$monitor($time, "		P = %b, G = %b, c_in = %b, C = %b, BP = %b, BG = %b \n", P, G, c_in, C, BP, BG);
		
		// Initialize Inputs
		P = 0;
		G = 0;
		c_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		P = 4'b0000;
		G = 4'b0000;
		c_in = 0;
		// C = 4'b0000, BP = 0, BG = 0 
		
		#100;
		
		P = 4'b0010;
		G = 4'b0100;
		c_in = 0;
		// C = 4'b0100, BP = 0, BG = 0 
		
		#100;
		
		P = 4'b1010;
		G = 4'b0011;
		c_in = 0;
		// C = 4'b0011, BP = 0, BG = 1 
		
		#100;
		
		P = 4'b0100;
		G = 4'b1001;
		c_in = 0;
		// C = 4'b1001, BP = 0, BG = 1 
		
		#100;
		
		P = 4'b0101;
		G = 4'b1010;
		c_in = 0;
		// C = 4'b1110, BP = 0, BG = 1 
		
		#100;
		
		P = 4'b1001;
		G = 4'b0110;
		c_in = 0;
		// C = 4'b1110, BP = 0, BG = 1
		
		#100;
		
		P = 4'b0000;
		G = 4'b1111;
		c_in = 0;
		// C = 4'b1111, BP = 0, BG = 1 
		
		#100;
		
		// Critical Path
		P = 4'b1111;
		G = 4'b1111;
		c_in = 1;
		// C = 4'b1111, BP = 1, BG = 1 
		
		#100;
		$finish;
	end
      
endmodule
