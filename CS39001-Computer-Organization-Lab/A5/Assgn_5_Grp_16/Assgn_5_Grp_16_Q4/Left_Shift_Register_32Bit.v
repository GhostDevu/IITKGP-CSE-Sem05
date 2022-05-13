
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 05 -- 32-bit Left Shift Register
// 		File Summary : Design & implementation of 32-bit left shift register
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)

`timescale 1ns / 1ps

// Left_Shift_Register_32Bit implements a left shift register that stores 32 bits of data.
// +++ FEATURES +++
//  -- Positive-Edge Triggered : at every positive edge of the click, the bits stored in the register are shifted towards left and
//                               the most significant bit is emitted as the serial output.
//  -- Synchronous Reset : a reset signal initializes/sets all 32 bits in the register to 0; being a synchronous signal, it can work
//                         only when the clock is at the positive edge (reset is synchronized with the clock).
//  -- Synchronous Parallel Load Facility : loads the 32-bit input string into the register; being a synchronous facility, it can work
//                                          only when the clock is at the positive edge (load is synchronized with the clock).

// +++ INPUT PORTS +++
//  clk - clock with which the shift operations of the register are synchronized
//  rst - reset signal to set all 32 bits in the register to 0
//  load - if load is 1, the 32-bit input string is loaded into the register (LOAD OPERATION);
//         if load is 0, the bits in the register are shifted towards left (SHIFT OPERATION)
//  inp - 32-bit parallel load input

// +++ OUTPUT PORTS +++
//  data - serial output bit emitted from the most significant side of the stored 32-bits during SHIFT OPERATION

// * NBA = Non Blocking Assignment *
module Left_Shift_Register_32Bit ( clk , rst , load , inp , data ) ;

    input clk, rst, load ;  // define clk, rst, load as inputs
    input [31:0] inp ;      // define inp as a 32-bit wide input
    output reg data ;       // define data as a reg output (reg because it is on the LHS of an instruction in "always" block)

    reg [31:0] x ;  // x : the 32-bit binary string that is stored in the register at any point.
                    // defined as a 32-bit wide reg
                    // (reg because it is on the LHS of an instruction in "always" block) 

    always @ ( posedge clk ) begin  // "always" block begins
                                    // sensitivity list -- posedge clk (positive-edge triggered shift register)
        if ( load )     // [LOAD OP] check for parallel load (parallel load at the highest precedence)
            x <= inp ;  // if "load" signal is active, load the parallel input into the register (NBA)
        
        else if ( rst )     // [RESET OP] check for reset
            x <= 32'b0 ;    // if "rst" signal is active, set all bits in register ("x") to 0 (NBA)
        
        else begin      // [SHIFT OP]
            data <= x[31] ; // most significant bit stored in the register is assigned to "data" (serial output) (NBA)
            x <= (x << 1) ; // concurrently, the bits stored in the register are shifted towards left (NBA)
        end

    end     // "always" block ends

endmodule