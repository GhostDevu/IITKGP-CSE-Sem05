
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 06 -- Problem 03 [Sequential Signed Binary Multiplier (Booth Multiplier)]
// 		File Summary : Designed and implemented a Booth's multiplication circuit
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)

`timescale 1ns / 1ps

// +++ Sequential Signed Binary Multiplier -- Booth's Multiplication +++
// -- Input Ports
//		-> op1 - 8-bit signed multiplicand (first operand)
//		-> op2 - 8-bit signed multiplier (second operand)
//		-> clk - clock to synchronize the iterations in the Booth's multiplication algorithm
//		-> rst - reset (synchronous) signal to reset all the output bits
//		-> load - load (synchronous) signal to enable parallel load facility of the operands

//	-- Output Ports
//		-> prod - 16-bit signed product of multiplicand and multiplier

module Booth_Multiplier_8Bit ( op1 , op2 , clk , rst , load , prod ) ;

    input clk, rst, load ;	// define clk, rst, load as inputs
    input signed [7:0] op1 ;	// op1 (input) - 8-bit signed multiplicand
    input signed [7:0] op2 ;	// op2 (input) - 8-bit signed multiplier
    output reg signed [15:0] prod ; // prod (output) - 16-bit signed product

    reg shift_out ; // bit shifted out in "arithmetic right shift" operation
    reg signed [7:0] multiplicand ; // 8-bit signed reg that stores the parallel load multiplicand
    
    // Note that an 8-bit signed reg for parallel load multiplier is redundant because multiplier is used only in
    // the initialization step of the Booth's algorithm. So it need not be remembered for the further iterations.

    always @ ( posedge clk ) begin  // "always" block starts
                                    // sensitivity list -- posedge clk (positive-edge triggered)
        if ( load ) begin   // [LOAD OP] check for parallel load (parallel load at the highest precedence)
                            // Also perform the "initialization step" of Booth's algorithm
            multiplicand = op1 ;   // "load" first operand into multiplicand register
            prod = {8'b0, op2} ;   // "initialize" prod to multipler (second operand) with most significant 8-bits set to 0
            shift_out = 1'b0 ;     // "initialize" shifted out bit to 0
        end

        else if ( rst ) begin   // [RESET OP] check for reset
            prod = 16'b0 ;     // reset prod output to 0
            multiplicand = 8'b0 ;  // reset multiplicand register to 0
        end

        else begin  // Implement Booth's Multiplication Algorithm
            case ({prod[0], shift_out}) // {prod[0], shift_out} stands for concatenation of least significant bit of prod and shift_out
                2'b10 : prod = prod - {multiplicand, 8'b0} ;   // prod[LEFT_HALF] <- prod[LEFT_HALF] - Mcand
                2'b01 : prod = prod + {multiplicand, 8'b0} ;   // prod[LEFT_HALF] <- prod[LEFT_HALF] + Mcand
                default : ; // do nothing in case of 00 and 11
            endcase

            // arithmetic right shift operation (happens in every iteration)
            shift_out = prod[0] ;  // least significant bit stored in the register is assigned to "shift_out" (serial output)
            prod = prod >>> 1 ;    // the bits stored in the register are shifted towards right while retaining the sign (arithmetic right shift)
        end
    end     // "always" block ends

endmodule
