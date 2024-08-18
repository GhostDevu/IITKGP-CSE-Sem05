`include "CLA_4_bit_Augmented.v"

`timescale 1ns / 1ps


module CLA_4_bit_Augmented_tb;

	// Inputs
	reg [3:0] a;
	reg [3:0] b;
	reg cin;

	// Outputs
	wire BP;
	wire BG;
	wire [3:0] s;

	// Instantiate the Unit Under Test (UUT)
	CLA_4_bit_augmented uut (
		.BP(BP), 
		.BG(BG), 
		.s(s), 
		.a(a), 
		.b(b), 
		.cin(cin)
	);

	initial begin
		$dumpfile("CLA_4_bit_Augmented.vcd");
		$dumpvars(0,CLA_4_bit_Augmented_tb);
		$monitor($time, "		a = %d, b = %d, cin = %b, sum = %d, BP = %b, BG = %b \n", a, b, cin, s, BP, BG);
		
		a = 0;
		b = 0;
		cin = 0;

		#100;
        
		a = 5;
		b = 1;
		cin = 0;
		
		#100;
		
		a = 3;
		b = 2;
		cin = 1;
		
		#100;
		
		a = 11;
		b = 1;
		cin = 0;
		
		#100;
		
		a = 12;
		b = 3;
		cin = 0;
		
		#100;
		
		a = 15;
		b = 1;
		cin = 0;
		
		#100;
		
		a = 11;
		b = 12;
		cin = 0;
			
		#100;
	end
      
endmodule
