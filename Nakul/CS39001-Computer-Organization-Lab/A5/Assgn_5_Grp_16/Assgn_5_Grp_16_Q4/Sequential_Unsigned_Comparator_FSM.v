
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 05 -- Sequential Unsigned Comparator FSM
// 		File Summary : Design & implementation of an FSM that compares 
//					   the magnitude of two unsigned 32-bit binary numbers
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)

`timescale 1ns / 1ps

// +++ FINITE STATE MACHINE DESIGN +++
//
// +++ Machine Type +++
// The FSM designed in this problem is a Moore machine, in which the output depends only on the present state.
// 
// +++ States & State Encoding +++
//	The FSM will have 3 states by the following names.
//		-> EQ -- [MEANING - the magnitude of both the operands is same]
//		-> LT -- [MEANING - the magnitude of first operand is less than of second operand]
//		-> GT -- [MEANING - the magnitude of second operand is less than of first operand]
//	Since there are 3 states, 2 bits are required to represent them. The state encoding chosen is as follows.
//		-> 00 represents EQ
//		-> 01 represents LT
//		-> 10 represents GT
//		-> 11 (meaningless)
//
// +++ Inputs +++
//	The FSM can take following inputs.
//		-> 00 -- next bits of both the operands from the MSB side is 0.
//		-> 01 -- next bit of the first and second operand from the MSB side is 0 and 1 respectively.
//		-> 10 -- next bit of the first and second operand from the MSB side is 1 and 0 respectively.
//		-> 11 -- next bits of both the operands from the MSB side is 1.
//
// +++ Moore Outputs of the States +++
//	The states in the Moore machine have the following corresponding outputs
//		-> 010 for EQ
//		-> 100 for LT
//		-> 001 for GT
//
// +++ State Transition Table +++
/*	PS : present state
	NS : next state
	O : output string (LEG)
	i : input string
	+---------+-------------------------------------------+-----+
	|   PS    |		               NS     				  		|  O  |
	+---------+----------+----------+----------+----------+-----+
	|		  	 |  i = 00  |  i = 01  |  i = 10  |  i = 11  |		|
	+---------+----------+----------+----------+----------+-----+
	| EQ (00) | EQ (00)  | GT (10)  | LT (01)  | EQ (00)  | 010 |
	| LT (01) | LT (01)  | LT (01)  | LT (01)  | LT (01)  | 100 |
	| GT (10) | GT (10)  | GT (10)  | GT (10)  | GT (10)  | 001 |
	+---------+----------+----------+----------+----------+-----+
	* The "Next State Function" and "Output Function" are clear from the state transition table.
*/
// +++ FEATURES +++
//  -- Positive-Edge Triggered : Acceptance of input bit and resultant state transition can only occur at positive edge of the clock.
//  -- Synchronous Reset : a reset signal initializes/sets the state of the FSM to EQ (00), it can work
//                         only when the clock is at the positive edge (reset is synchronized with the clock).

// +++ INPUT PORTS +++
//  x1 - 32-bit binary string (first operand of comparison operation)
//  x2 - 32-bit binary string (second operand of comparison operation)
//  clk - clock with which the shift operations of the register and state transitions of FSM are synchronized
//  rst - reset signal to set all 32 bits in the register to 0 and to initialize the state of FSM to EQ
// 	load - if load is 1, the 32-bit operand is loaded into the designated register (LOAD OPERATION);
//         if load is 0, the bits in the designated register are shifted towards left (SHIFT OPERATION)
//	OP - if 0, the output string remains constant at "000" (SESSION ACTIVE);
//		 if 1, the output string indicates the comparison result as "001", "010" or "100" (SESSION ENDED)

// +++ OUTPUT PORTS +++
//  out - a 3-bit comparison result (in the form of LEG) emitted when the FSM haults and OP logic becomes 1.

// * NBA = Non Blocking Assignment *
module Sequential_Unsigned_Comparator_FSM ( x1 , x2 , clk , rst , load , out , OP ) ;

	input [31:0] x1, x2 ;
    input clk, rst, load ;	// define clk, rst, load as inputs
    wire data_x1, data_x2 ;	// data_x1 : serial output from the shift register designated for the first operand
							// data_x2 : serial output from the shift register designated for the second operand
							// defined as wire(s)
    input OP ;	// define OP as an input
    output reg [2:0] out ;	// comparison result defined as a 3-bit wide reg output
							// (reg because it is on the LHS of an instruction in "always" block) 

    Left_Shift_Register_32Bit LSR1 (clk, rst, load, x1, data_x1) ;	// instantiate left shift register to store the first operand
    Left_Shift_Register_32Bit LSR2 (clk, rst, load, x2, data_x2) ;	// instantiate left shift register to store the second operand

    reg [1:0] PS ;	// PS : present state of the FSM (defined as a 2-bit wide reg)
					// (reg because it is on the LHS of an instruction in "always" block)

    always @ ( posedge clk ) begin	// "always" block begins [for state transition]
												// sensitivity list -- posedge clk (positive-edge triggered FSM)
		if ( rst )	// [RESET OP] check for reset
			PS <= 2'b00 ;	// if "rst" signal is active, set present state ("PS") to 00 (NBA)

		else begin	// [STATE TRANSITION ROUTINE]
					// 	(* refer to state transition table to implement this routine *)
					// 	(all assignments are NBA)
			if ( PS == 2'b00 ) begin
				case ({data_x1, data_x2})	// {data_x1, data_x2} = input to the FSM ("i" in transition table)
					2'b10:    PS <= 2'b10 ;
					2'b01:    PS <= 2'b01 ;
					default:  PS <= 2'b00 ;
				endcase
			end
			
			else begin
				case ( PS )
					2'b10:		PS <= 2'b10 ;
					2'b01:		PS <= 2'b01 ;
					default:	PS <= 2'b00 ;	// this line will never be reached -- written to prevent additional latch(es) in the hardware
				endcase
			end
		end
    end	// "always" block ends
	 
	always @ ( OP, PS ) begin	// "always" block begins [for output]
								// sensitivity list -- OP (indicates end of session/haulting of FSM)
								//					   PS (present state determines the output in Moore machine)
								// (all assignments are NBA)
		if (OP) begin	// if OP is logic-1, set output lines as the Moore output of the present(final) state of FSM 
			case (PS)	//	(* refer to state transition table to implement this case control structure *)
				2'b00:	out <= 3'b010 ;
				2'b10:	out <= 3'b001 ;
				2'b01: 	out <= 3'b100 ;
				default: out <= 3'b000 ;	// this line will never be reached -- written to prevent additional latch(es) in the hardware
			endcase
		end
		
		else	// if OP is logic-0, all the output lines will be 0
			out <= 3'b000 ;
	end	// "always" block ends

endmodule