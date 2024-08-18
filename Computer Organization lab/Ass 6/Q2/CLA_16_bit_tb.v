`timescale 1ns / 1ps


module CLA_16_bit_tb;

	reg [15:0] a;
	reg [15:0] b;
	reg cin;

	// Outputs
	wire [15:0] s;
	wire cout;
	wire BP, BG ;

	CLA_16_bit_lookahead uut (
		.s(s), 
		.cout(cout),
		.BP(BP),
		.BG(BG),
		.a(a), 
		.b(b), 
		.cin(cin)
	);

	initial begin
		$monitor($time, "		a = %d, b = %d, cin = %b, sum = %d, cout = %b, BP = %b, BG = %b \n", a, b, cin, s, cout, BP, BG);
		a = 0;
		b = 0;
		cin = 0;

		#100;
        
		a = 1060;
		b = 11000;	
		cin = 0;
		
		#100;
		
		a = 12500;
		b = 3100;
		cin = 1;
		
		#100;
		
		a = 30143;
		b = 2200;
		cin = 0;
		
		#100;
		
		a = 1140;
		b = 21000;
		cin = 1;
		
		#100;
		
		a = 65505;
		b = 31;
		cin = 0;
		
		#100;
		
		a = 32005;
		b = 33533;
		cin = 0;
	
		
		#100;
	end
      
endmodule
