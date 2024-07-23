
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 05 -- Two's Complement Converter FSM
// 		File Summary : Designed and implemented a Two's Complement Converter FSM
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)

`timescale 1ns / 1ps

// [[ Two's Complement Converter FSM ]] -- Module for Two's Complement Converter FSM
// (takes in three 1-bit binary inputs "clk", "rst", and "Input_Bit" as inputs; 
// and outputs one 1-bit binary output "Output_bit")

// The Two's Complement Converter FSM which when supplied with a input bit,
// it returns an output bit based on the current state of the machine and the input bit.
//
// The Two's Complement Converter FSM is implemented as a Mealy Machine.
//
// The Mealy Machine has two states that can be encoded in a single bit.
//
// The Start State is 0.
// There are two accept states 0 and 1.
//
// +--------------------+-----------+-----------------+-------------+
// | Present State (PS) | Input Bit	| Next State (NS) | 	Output Bit |
// +--------------------+-----------+-----------------+-------------+
// |		  0				|		0		|			0			|		0		  |	
// |		  0				|		1		|			1			|		1		  |
// |		  1				|		0		|			1			|		1		  |
// |		  1				|		1		|			1			|		0		  |
// +--------------------+-----------+-----------------+-------------+		
//
// A key thing to note is that there is state transition only when 
// the Present State is 0 and Input bit is 1.
// For the rest any other combination they remain in the same state.

module Twos_Complement_Converter(clk, rst, Input_Bit, Output_Bit);
	input wire clk, rst, Input_Bit;  // Input wires clk, rst and Input_Bit
	output reg Output_Bit;				// Output Bit
	reg PS, NS;								// PS refers to the Present State and NS refers to Next State
		
	// Next State COmbinational Logic of the Mealy Machine
	always @(*)
	begin
		// If the Present State is 0 and Input bit is 1
		// Then there is a state transition from 0 to 1 (So NS = 1)
		if(PS == 1'b0 && Input_Bit == 1'b1)
			begin
				NS = 1'b1;
			end
		// For any other combination of Present State and Input bit
		// Then Next State is same as the Present State
		else
			begin
				NS = PS;
			end
	end
	
	// Sequential Part of the Mealy Machine 
	always @(posedge clk or posedge rst)	// asynchronous reset (posedge rst signal in the sensitivity list)
	begin
		// If the reset bit is set then Present State is set to 0
		if(rst)
			begin
				PS <= 1'b0;
			end
		// Else go to Next State
		else
			begin
				PS <= NS;
			end
	end
	
	// Output Combinational Logic of the Mealy Machine
	// Depends on both the Present State of the Machine and Input Bit
	always @(*)
	begin
		// If the Present State is 0 then Output bit is same as Input bit
		if(PS == 1'b0)
			begin
				Output_Bit = Input_Bit;
			end
		// Else if the Present State is 1 then Output bit is inversion of Input bit
		else
			begin
				Output_Bit = ~Input_Bit;
			end
	end
endmodule
