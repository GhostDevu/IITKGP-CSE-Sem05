
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 01 -- Problem 01 [Part C]
// 		File Summary : Designed and implemented a 16-bit ripple carry adder
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)


`timescale 1ns / 1ps


// [[ Part C ]] -- Module for 16-Bit Ripple Carry Adder (takes in two 16-bit binary strings
// "x" and "y" and an input-carry bit "carry_in" as inputs; and outputs a 16-bit binary string 
// "sum" and an output-carry bit "carry_out")

module RCA_16_bit ( x , y , carry_in , sum , carry_out ) ;
    input [15:0] x ;     // define "x" as an input binary vector of width 16
    input [15:0] y ;     // define "y" as an input binary vector of width 16
    input carry_in ;     // define "carry_in" as an input
    output [15:0] sum ;  // define "sum" as an output binary vector of width 16
    output carry_out ;   // define "carry_out" as an output

    wire first_rca_carry_out ;
    // declare a wire that connects the output-carry-port of first ripple carry adder
    // with the input-carry-port of the second ripple carry adder

    // Design Description -- Cascade 2 8-Bit Ripple Carry Adder components
    // such that carry-out of one is the carry-in of the other.
    // The 8 least significant bits of x and y are the input binary strings for the first ripple carry adder.
    // The 8 most significant bits of x and y are the input binary strings for the second ripple carry adder.

    RCA_8_bit RCA_8Bit_1 (x[7:0], y[7:0], carry_in, sum[7:0], first_rca_carry_out) ;          // first 8-bit ripple carry adder -- outputs the 8 least significant bits in "sum"
    RCA_8_bit RCA_8Bit_2 (x[15:8], y[15:8], first_rca_carry_out, sum[15:8], carry_out) ;      // second 8-bit ripple carry adder -- outputs the 8 most significant bits in "sum"
                                                                                                            //                              and also the carry_out bit
endmodule
