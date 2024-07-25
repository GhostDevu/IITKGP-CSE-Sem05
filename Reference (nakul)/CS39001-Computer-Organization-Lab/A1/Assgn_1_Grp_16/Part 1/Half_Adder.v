// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 01 -- Problem 01 [Part A]
// 		File Summary : Designed and implemented the half-adder module
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)


`timescale 1ns / 1ps


// [[ Part (a) ]] -- Module for Half Adder (takes in two input bits "a",
// "b" and produces a sum bit "sum" and a carry bit "carry_out")

module Half_Adder ( a , b , sum , carry_out ) ;
    input a, b ;                // define "a" and "b" as inputs
    output sum, carry_out ;     // define "sum" and "carry_out" as outputs

    xor XOR_GATE (sum, a, b) ;       // introduce a "xor" gate (primitive gate) that gives XOR of two inputs as output -- computes "sum" bit
    and AND_GATE (carry_out, a, b) ; // introduce an "and" gate (primitive gate) that gives AND of two inputs as output -- computes "carry_out" bit
endmodule
