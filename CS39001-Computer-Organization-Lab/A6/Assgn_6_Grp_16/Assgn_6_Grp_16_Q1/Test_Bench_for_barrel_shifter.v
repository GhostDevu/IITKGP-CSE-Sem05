`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 06 -- Problem 01 [Test Bench for Bidirectional Barrel Shifter]
// 		File Summary : Designed a Test Bench Bidirectional Barrel Shifter
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)
//////////////////////////////////////////////////////////////////////////////////
// [[ Test Bench for Bidirectional Barrel Shifter ]] 
// -- Module for Test Bench for Bidirectional Barrel Shifter 
// -- It implements the barrel_shifter as a Unit Under Test and we test it for different 
// 8-bit inputs, shift amounts and directions.
//////////////////////////////////////////////////////////////////////////////////
module Test_Bench_for_barrel_shifter;

	// Inputs
	reg [7:0] in;
	reg [2:0] shamt;
	reg dir;

	// Outputs
	wire [7:0] out;

	// Instantiate the Unit Under Test (UUT)
	barrel_shifter uut (
		.in(in), 
		.shamt(shamt), 
		.dir(dir), 
		.out(out)
	);

	initial begin
		$display("Right Shift Test Cases: ");
	
		// Initialize Inputs
		in = 8'b11001100;
		shamt = 3'b000;
		dir = 1'b0;
		
		// Wait for stabilisation of output
		#100;
		
		$display("TEST CASE 1: in = %b, shamt = %d, dir = %b, out = %b", in, shamt, dir, out);
		
		// Initialize Inputs
		in = 8'b11111100;
		shamt = 3'b001;
		dir = 1'b0;
		
		// Wait for stabilisation of output
		#100;
		
		$display("TEST CASE 2: in = %b, shamt = %d, dir = %b, out = %b", in, shamt, dir, out);
		
		// Initialize Inputs
		in = 8'b11011111;
		shamt = 3'b010;
		dir = 1'b0;
		
		// Wait for stabilisation of output
		#100;
		
		$display("TEST CASE 3: in = %b, shamt = %d, dir = %b, out = %b", in, shamt, dir, out);
		
		// Initialize Inputs
		in = 8'b11001100;
		shamt = 3'b011;
		dir = 1'b0;
		
		// Wait for stabilisation of output
		#100;
		
		$display("TEST CASE 4: in = %b, shamt = %d, dir = %b, out = %b", in, shamt, dir, out);
		
		// Initialize Inputs
		in = 8'b10001100;
		shamt = 3'b100;
		dir = 1'b0;
		
		// Wait for stabilisation of output
		#100;
		
		$display("TEST CASE 5: in = %b, shamt = %d, dir = %b, out = %b", in, shamt, dir, out);
		
		// Initialize Inputs
		in = 8'b11101101;
		shamt = 3'b101;
		dir = 1'b0;
		
		// Wait for stabilisation of output
		#100;
		
		$display("TEST CASE 6: in = %b, shamt = %d, dir = %b, out = %b", in, shamt, dir, out);
		
		// Initialize Inputs
		in = 8'b10001101;
		shamt = 3'b110;
		dir = 1'b0;
		
		// Wait for stabilisation of output
		#100;
		
		$display("TEST CASE 7: in = %b, shamt = %d, dir = %b, out = %b", in, shamt, dir, out);
		
		// Initialize Inputs
		in = 8'b11101111;
		shamt = 3'b111;
		dir = 1'b0;
		
		// Wait for stabilisation of output
		#100;
		
		$display("TEST CASE 8: in = %b, shamt = %d, dir = %b, out = %b", in, shamt, dir, out);
		
		//***********************************************************************************
		
		$display("Left Shift Test Cases: ");
	
		// Initialize Inputs
		in = 8'b11011100;
		shamt = 3'b000;
		dir = 1'b1;
		
		// Wait for stabilisation of output
		#100;
		
		$display("TEST CASE 1: in = %b, shamt = %d, dir = %b, out = %b", in, shamt, dir, out);
		
		// Initialize Inputs
		in = 8'b11111100;
		shamt = 3'b001;
		dir = 1'b1;
		
		// Wait for stabilisation of output
		#100;
		
		$display("TEST CASE 2: in = %b, shamt = %d, dir = %b, out = %b", in, shamt, dir, out);
		
		// Initialize Inputs
		in = 8'b11011111;
		shamt = 3'b010;
		dir = 1'b1;
		
		// Wait for stabilisation of output
		#100;
		
		$display("TEST CASE 3: in = %b, shamt = %d, dir = %b, out = %b", in, shamt, dir, out);
		
		// Initialize Inputs
		in = 8'b11001100;
		shamt = 3'b011;
		dir = 1'b1;
		
		// Wait for stabilisation of output
		#100;
		
		$display("TEST CASE 4: in = %b, shamt = %d, dir = %b, out = %b", in, shamt, dir, out);
		
		// Initialize Inputs
		in = 8'b10001101;
		shamt = 3'b100;
		dir = 1'b1;
		
		// Wait for stabilisation of output
		#100;
		
		$display("TEST CASE 5: in = %b, shamt = %d, dir = %b, out = %b", in, shamt, dir, out);
		
		// Initialize Inputs
		in = 8'b11101101;
		shamt = 3'b101;
		dir = 1'b1;
		
		// Wait for stabilisation of output
		#100;
		
		$display("TEST CASE 6: in = %b, shamt = %d, dir = %b, out = %b", in, shamt, dir, out);
		
		// Initialize Inputs
		in = 8'b10001101;
		shamt = 3'b110;
		dir = 1'b1;
		
		// Wait for stabilisation of output
		#100;
		
		$display("TEST CASE 7: in = %b, shamt = %d, dir = %b, out = %b", in, shamt, dir, out);
		
		// Initialize Inputs
		in = 8'b11101111;
		shamt = 3'b111;
		dir = 1'b1;
		
		// Wait for stabilisation of output
		#100;
		
		$display("TEST CASE 8: in = %b, shamt = %d, dir = %b, out = %b", in, shamt, dir, out);

	end
      
endmodule

