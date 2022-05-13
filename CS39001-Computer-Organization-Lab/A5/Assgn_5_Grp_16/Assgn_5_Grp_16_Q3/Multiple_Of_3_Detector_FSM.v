
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 05 -- Multiple of 3 Detector FSM
// 		File Summary : Design & implementation of an FSM that detects if the  
//					   input binary string of arbitrary length is divisible by 3 or not
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)

`timescale 1ns / 1ps

// +++ FINITE STATE MACHINE DESIGN +++
//
// +++ Machine Type +++
// The FSM designed in this problem is a Mealy machine, in which the output depends both on the present state and the input.
// 
// +++ States & State Encoding +++
//	The FSM will have 3 states by the following names.
//		-> R0 -- [MEANING - the decimal no. for the binary string scanned till now is of the form 3k]
//		-> R1 -- [MEANING - the decimal no. for the binary string scanned till now is of the form 3k+1]
//		-> R2 -- [MEANING - the decimal no. for the binary string scanned till now is of the form 3k+2]
//	Since there are 3 states, 2 bits are required to represent them. The state encoding chosen is as follows.
//		-> 00 represents R0
//		-> 01 represents R1
//		-> 10 represents R2
//		-> 11 (meaningless)
//
// +++ State Transition Table +++
/*	PS : present state
	NS : next state
	O : output bit
	i : input bit
	+---------+---------------------------+
	|   PS    |		     NS / O	           |	  
	+---------+-------------+-------------+
	|		    |    i = 0    |    i = 1    |
	+---------+-------------+-------------+
	| R0 (00) | R0 (00) / 0 | R1 (01) / 1 |
	| R1 (01) | R2 (10) / 1 | R0 (00) / 0 |
	| R2 (10) | R1 (01) / 1 | R2 (10) / 1 |
	+---------+-------------+-------------+
	* The "Next State Function" and "Output Function" are clear from the state transition table.
*/
// +++ FEATURES +++
//  -- Positive-Edge Triggered : Acceptance of input bit and resultant state transition can only occur at positive edge of the clock.
//  -- Asynchronous Reset : a reset signal initializes/sets the state of the FSM to R0 (00) and output of the FSM to 0;
//                          it works independent of the clock signal.

// +++ INPUT PORTS +++
//  clk - clock with which the state transitions of FSM are synchronized
//  rst - reset signal to initialize the state of FSM to R0
//  x - next serial bit of the binary arguement from the MSB side 

// +++ OUTPUT PORTS +++
//  out - Mealy output bit as a result state transition;
//        out = 1 -> the decimal no. for the binary string scanned till now is divisible by 3
//        out = 0 -> the decimal no. for the binary string scanned till now is NOT divisible by 3

// * NBA = Non Blocking Assignment *
module Multiple_Of_3_Detector_FSM ( clk , rst , x , out ) ;

    input clk, rst, x ; // define clk, rst, x as inputs
    output reg out ;    // define "out" as a reg output
						// (reg because it is on the LHS of an instruction in "always" block) 

    reg [1:0] PS ;  // PS : present state of the FSM (defined as a 2-bit wide reg)
					// (reg because it is on the LHS of an instruction in "always" block)

    always @ ( posedge clk or posedge rst ) begin   // "always" block begins [for state transition]
													// sensitivity list -- posedge clk (positive-edge triggered FSM)
													//					   posedge rst (asynchronous reset facility)
        if ( rst ) begin    // [RESET OP] check for reset
            PS <= 2'b00 ;   // if "rst" signal is active, set present state ("PS") to 00 (NBA)
            out <= 1'b0 ;   // and "out" to 0 (NBA)
        end
        
        else begin  // [STATE TRANSITION ROUTINE]
					// 	(* refer to state transition table to implement this routine *)
					// 	(all assignments are NBA)
            case ( PS )
                2'b00: begin    // when PS = R0
                    if ( x ) begin  // -> and i = 1
                        PS <= 2'b01 ;
                        out <= 1'b0 ;
                    end
                    else begin      // -> and i = 0
						PS <= 2'b00 ;
                        out <= 1'b1 ;
                    end
                end

                2'b01: begin    // when PS = R1
                    if ( x ) begin  // -> and i = 1
                        PS <= 2'b00 ;
                        out <= 1'b1 ;
                    end
                    else begin      // -> and i = 0
                        PS <= 2'b10 ;
                        out <= 1'b0 ;
                    end
                end

                2'b10: begin    // when PS = R2
                    if ( x ) begin  // -> and i = 1
						PS <= 2'b10 ;
                        out <= 1'b0 ;
                    end
                    else begin      // -> and i = 0
                        PS <= 2'b01 ;
                        out <= 1'b0 ;
                    end
                end
					 
                default: begin  // default clause will never be reached -- written to prevent additional latch(es) in the hardware
                    PS <= 2'b00 ;
                    out <= 1'b1 ;
                end
            endcase
        end
    end // "always" block ends
    
endmodule