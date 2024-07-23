
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 05 -- Test Bench for Linear Feedback Shift Register
// 		File Summary : Designed a Test Bench Linear Feedback Shift Register(LFSR)
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)

`timescale 1ns / 1ps

// [[ Test Bench for Linear Feedback Shift Register ]] 
// -- Module for Test Bench for Linear Feedback Shift Register 
// -- It implements the LFSR as a Unit Under Test and we test it for different seeds
// and monitor the state of the machine for 15 clock cycles.
// -- We observe that when initialized with a non-zero seed the LFSR cycles 
// through all the 15 non-zero binary combinations through its state transitions, 
// before returning to the initial vector(the seed).

module Test_Bench_LFSR;

	// Inputs
	reg clk;
	reg rst;
	reg sel;
	reg [3:0] seed;

	// Outputs
	wire [3:0] state;

	// Instantiate the Unit Under Test (UUT)
	LFSR uut (
		.clk(clk), 
		.rst(rst), 
		.sel(sel), 
		.seed(seed), 
		.state(state)
	);
	
	// Initialise the clock
	initial
	begin
		clk = 1'b0;
	end
	
	// Toggle the clock every 10 ns
	always 
		#10 clk = ~clk; 

	initial
	begin
		// Initialize Inputs
		rst = 1'b0;
		sel = 1'b0;
		seed = 4'b1111;
		
		// Wait for stabilisation of the state
		#10;
		
		// Start the Linear Feedback Shift Register
		sel = 1'b1;
		
		$monitor("Clock = %b, State = %b", clk, state);
		
		// Monitor the state until atleast 15 cycles complete then finish
		#320;
		
		//************************************************
		$display("*****************************");
		
		// Reset the state of the machine
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		sel = 1'b0;
		seed = 4'b1001;
		
		// Wait for stabilisation of the state
		#10;
		
		// Start the Linear Feedback Shift Register
		sel = 1'b1;
		
		$monitor("Clock = %b, State = %b", clk, state);
		
		// Monitor the state until atleast 15 cycles complete then finish
		#320;
		
		//************************************************
		$display("*****************************");
		
		// Reset the state of the machine
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		sel = 1'b0;
		seed = 4'b0001;
		
		// Wait for stabilisation of the state
		#10;
		
		// Start the Linear Feedback Shift Register
		sel = 1'b1;
		
		$monitor("Clock = %b, State = %b", clk, state);
		
		// Monitor the state until atleast 15 cycles complete then finish
		#320;
		
		//************************************************
		$display("*****************************");
		
		// Reset the state of the machine
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		sel = 1'b0;
		seed = 4'b1101;
		
		// Wait for stabilisation of the state
		#10;
		
		// Start the Linear Feedback Shift Register
		sel = 1'b1;
		
		$monitor("Clock = %b, State = %b", clk, state);
		
		// Monitor the state until atleast 15 cycles complete then finish
		#320 $finish;
	end
endmodule

