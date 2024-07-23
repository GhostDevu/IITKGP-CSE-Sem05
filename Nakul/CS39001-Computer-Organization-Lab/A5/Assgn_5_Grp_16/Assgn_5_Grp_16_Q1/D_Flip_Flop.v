
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 05 -- D Flip Flop
// 		File Summary : Designed and implemented a D Flip Flop with Asynchronous Reset
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)

`timescale 1ns / 1ps

// [[ D Flip Flop ]] -- Module for D Flip Flop (takes in three 1-bit binary inputs
// "clk", "rst", and "D" as inputs; and outputs a two 1-bit binary outputs
// "Q" and "Q_bar")
//////////////////////////////////////////////////////////////////////////////////
// The D Flip Flop is active only at the positive edge of the Clock (clk)
// and can be reset to 0 asynchronously by putting the rst bit to 1.
// 
// The truth table of the D Flip Flop is given below 
// (rst = 0)
// clk	|	D	|	Q	|	Q_bar	
//	---------------------------
//	1		|	0	|	0	|	1
//	1		|	1	|	1	|	0
// 0		|	0	|	Q	|	Q_bar
// 0		|	1	|	Q	|	Q_bar
//
// The clock(clk) value is a don't care.
// (rst = 1) 
// D	|	Q	|	Q_bar	
//	---------------------------
//	0	|	0	|	1
//	1	|	0	|	1
//
// Note: Q_bar is not added as an output to the D-Flip Flop as it causes a warning
// which says port not connected to the instance because LFSR does not use Q_bar.

module D_Flip_Flop(clk, rst, D, Q);
	input wire clk, rst, D; // Input wires clk, rst, and D
	output reg Q; 	// Outputs Q
	
	// The always block's is active either at the positive edge of the clock or when the reset bit is 1
	always @(posedge clk or posedge rst)	// asynchronous reset (posedge rst signal in the sensitivity list)
	begin
		// If reset bit is 1 then set Q to 0
		if(rst)
			begin
				Q <= 1'b0;
			end
		// Else set Q to D 
		else
			begin
				Q <= D;
			end
	end
endmodule

