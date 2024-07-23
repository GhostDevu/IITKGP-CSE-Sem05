
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 05 -- Test Bench for Two's Complement Converter FSM
// 		File Summary : Designed a test-bench for Two's Complement Converter FSM
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)

`timescale 1ns / 1ps

// [[ Test Bench for Two's Complement Converter FSM ]] 
// -- Module for Test Bench for Two's Complement Converter FSM
// -- It implements the Two's Complement Converter FSM as a Unit Under Test 
// and we test it for different inputs and display the input and output together.
// -- Note that we have checked for 8, 16 and 32 bits but the FSM will work for any arbitary number of bits.

module Test_Bench_Twos_Complement_Converter;

	// Inputs
	reg clk;
	reg rst;
	reg Input_Bit;

	// Outputs
	wire Output_Bit;

	// Instantiate the Unit Under Test (UUT)
	Twos_Complement_Converter uut (
		.clk(clk), 
		.rst(rst), 
		.Input_Bit(Input_Bit), 
		.Output_Bit(Output_Bit)
	);
	
	// Input Binary Numbers
	reg[7:0] I8;
	reg[15:0] I16;
	reg[31:0] I32;
	
	// Output Binary Numbers
	reg[7:0] O8;
	reg[15:0] O16;
	reg[31:0] O32;
	
	//iterator i
	integer i;

	// Initialise the clock
	initial
	begin
		clk = 1'b0;
	end
	
	// Toggle the clock every 10 ns
	always 
		#10 clk = ~clk; 

	initial begin
		// 1
		// Reset the state of the machine
		rst = 1'b1;
		
		#10;

		// Initialize Inputs
		rst = 1'b0;
		I8 = 8'b10010011;
		
		Input_Bit = I8[0];
		
		#10;
		
		O8[0] = Output_Bit;

		for(i = 1; i < 8; i = i+1)
		begin
			#10;
			Input_Bit = I8[i];
			#10;
			O8[i] = Output_Bit;
		end
		
		$display("Input = %b, Output = %b", I8, O8);
		
		//****************************************
		// 2
		// Reset the state of the machine
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		I8 = 8'b00110000;
		
		Input_Bit = I8[0];
		
		#10;
		
		O8[0] = Output_Bit;

		for(i = 1; i < 8; i = i+1)
		begin
			#10;
			Input_Bit = I8[i];
			#10;
			O8[i] = Output_Bit;
		end
		
		$display("Input = %b, Output = %b", I8, O8);
		
		//****************************************
		// 3
		// Reset the state of the machine
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		I8 = 8'b11111111;
		
		Input_Bit = I8[0];
		
		#10;
		
		O8[0] = Output_Bit;

		for(i = 1; i < 8; i = i+1)
		begin
			#10;
			Input_Bit = I8[i];
			#10;
			O8[i] = Output_Bit;
		end
		
		$display("Input = %b, Output = %b", I8, O8);
		
		//****************************************
		// 4
		// Reset the state of the machine
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		I8 = 8'b00000000;
		
		Input_Bit = I8[0];
		
		#10;
		
		O8[0] = Output_Bit;

		for(i = 1; i < 8; i = i+1)
		begin
			#10;
			Input_Bit = I8[i];
			#10;
			O8[i] = Output_Bit;
		end
		
		$display("Input = %b, Output = %b", I8, O8);
		
		//****************************************
		// 5
		// Reset the state of the machine
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		I16 = 16'b0110011001100110;
		
		Input_Bit = I16[0];
		
		#10;
		
		O16[0] = Output_Bit;

		for(i = 1; i < 16; i = i+1)
		begin
			#10;
			Input_Bit = I16[i];
			#10;
			O16[i] = Output_Bit;
		end
		
		$display("Input = %b, Output = %b", I16, O16);
		
		//****************************************
		// 6
		// Reset the state of the machine
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		I16 = 16'b0111111011101110;
		
		Input_Bit = I16[0];
		
		#10;
		
		O16[0] = Output_Bit;

		for(i = 1; i < 16; i = i+1)
		begin
			#10;
			Input_Bit = I16[i];
			#10;
			O16[i] = Output_Bit;
		end
		
		$display("Input = %b, Output = %b", I16, O16);

		//****************************************
		// 7
		// Reset the state of the machine
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		I16 = 16'b1111111111111111;
		
		Input_Bit = I16[0];
		
		#10;
		
		O16[0] = Output_Bit;

		for(i = 1; i < 16; i = i+1)
		begin
			#10;
			Input_Bit = I16[i];
			#10;
			O16[i] = Output_Bit;
		end
		
		$display("Input = %b, Output = %b", I16, O16);
		
		//****************************************
		// 8
		// Reset the state of the machine
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		I16 = 16'b0000000011101110;
		
		Input_Bit = I16[0];
		
		#10;
		
		O16[0] = Output_Bit;

		for(i = 1; i < 16; i = i+1)
		begin
			#10;
			Input_Bit = I16[i];
			#10;
			O16[i] = Output_Bit;
		end
		
		$display("Input = %b, Output = %b", I16, O16);
		
		//****************************************
		// 9
		// Reset the state of the machine
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		I32 = 32'b11111111111011100000000010000000;
		
		Input_Bit = I32[0];
		
		#10;
		
		O32[0] = Output_Bit;

		for(i = 1; i < 32; i = i+1)
		begin
			#10;
			Input_Bit = I32[i];
			#10;
			O32[i] = Output_Bit;
		end
		
		$display("Input = %b, Output = %b", I32, O32);
		
		//****************************************
		// 10 
		// Reset the state of the machine
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		I32 = 32'b00000000111011100000111110000000;
		
		Input_Bit = I32[0];
		
		#10;
		
		O32[0] = Output_Bit;

		for(i = 1; i < 32; i = i+1)
		begin
			#10;
			Input_Bit = I32[i];
			#10;
			O32[i] = Output_Bit;
		end
		
		$display("Input = %b, Output = %b", I32, O32);
		
		//****************************************
		// 11
		// Reset the state of the machine
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		I32 = 32'b00001111111111110000000000000000;
		
		Input_Bit = I32[0];
		
		#10;
		
		O32[0] = Output_Bit;

		for(i = 1; i < 32; i = i+1)
		begin
			#10;
			Input_Bit = I32[i];
			#10;
			O32[i] = Output_Bit;
		end
		
		$display("Input = %b, Output = %b", I32, O32);
		
		//****************************************
		// 12
		// Reset the state of the machine
		rst = 1'b1;
		
		#10;
		
		// Initialize Inputs
		rst = 1'b0;
		I32 = 32'b00000000111011100000000010000000;
		
		Input_Bit = I32[0];
		
		#10;
		
		O32[0] = Output_Bit;

		for(i = 1; i < 32; i = i+1)
		begin
			#10;
			Input_Bit = I32[i];
			#10;
			O32[i] = Output_Bit;
		end
		
		$display("Input = %b, Output = %b", I32, O32);
	end
      
endmodule

