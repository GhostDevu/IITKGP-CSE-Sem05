// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 01 -- Problem 02 [Part C.(iii)]
// 		File Summary : Designed and implemented a 16-Bit carry look-ahead adder with rippling carry
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)


`timescale 1ns / 1ps


// [[ Part C.(iii) ]] -- Module for 16-Bit Carry LookAhead Adder with rippling carry and WITHOUT LookAhead Carry Unit
// (takes in two 16-bit binary strings "a" and "b" and an input-carry bit "c_in" as inputs; 
// and outputs a 16-bit binary string "s" and an output-carry bit "c_out")

// Building a 16-bit Carry LookAhead Adder in a Hierarchial Fashion
// WITHOUT LookAhead Carry Unit, it RIPPLES the carry from one CLA_4_bit_Aug module to another

module CLA_16_bit_with_Rippling_Carry (s , c_out , a , b , c_in ) ;
	input [15:0] a, b ;		// 16-bits Inputs to the Carry LookAhead Adder
	input c_in ;			// input carry bit
	output [15:0] s ;		// 16-bit Sum Output of the Adder
	output c_out ;			// c_out-Carry-out from the addition(In case of overflow)
	
	// P -- Block Propagates, G -- Block Generates from the 4-bit CLA Modules
	// C -- Carry bits RIPPLED from one CLA_4_bit_Aug module to another
	wire [3:0] P, G, C ;	
	 
	assign c_out = C[3] ; // Carry-out from the entire addition

	// Module Instantiations of 4 Carry LookAhead Adders
	CLA_4_bit C0 (.s(s[3:0]), .c_out(C[0]), .a(a[3:0]), .b(b[3:0]), .c_in(c_in)) ;
	CLA_4_bit C1 (.s(s[7:4]), .c_out(C[1]), .a(a[7:4]), .b(b[7:4]), .c_in(C[0])) ;
	CLA_4_bit C2 (.s(s[11:8]), .c_out(C[2]), .a(a[11:8]), .b(b[11:8]), .c_in(C[1])) ;
	CLA_4_bit C3 (.s(s[15:12]), .c_out(C[3]), .a(a[15:12]), .b(b[15:12]), .c_in(C[2])) ;
endmodule
