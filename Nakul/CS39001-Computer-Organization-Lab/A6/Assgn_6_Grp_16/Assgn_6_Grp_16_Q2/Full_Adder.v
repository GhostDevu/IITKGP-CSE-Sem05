// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 06 -- Problem 02
// 		File Summary : Designed and implemented the full-adder module
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)


`timescale 1ns / 1ps


// [[ Full Adder ]] -- Module for Full Adder (takes in three input bits "a", "b" and in-addition a
// carry input "carry_in", and produces a sum bit "sum" and a carry bit "carry_out")

module Full_Adder ( a , b , carry_in , sum , carry_out ) ;

    input a, b, carry_in ;      // define "a", "b", "carry_in" as inputs
    output sum, carry_out ;     // define "sum" and "carry_out" as outputs

    wire sum_ha1, carry_out_ha1, carry_out_ha2 ;
    // Declare wire-s to connect the composite primitive gates.
    // "sum_ha1" connects the sum-output-port of HA1 with second-input-port of HA2
    // "carry_out_ha1" connects the carry-output-port of HA1 with an input-port of OR gate
    // "carry_out_ha2" connects the carry-output-port of HA2 with the other input-port of OR gate

    Half_Adder HA1 (a, b, sum_ha1, carry_out_ha1) ;             // introduce a Half_Adder component 
    Half_Adder HA2 (carry_in, sum_ha1, sum, carry_out_ha2) ;    // introduce another Half_Adder component ("sum" bit is associated with the sum-output port of this component)
    or OR_GATE (carry_out, carry_out_ha1, carry_out_ha2) ;      // introduce an "or" gate ("carry_out" bit is associated with the output port of this primitive gate)
endmodule
