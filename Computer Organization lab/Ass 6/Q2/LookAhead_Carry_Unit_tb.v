`timescale 1ns / 1ps


module LookAhead_Carry_Unit;

	// Inputs
	reg [3:0] P;
	reg [3:0] G;
	reg cin;

	// Outputs
	wire [3:0] C;
	wire BP, BG ;

	// Instantiate the Unit Under Test (UUT)
	look_ahead_unit uut (
		.C(C), 
		.BP(BP),
		.BG(BG),
		.P(P), 
		.G(G), 
		.cin(cin)
	);

	initial begin
		$monitor($time, "		P = %b, G = %b, cin = %b, C = %b, BP = %b, BG = %b \n", P, G, cin, C, BP, BG);
		
		P = 0;
		G = 0;
		cin = 0;

		#100;
        
		P = 4'b0000;
		G = 4'b0000;
		cin = 0;
		
		#100;
		
		P = 4'b0010;
		G = 4'b0100;
		cin = 0;
		
		#100;
		
		P = 4'b1010;
		G = 4'b0011;
		cin = 0;
		
		#100;

	end
      
endmodule
