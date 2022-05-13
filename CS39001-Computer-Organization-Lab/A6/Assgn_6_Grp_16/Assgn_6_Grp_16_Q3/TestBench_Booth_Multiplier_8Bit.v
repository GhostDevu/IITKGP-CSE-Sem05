
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 06 -- Problem 03 [Sequential Signed Binary Multiplier (Booth Multiplier)]
// 		File Summary : Implemented test-cases for Booth's multiplier in a test-bench
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)

`timescale 1ns / 1ps

module TestBench_Booth_Multiplier_8Bit ;

    // inputs
    reg clk, rst, load ;
    reg signed [7:0] op1 ;
    reg signed [7:0] op2 ;

    // outputs
    wire signed [15:0] prod ;

    // Instantiate the Unit Under Test (UUT)
    Booth_Multiplier_8Bit UUT (op1, op2, clk, rst, load, prod) ;

    initial begin
        // Test Case 1 : when both multiplicand & multiplier are positive
        clk = 1'b0 ;
        rst = 1'b1 ;    // reset signal activated (to reset all outputs)
        #20 op1 = 8'b0101_0010 ; op2 = 8'b0001_1101 ;   // test case arguements
        rst = 1'b0 ; load = 1'b1 ;  // reset signal de-activated; load signal activated to load the operands and initialize the variables
        #20 load = 1'b0 ;   // load signal de-activated
        #160 ; $display(" TEST CASE 1 | Multiplicand = %d | Multiplier = %d | Product = %d | Product (binary) = %b %b ", op1, op2, prod, prod[15:8], prod[7:0]) ; 

        #20 ;

        // Test Case 2 : when multiplicand is positive bit multiplier is negative
        clk = 1'b0 ;
        rst = 1'b1 ;    // reset signal activated (to reset all outputs)
        #20 op1 = 8'b0111_0001 ; op2 = 8'b1011_0010 ;   // test case arguements
        rst = 1'b0 ; load = 1'b1 ;  // reset signal de-activated; load signal activated to load the operands and initialize the variables
        #20 load = 1'b0 ;   // load signal de-activated
        #160 ; $display(" TEST CASE 2 | Multiplicand = %d | Multiplier = %d | Product = %d | Product (binary) = %b %b ", op1, op2, prod, prod[15:8], prod[7:0]) ; 

        #20 ;

        // Test Case 3 : when multiplicand is negative bit multiplier is positive
        clk = 1'b0 ;
        rst = 1'b1 ;    // reset signal activated (to reset all outputs)
        #20 op1 = 8'b1101_0000 ; op2 = 8'b0000_1010 ;   // test case arguements
        rst = 1'b0 ; load = 1'b1 ;  // reset signal de-activated; load signal activated to load the operands and initialize the variables
        #20 load = 1'b0 ;   // load signal de-activated
        #160 ; $display(" TEST CASE 3 | Multiplicand = %d | Multiplier = %d | Product = %d | Product (binary) = %b %b ", op1, op2, prod, prod[15:8], prod[7:0]) ; 

        #20 ;

        // Test Case 4 : when both multiplicand & multiplier are negative
        clk = 1'b0 ;
        rst = 1'b1 ;    // reset signal activated (to reset all outputs)
        #20 op1 = 8'b1001_0111 ; op2 = 8'b1000_0010 ;   // test case arguements
        rst = 1'b0 ; load = 1'b1 ;  // reset signal de-activated; load signal activated to load the operands and initialize the variables
        #20 load = 1'b0 ;   // load signal de-activated
        #160 ; $display(" TEST CASE 4 | Multiplicand = %d | Multiplier = %d | Product = %d | Product (binary) = %b %b ", op1, op2, prod, prod[15:8], prod[7:0]) ; 

        $finish ;
    end 

    always 
		#10 clk = ~clk;     // clock time period = 20ns

endmodule
