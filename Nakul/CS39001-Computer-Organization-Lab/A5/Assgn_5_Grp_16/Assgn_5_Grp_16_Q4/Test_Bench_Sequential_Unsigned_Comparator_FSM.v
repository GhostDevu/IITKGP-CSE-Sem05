
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 05 -- Sequential Unsigned Comparator FSM Testing
// 		File Summary : Writing test bench for Sequential Unsigned Comparator FSM module
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)

`timescale 1ns / 1ps

module Test_Bench_Sequential_Unsigned_Comparator_FSM ;

    // inputs
    reg [31:0] x1, x2 ;
    reg clk, rst, load, OP ;
    // outputs
    wire [2:0] compare ;

    // Instantiate the Unit Under Test (UUT)
    Sequential_Unsigned_Comparator_FSM uut (x1, x2, clk, rst, load, compare, OP) ;

    initial begin
        // Test Case I : when both the operands are equal
        OP = 0 ;
        clk = 0 ;
        rst = 1 ;   // reset the shift registers and the start state of the FSM
        #20 ;
        rst = 0 ;   // reset state de-activated
        load = 1 ;  // parallel input to be loaded into the shift registers
        x1 = 32'b10110100_00101101_10001100_00111101 ;
        x2 = 32'b10110100_00101101_10001100_00111101 ;
        #20 load = 0 ; // load signal deactivated (shift signal activated) after the inputs are loaded
        #640 OP = 1 ;  // run the machine for 32 clock cycles and then activate OP to flag the end of session 
		#10 $display(" TEST CASE 1 || x1 = %d | x2 = %d | COMPARISON = %b", x1, x2, compare) ;  // display results

        #10 ;
		
        // Test Case II : when the first operand is greater than the second
        OP = 0 ;
        clk = 0 ;
        rst = 1 ;   // reset the shift registers and the start state of the FSM
        #20 ;
        rst = 0 ;   // reset state de-activated
        load = 1 ;  // parallel input to be loaded into the shift registers
        x1 = 32'b10010100_00101101_10001100_00101100 ;
        x2 = 32'b10011110_00101101_10001100_00111101 ;
        #20 load = 0 ; // load signal deactivated (shift signal activated) after the inputs are loaded
        #640 OP = 1 ;  // run the machine for 32 clock cycles and then activate OP to flag the end of session  
        #10 $display(" TEST CASE 2 || x1 = %d | x2 = %d | COMPARISON = %b", x1, x2, compare) ;  // display results
        
        #10 ;
		
        // Test Case III : when the first operand is lesser than the second
        OP = 0 ;
        clk = 0 ;
        rst = 1 ;   // reset the shift registers and the start state of the FSM
        #20 ;
        rst = 0 ;   // reset state de-activated
        load = 1 ;  // parallel input to be loaded into the shift registers
        x1 = 32'b10110100_00101101_11001100_00111101 ;
        x2 = 32'b10110100_00101101_10001100_00111101 ;
        #20 load = 0 ; // load signal deactivated (shift signal activated) after the inputs are loaded
        #640 OP = 1 ;  // run the machine for 32 clock cycles and then activate OP to flag the end of session
		#10 $display(" TEST CASE 3 || x1 = %d | x2 = %d | COMPARISON = %b", x1, x2, compare) ;  // display results

        #10 $finish ;
	end

    always begin
        #10 clk = ~clk ;    // clock time period = 20ns
    end

endmodule