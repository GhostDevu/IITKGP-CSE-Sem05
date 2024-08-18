`timescale 1ns / 1ps



module full_adder_16_bit_tb;

	reg [15:0] a;
	reg [15:0] b;
	reg cin;

	wire [15:0] s;
	wire cout;

	full_adder_16_bit uut (
		.a(a), 
		.b(b), 
		.cin(cin), 
		.s(s), 
		.cout(cout)
	);

	initial begin
		$monitor($time, "		a = %d, b = %d, cin = %b, s = %d, cout = %b \n", a, b, cin, s, cout);

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
		
		a = 65535;
		b = 65535;
		cin = 1;
		
		#100;
	end
      
endmodule

