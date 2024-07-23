`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 06 -- Problem 02 [Test Bench for Bit Serial Adder]
// 		File Summary : Designed a Test Bench for Bit Serial Adder
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)
//////////////////////////////////////////////////////////////////////////////////
// [[ Test Bench for Bit Serial Adder ]]
// -- Module for Test Bench for Bit Serial Adder
// -- It implements the Bit Serial Adder as a Unit Under Test and we test it for different 
// 8-bit inputs.
//////////////////////////////////////////////////////////////////////////////////
module Test_Bench_for_Bit_Serial_Adder;

	// Inputs
	reg clk;
	reg rst;
	reg load;
	reg [7:0] input_A;
	reg [7:0] input_B;

	// Outputs
	wire carry_out;
	wire [7:0] sum;

	// Instantiate the Unit Under Test (UUT)
	Bit_Serial_Adder uut (
		.clk(clk), 
		.rst(rst), 
		.load(load), 
		.carry_out(carry_out), 
		.sum(sum), 
		.input_A(input_A), 
		.input_B(input_B)
	);
	
	// Initialise the clock
	initial
	begin
		clk = 1'b0;
	end
	
	// Toggle the clock every 10 ns
	always 
		#10 clk = ~clk; 
		
	initial begin
		// Initialize Registers
		rst = 1'b0;
		load = 1'b0;
		input_A = 8'b00000000;
		input_B = 8'b00000000;
	
		#10;
		
		// Reset the Machine State
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		load = 1'b1;
		input_A = 8'b00000011;
		input_B = 8'b00000010;
		
		#20;
		
		load = 1'b0;
		
		#20;
		
		#160;
		
		$display("TEST CASE 1: A= %d(%b), B= %d(%b), sum= %d(%b), carry_out= %b", input_A, input_A, input_B, input_B, sum, sum, carry_out);
      
		//**********************************************************************************
		#10;
		
		// Reset the Machine State
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		load = 1'b1;
		input_A = 8'b10000011;
		input_B = 8'b10000010;
		
		#20;
		
		load = 1'b0;
		
		#20;
		
		#160;
		
		$display("TEST CASE 2: A= %d(%b), B= %d(%b), sum= %d(%b), carry_out= %b", input_A, input_A, input_B, input_B, sum, sum, carry_out);
      
		//**********************************************************************************
		#10;
		
		// Reset the Machine State
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		load = 1'b1;
		input_A = 8'b11111011;
		input_B = 8'b10010110;
		
		#20;
		
		load = 1'b0;
		
		#20;
		
		#160;
		
		$display("TEST CASE 3: A= %d(%b), B= %d(%b), sum= %d(%b), carry_out= %b", input_A, input_A, input_B, input_B, sum, sum, carry_out);
      
		//**********************************************************************************
		#10;
		
		// Reset the Machine State
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		load = 1'b1;
		input_A = 8'b00011011;
		input_B = 8'b10100010;
		
		#20;
		
		load = 1'b0;
		
		#20;
		
		#160;
		
		$display("TEST CASE 4: A= %d(%b), B= %d(%b), sum= %d(%b), carry_out= %b", input_A, input_A, input_B, input_B, sum, sum, carry_out);
      
		//**********************************************************************************
		#10;
		
		// Reset the Machine State
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		load = 1'b1;
		input_A = 8'b00000011;
		input_B = 8'b11110010;
		
		#20;
		
		load = 1'b0;
		
		#20;
		
		#160;
		
		$display("TEST CASE 5: A= %d(%b), B= %d(%b), sum= %d(%b), carry_out= %b", input_A, input_A, input_B, input_B, sum, sum, carry_out);
      //**********************************************************************************
		#10;
		
		// Reset the Machine State
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		load = 1'b1;
		input_A = 8'b10111011;
		input_B = 8'b01000010;
		
		#20;
		
		load = 1'b0;
		
		#20;
		
		#160;
		
		$display("TEST CASE 6: A= %d(%b), B= %d(%b), sum= %d(%b), carry_out= %b", input_A, input_A, input_B, input_B, sum, sum, carry_out);
      
		//**********************************************************************************
		#10;
		
		// Reset the Machine State
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		load = 1'b1;
		input_A = 8'b10010011;
		input_B = 8'b11111010;
		
		#20;
		
		load = 1'b0;
		
		#20;
		
		#160;
		
		$display("TEST CASE 7: A= %d(%b), B= %d(%b), sum= %d(%b), carry_out= %b", input_A, input_A, input_B, input_B, sum, sum, carry_out);
      
		//**********************************************************************************
		#10;
		
		// Reset the Machine State
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		load = 1'b1;
		input_A = 8'b10000011;
		input_B = 8'b00000000;
		
		#20;
		
		load = 1'b0;
		
		#20;
		
		#160;
		
		$display("TEST CASE 8: A= %d(%b), B= %d(%b), sum= %d(%b), carry_out= %b", input_A, input_A, input_B, input_B, sum, sum, carry_out);
      
		//**********************************************************************************
		#10;
		
		// Reset the Machine State
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		load = 1'b1;
		input_A = 8'b11111111;
		input_B = 8'b11111111;
		
		#20;
		
		load = 1'b0;
		
		#20;
		
		#160;
		
		$display("TEST CASE 9: A= %d(%b), B= %d(%b), sum= %d(%b), carry_out= %b", input_A, input_A, input_B, input_B, sum, sum, carry_out);
      
		//**********************************************************************************
		#10;
		
		// Reset the Machine State
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		load = 1'b1;
		input_A = 8'b10000011;
		input_B = 8'b10110010;
		
		#20;
		
		load = 1'b0;
		
		#20;
		
		#160;
		
		$display("TEST CASE 10: A= %d(%b), B= %d(%b), sum= %d(%b), carry_out= %b", input_A, input_A, input_B, input_B, sum, sum, carry_out);
      
		$finish;
	end
      
endmodule

