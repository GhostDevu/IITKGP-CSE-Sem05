// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 01 -- Problem 02 [Part A/B]
// 		File Summary : Designed and implemented an augmented 4-Bit carry look-ahead adder
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)


`timescale 1ns / 1ps


// [[ Part B ]] -- Module for 4-Bit Carry LookAhead Adder (takes in two 4-bit binary strings
// "a" and "b" and an input-carry bit "c_in" as inputs; and outputs an 4-bit binary string 
// "s" and an output-carry bit "c_out")
// Uses additional hardware to generate the carry bits that is why it is called Carry LookAhead Adder

module CLA_4_bit ( s , c_out , a , b , c_in ) ;
	input [3:0] a, b ;			// 4-bit Binary Inputs to the Adder
	input c_in ;				// input carry bit
	output [3:0] s ;			// 4-bit Sum Output of the Adder
	output c_out ;				// c_out -- carry-out from the addition(In case of overflow)
	wire [3:0] P, G ;			// P -- Propagate signals, G -- Generate signals
	wire C1, C2, C3, C4 ;		// LookAhead Carry Bits
	
	// Propagate signals computed using bits of a and b	
	assign P[0] = a[0] ^ b[0] ,	
		   P[1] = a[1] ^ b[1] ,
		   P[2] = a[2] ^ b[2] ,
		   P[3] = a[3] ^ b[3] ;
	
	// Generate signals computed using bits of a and b
	assign G[0] = a[0] & b[0] ,	
		   G[1] = a[1] & b[1] ,
		   G[2] = a[2] & b[2] ,
		   G[3] = a[3] & b[3] ;
	
	assign C1 = G[0] | (P[0] & c_in) ;	// Carry-in for the Second Adder
	assign C2 = G[1] | (P[1] & C1) ;		// Carry-in for the Third Adder
	assign C3 = G[2] | (P[2] & (G[1] | (P[1] & C1))) ;			// Carry-in for the Fourth Adder
	assign C4 = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & C1))))) ;	// Carry-out from the entire addition
	
	assign c_out = C4 ;	// Carry-out from the entire addition
	
	// sum[i] bit is simply (a[i] xor b[i] xor carry_in)
	assign s[0] = P[0] ^ c_in ;	// outputs the 1st least significant bit of "sum" 
	assign s[1] = P[1] ^ C1 ;	// outputs the 2nd least significant bit of "sum"
	assign s[2] = P[2] ^ C2 ;	// outputs the 3rd least significant bit of "sum"
	assign s[3] = P[3] ^ C3 ;	// outputs the 4th least significant(most significant) bit of "sum"
endmodule
