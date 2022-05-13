`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 06 -- 8-bit Serial In Parallel Out Right Shift Register
// 		File Summary : Design & implementation of 8-bit Serial In Parallel Out right shift register
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)
//////////////////////////////////////////////////////////////////////////////////
// SIPO_Right_Shift_Register_8Bit implements a right shift register that takes input serially and outputs all the 8 bits parallely.
// +++ FEATURES +++
//  -- Positive-Edge Triggered : at every positive edge of the click, the bits stored in the register are shifted towards right.
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
//	 fill_bit - fills the MSB of the register with the fill_bit at each clock cycle during the SHIFT OPERATION (serial input)

// +++ OUTPUT PORTS +++
//  out - state of the register at any point is output as a parallel output
module SIPO_Right_Shift_Register_8_bit( clk , rst , load , inp , fill_bit, out ) ;

    input clk, rst, load, fill_bit; // define clk, rst, load, fill_bit as inputs
    input [7:0] inp ;      			// define inp as a 8-bit wide input
	 output reg [7:0] out;				// define out as the state of the register at any point

	 reg [7:0] x ;  // x : the 8-bit binary string that is stored in the register at any point.
                    // defined as a 8-bit wide reg
                    // (reg because it is on the LHS of an instruction in "always" block) 

    always @ ( posedge clk ) begin  // "always" block begins
                                    // sensitivity list -- posedge clk (positive-edge triggered shift register)
        if ( load )     // [LOAD OP] check for parallel load (parallel load at the highest precedence)
			begin
            x <= inp ;  // if "load" signal is active, load the parallel input into the register (NBA)
			end
        else if ( rst )     // [RESET OP] check for reset
			begin
            x <= 8'b0 ;    // if "rst" signal is active, set all bits in register ("x") to 0 (NBA)
			end
        else begin      // [SHIFT OP]
            x <= (x >> 1) ; // concurrently, the bits stored in the register are shifted towards right (NBA)
				x[7] <= fill_bit; // most significant bit of x is to be filled with the fill bit
        end
    end     // "always" block ends

	 always @ (*)
	 begin
		out = x; // Get the complete Parallel Output of the Register
	 end
	 
endmodule
