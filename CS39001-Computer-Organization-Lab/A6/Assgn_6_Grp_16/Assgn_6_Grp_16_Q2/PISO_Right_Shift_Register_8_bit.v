`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 06 -- 8-bit Parallel In Serial Out Right Shift Register
// 		File Summary : Design & implementation of 8-bit Parallel In Serial Out right shift register
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)
//////////////////////////////////////////////////////////////////////////////////
// PISO_Right_Shift_Register_8Bit implements a right shift register that allows load of data in Parallel and outputs data serially.
// +++ FEATURES +++
//  -- Positive-Edge Triggered : at every positive edge of the click, the bits stored in the register are shifted towards right and
//                               the least significant bit is emitted as the serial output.
//  -- Synchronous Reset : a reset signal initializes/sets all 8 bits in the register to 0; being a synchronous signal, it can work
//                         only when the clock is at the positive edge (reset is synchronized with the clock).
//  -- Synchronous Parallel Load Facility : loads the 8-bit input string into the register; being a synchronous facility, it can work
//                                          only when the clock is at the positive edge (load is synchronized with the clock).

// +++ INPUT PORTS +++
//  clk - clock with which the shift operations of the register are synchronized
//  rst - reset signal to set all 8 bits in the register to 0
//  load - if load is 1, the 8-bit input string is loaded into the register (LOAD OPERATION);
//         if load is 0, the bits in the register are shifted towards right (SHIFT OPERATION)
//  inp - 8-bit parallel load input

// +++ OUTPUT PORTS +++
//  data - serial output bit emitted from the least significant side of the stored 8-bits during SHIFT OPERATION
module PISO_Right_Shift_Register_8_bit( clk , rst , load , inp , data ) ;

    input clk, rst, load; 				// define clk, rst, load as inputs
    input [7:0] inp ;      			// define inp as a 8-bit wide input
    output reg data ;       			// define data as a reg output (reg because it is on the LHS of an instruction in "always" block)

	 reg [7:0] x ;  // x : the 8-bit binary string that is stored in the register at any point.
                    // defined as a 8-bit wide reg
                    // (reg because it is on the LHS of an instruction in "always" block) 

    always @ ( posedge clk ) begin  // "always" block begins
                                    // sensitivity list -- posedge clk (positive-edge triggered shift register)
        if ( load )     // [LOAD OP] check for parallel load (parallel load at the highest precedence)
			begin
            x <= inp ;  // if "load" signal is active, load the parallel input into the register (NBA)
				data <= 1'b0 ;	// By default data is 1'b0
			end
        else if ( rst )     // [RESET OP] check for reset
			begin
            x <= 8'b0 ;    // if "rst" signal is active, set all bits in register ("x") to 0 (NBA)
				data <= 1'b0 ;	// By default data is 1'b0
			end
        else begin      // [SHIFT OP]
            data <= x[0] ; // least significant bit stored in the register is assigned to "data" (serial output) (NBA)
            x <= (x >> 1) ; // concurrently, the bits stored in the register are shifted towards right (NBA)
        end

    end     // "always" block ends

endmodule
