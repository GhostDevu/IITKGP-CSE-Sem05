`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 06 -- Problem 01 [Bidirectional Barrel Shifter]
// 		File Summary : Designed and implemented a Bidirectional Barrel Shifter
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)
//////////////////////////////////////////////////////////////////////////////////
// [[ Bidirectional Barrel Shifter ]] -- Module for Bidirectional Barrel Shifter 
// (takes in one 8-bit binary input "in", one 3-bit binary input "shamt", and one 
// 1-bit binary input "dir" as inputs; and outputs one 8-bit binary output "out")
//////////////////////////////////////////////////////////////////////////////////
// The 8-bit Bidirectional Barrel Shifter circuit, which can perform logical shift by a specified
// amount shamt, either in right or in left direction depending on a control signal dir.
//////////////////////////////////////////////////////////////////////////////////

module barrel_shifter(in, shamt, dir, out);
	input wire [7:0] in;			// 8-bit Input before shifting
	input wire [2:0] shamt;		// 3-bit binary number which is the amount of shift - 0 to 7
	input wire dir;				// dir indicates the direction of shifting
	output wire [7:0] out;		// 8-bit Output after shifting by shift amount in the direction indicated by dir
	
	wire [7:0] w0, w1, w2, w3, w4; // Interconnecting wires - A total of 40 wires
	
	//dir = 1 for left shifts and dir = 0 for right shifts
	//Level of Multiplexers which reverses the 8-bit input depending on the direction of shift "dir"
	Mux2to1 dir_Level_0_Mux_0(.Output(w0[7]), .Sel(dir), .Input_0(in[7]), .Input_1(in[0]));
	Mux2to1 dir_Level_0_Mux_1(.Output(w0[6]), .Sel(dir), .Input_0(in[6]), .Input_1(in[1]));
	Mux2to1 dir_Level_0_Mux_2(.Output(w0[5]), .Sel(dir), .Input_0(in[5]), .Input_1(in[2]));
	Mux2to1 dir_Level_0_Mux_3(.Output(w0[4]), .Sel(dir), .Input_0(in[4]), .Input_1(in[3]));
	Mux2to1 dir_Level_0_Mux_4(.Output(w0[3]), .Sel(dir), .Input_0(in[3]), .Input_1(in[4]));
	Mux2to1 dir_Level_0_Mux_5(.Output(w0[2]), .Sel(dir), .Input_0(in[2]), .Input_1(in[5]));
	Mux2to1 dir_Level_0_Mux_6(.Output(w0[1]), .Sel(dir), .Input_0(in[1]), .Input_1(in[6]));
	Mux2to1 dir_Level_0_Mux_7(.Output(w0[0]), .Sel(dir), .Input_0(in[0]), .Input_1(in[7]));
	
	//Level 1 of Muxes to handle 4 bit logical right shifts
	//Level of Multiplexers which performs logical shift by 4 bits to the right depending on 2nd bit of shift amount "shamt[2]"
	Mux2to1 shift_Level_1_Mux_0(.Output(w1[7]), .Sel(shamt[2]), .Input_0(w0[7]), .Input_1(1'b0));
	Mux2to1 shift_Level_1_Mux_1(.Output(w1[6]), .Sel(shamt[2]), .Input_0(w0[6]), .Input_1(1'b0));
	Mux2to1 shift_Level_1_Mux_2(.Output(w1[5]), .Sel(shamt[2]), .Input_0(w0[5]), .Input_1(1'b0));
	Mux2to1 shift_Level_1_Mux_3(.Output(w1[4]), .Sel(shamt[2]), .Input_0(w0[4]), .Input_1(1'b0));
	Mux2to1 shift_Level_1_Mux_4(.Output(w1[3]), .Sel(shamt[2]), .Input_0(w0[3]), .Input_1(w0[7]));
	Mux2to1 shift_Level_1_Mux_5(.Output(w1[2]), .Sel(shamt[2]), .Input_0(w0[2]), .Input_1(w0[6]));
	Mux2to1 shift_Level_1_Mux_6(.Output(w1[1]), .Sel(shamt[2]), .Input_0(w0[1]), .Input_1(w0[5]));
	Mux2to1 shift_Level_1_Mux_7(.Output(w1[0]), .Sel(shamt[2]), .Input_0(w0[0]), .Input_1(w0[4]));

	//Level 2 of Muxes to handle 2 bit logical right shifts
	//Level of Multiplexers which performs logical shift by 2 bits to the right depending on 1st bit of shift amount "shamt[1]"
	Mux2to1 shift_Level_2_Mux_0(.Output(w2[7]), .Sel(shamt[1]), .Input_0(w1[7]), .Input_1(1'b0));
	Mux2to1 shift_Level_2_Mux_1(.Output(w2[6]), .Sel(shamt[1]), .Input_0(w1[6]), .Input_1(1'b0));
	Mux2to1 shift_Level_2_Mux_2(.Output(w2[5]), .Sel(shamt[1]), .Input_0(w1[5]), .Input_1(w1[7]));
	Mux2to1 shift_Level_2_Mux_3(.Output(w2[4]), .Sel(shamt[1]), .Input_0(w1[4]), .Input_1(w1[6]));
	Mux2to1 shift_Level_2_Mux_4(.Output(w2[3]), .Sel(shamt[1]), .Input_0(w1[3]), .Input_1(w1[5]));
	Mux2to1 shift_Level_2_Mux_5(.Output(w2[2]), .Sel(shamt[1]), .Input_0(w1[2]), .Input_1(w1[4]));
	Mux2to1 shift_Level_2_Mux_6(.Output(w2[1]), .Sel(shamt[1]), .Input_0(w1[1]), .Input_1(w1[3]));
	Mux2to1 shift_Level_2_Mux_7(.Output(w2[0]), .Sel(shamt[1]), .Input_0(w1[0]), .Input_1(w1[2]));
	
	
	//Level 3 of Muxes to handle 1 bit logical right shifts
	//Level of Multiplexers which performs logical shift by 1 bit to the right depending on 0th bit of shift amount "shamt[0]"
	Mux2to1 shift_Level_3_Mux_0(.Output(w3[7]), .Sel(shamt[0]), .Input_0(w2[7]), .Input_1(1'b0));
	Mux2to1 shift_Level_3_Mux_1(.Output(w3[6]), .Sel(shamt[0]), .Input_0(w2[6]), .Input_1(w2[7]));
	Mux2to1 shift_Level_3_Mux_2(.Output(w3[5]), .Sel(shamt[0]), .Input_0(w2[5]), .Input_1(w2[6]));
	Mux2to1 shift_Level_3_Mux_3(.Output(w3[4]), .Sel(shamt[0]), .Input_0(w2[4]), .Input_1(w2[5]));
	Mux2to1 shift_Level_3_Mux_4(.Output(w3[3]), .Sel(shamt[0]), .Input_0(w2[3]), .Input_1(w2[4]));
	Mux2to1 shift_Level_3_Mux_5(.Output(w3[2]), .Sel(shamt[0]), .Input_0(w2[2]), .Input_1(w2[3]));
	Mux2to1 shift_Level_3_Mux_6(.Output(w3[1]), .Sel(shamt[0]), .Input_0(w2[1]), .Input_1(w2[2]));
	Mux2to1 shift_Level_3_Mux_7(.Output(w3[0]), .Sel(shamt[0]), .Input_0(w2[0]), .Input_1(w2[1]));
	
	//dir = 1 for left shifts and dir = 0 for right shifts
	//Level of Multiplexers which reverses the 8-bit output depending on the direction of shift "dir"
	Mux2to1 dir_Level_4_Mux_0(.Output(out[7]), .Sel(dir), .Input_0(w3[7]), .Input_1(w3[0]));
	Mux2to1 dir_Level_4_Mux_1(.Output(out[6]), .Sel(dir), .Input_0(w3[6]), .Input_1(w3[1]));
	Mux2to1 dir_Level_4_Mux_2(.Output(out[5]), .Sel(dir), .Input_0(w3[5]), .Input_1(w3[2]));
	Mux2to1 dir_Level_4_Mux_3(.Output(out[4]), .Sel(dir), .Input_0(w3[4]), .Input_1(w3[3]));
	Mux2to1 dir_Level_4_Mux_4(.Output(out[3]), .Sel(dir), .Input_0(w3[3]), .Input_1(w3[4]));
	Mux2to1 dir_Level_4_Mux_5(.Output(out[2]), .Sel(dir), .Input_0(w3[2]), .Input_1(w3[5]));
	Mux2to1 dir_Level_4_Mux_6(.Output(out[1]), .Sel(dir), .Input_0(w3[1]), .Input_1(w3[6]));
	Mux2to1 dir_Level_4_Mux_7(.Output(out[0]), .Sel(dir), .Input_0(w3[0]), .Input_1(w3[7]));
endmodule
