
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 05 -- Linear Feedback Shift Register
// 		File Summary : Designed and implemented a Linear Feedback Shift Register(LFSR)
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)

`timescale 1ns / 1ps

// [[ Linear Feedback Shift Register ]] -- Module for Linear Feedback Shift Register 
// (takes in three 1-bit binary inputs "clk", "rst", and "sel" and 
// one 4-bit binary input "seed" as inputs; 
// and outputs one 4-bit binary output "state")

// The Linear Feedback Shift Register which when loaded by an initial non-zero vector called seed, 
// cycles through all the 15 non-zero binary combinations through its state transitions, 
// before returning to the initial vector(the seed).
// The LFSR outputs the bits used to encode the current state of the machine.
// 
// 1111  0111  0011  0001  1000  0100  0010  1001  1100  0110  1011  0101  1010  1101  1110  1111
//
// The LFSR can be reset to all zeroes asynchronously using the reset bit(rst).

module LFSR(clk, rst, sel, seed, state);
	input wire clk, rst, sel; 			// Input wires clk, rst and sel
	input[3:0] seed;						// 4-bit input - parallel load of seed 
	
	// Interconnecting wires in the netlist
	wire w1int, w2int, w3int, w4int;
	wire w1, w2, w3, w4, w5;
	
	// 4-bit output - Returns the current state of the machine
	output [3:0] state;
	
	// Next State Combinational Logic of the Moore Machine
	Mux2to1 M3(.Output(w1int), .Sel(sel), .Input_0(seed[3]), .Input_1(w1)); // w1int = (sel and w1) or (~sel and seed[3])
	Mux2to1 M2(.Output(w2int), .Sel(sel), .Input_0(seed[2]), .Input_1(w2)); // w2int = (sel and w2) or (~sel and seed[2])
	Mux2to1 M1(.Output(w3int), .Sel(sel), .Input_0(seed[1]), .Input_1(w3)); // w3int = (sel and w3) or (~sel and seed[1])
	Mux2to1 M0(.Output(w4int), .Sel(sel), .Input_0(seed[0]), .Input_1(w4)); // w4int = (sel and w4) or (~sel and seed[0])
	xor XG(w1, w4, w5);	// w1 = w4 xor w5
	
	// Sequential Part of the Moore Machine 
	// Four D Flip Flops which store the current state of the machine
	D_Flip_Flop D3(.clk(clk), .rst(rst), .D(w1int), .Q(w2)); // D = w1int, w2 = Q
	D_Flip_Flop D2(.clk(clk), .rst(rst), .D(w2int), .Q(w3)); // D = w2int, w3 = Q
	D_Flip_Flop D1(.clk(clk), .rst(rst), .D(w3int), .Q(w4)); // D = w3int, w4 = Q
	D_Flip_Flop D0(.clk(clk), .rst(rst), .D(w4int), .Q(w5)); // D = w4int, w5 = Q
	
	// Output Combinational Logic of the Moore Machine
	// Depends only on the Present State of the Machine
	// The current state of the machine is given by the output of the D Flip Flops 
	assign state[3] = w2;
	assign state[2] = w3;
	assign state[1] = w4;
	assign state[0] = w5;
endmodule
