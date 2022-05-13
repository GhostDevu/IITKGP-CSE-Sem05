
// Computer Organization Laboratory (CS39001)
// Semester 05 (Autumn 2021-22)
// Assignment 05 -- Multiple of 3 Detector FSM Testing
// 		File Summary : Writing test bench for Multiple of 3 Detector FSM module
// Group No. 16
//      Hritaban Ghosh (19CS30053)
//      Nakul Aggarwal (19CS10044)

`timescale 1ns / 1ps

module Test_Bench_Multiple_Of_3_Detector_FSM ;

	// inputs
	reg clk, rst, x ;
	// outputs
    wire out ;

	// Instantiate the Unit Under Test (UUT)
	Multiple_Of_3_Detector_FSM uut (clk, rst, x, out) ;
	
	// test case arguements
	// ( since the FSM is designed for inputs of any arbitrary size,
	// 	 we have included test cases for inputs of varying sizes )
	reg[0:7] I8 ;
	reg[0:15] I16 ;
	reg[0:31] I32 ;

	// FSM output strings
	reg[0:7] O8 ;
	reg[0:15] O16 ;
	reg[0:31] O32 ;
	
    integer i ;	// iterator for for-loop construct

	initial begin
		clk = 0 ;	// initialize the clock
	end
	
	always 
		#10 clk = ~clk; 	// clock time period = 20ns

	initial begin
		// TEST CASE 1.1 : 8-bit input whose decimal value is of type 3k
		rst = 1 ;	// reset the state of the FSM
		#10 ; rst = 0 ;
		I8 = 8'b10010011 ;
		x = I8[0] ;	// send the MSB as the first input to the FSM 
		#10 O8[0] = out ;
		for(i = 1; i < 8; i = i+1)  begin
			#10 x = I8[i] ; #10 ;	// serially send the bits of the input string from the MSB side
			// (synchronized with clock)
			O8[i] = out ;	// append "out" bit to the output string
		end
		$display(" TEST CASE 1.1 || Input : %d | Output : %b | Is Multiple Of 3 : %b", I8, O8, out) ;  // display results
		// [All other test cases are implemented in a similar way]

		// TEST CASE 1.2 : 8-bit input whose decimal value is of type 3k+1
		rst = 1 ;
		#10 ; rst = 0 ;
		I8 = 8'b10010100 ;
		x = I8[0] ;
		#10 O8[0] = out ;
		for(i = 1; i < 8; i = i+1)  begin
			#10 x = I8[i] ; #10 ;
			O8[i] = out ;
		end
		$display(" TEST CASE 1.2 || Input : %d | Output : %b | Is Multiple Of 3 : %b", I8, O8, out) ;

		// TEST CASE 1.3 : 8-bit input whose decimal value is of type 3k+2
        rst = 1 ;
		#10 ; rst = 0 ;
		I8 = 8'b10010101 ;
		x = I8[0] ;
		#10 O8[0] = out ;
		for(i = 1; i < 8; i = i+1)  begin
			#10 x = I8[i] ; #10 ;
			O8[i] = out ;
		end
		$display(" TEST CASE 1.3 || Input : %d | Output : %b | Is Multiple Of 3 : %b", I8, O8, out) ;

		// TEST CASE 1.4 : 8-bit input whose decimal value is of type 3k
        rst = 1 ;
		#10 ; rst = 0 ;
		I8 = 8'b10010110 ;
		x = I8[0] ;
		#10 O8[0] = out ;
		for(i = 1; i < 8; i = i+1)  begin
			#10 x = I8[i] ; #10 ;
			O8[i] = out ;
		end
		$display(" TEST CASE 1.4 || Input : %d | Output : %b | Is Multiple Of 3 : %b", I8, O8, out) ;
        
        // TEST CASE 2.1 : 16-bit input whose decimal value is of type 3k+1
        rst = 1 ;
		#10 ; rst = 0 ;
		I16 = 16'b1011_1011_1110_0100 ;
		x = I16[0] ;
		#10 O16[0] = out ;
		for(i = 1; i < 16; i = i+1)  begin
			#10 x = I16[i] ; #10 ;
			O16[i] = out ;
		end
		$display(" TEST CASE 2.1 || Input : %d | Output : %b | Is Multiple Of 3 : %b", I16, O16, out);
		
		// TEST CASE 2.2 : 16-bit input whose decimal value is of type 3k+2
		rst = 1 ;
		#10 ; rst = 0 ;
		I16 = 16'b1011_1011_1110_0101 ;
		x = I16[0] ;
		#10 O16[0] = out ;
		for(i = 1; i < 16; i = i+1)  begin
			#10 x = I16[i] ;  #10 ;
			O16[i] = out ;
		end
		$display(" TEST CASE 2.2 || Input : %d | Output : %b | Is Multiple Of 3 : %b", I16, O16, out);
		
		// TEST CASE 2.3 : 16-bit input whose decimal value is of type 3k
        rst = 1 ;
		#10 ; rst = 0 ;
		I16 = 16'b1011_1011_1110_0110 ;
		x = I16[0] ;
		#10 O16[0] = out ;
		for(i = 1; i < 16; i = i+1)  begin
			#10 x = I16[i] ; #10 ;
			O16[i] = out ;
		end
		$display(" TEST CASE 2.3 || Input : %d | Output : %b | Is Multiple Of 3 : %b", I16, O16, out);

		// TEST CASE 2.4 : 16-bit input whose decimal value is of type 3k+1
        rst = 1 ;
		#10 ; rst = 0 ;
		I16 = 16'b1011_1011_1110_0111 ;
		x = I16[0] ;
		#10 O16[0] = out ;
		for(i = 1; i < 16; i = i+1)  begin
			#10 x = I16[i] ; #10 ;
			O16[i] = out ;
		end
		$display(" TEST CASE 2.4 || Input : %d | Output : %b | Is Multiple Of 3 : %b", I16, O16, out);

        // TEST CASE 3.1 : 32-bit input whose decimal value is of type 3k+2
        rst = 1 ;
		#10 ; rst = 0 ;
		I32 = 32'b1001_0011_1011_0000_1011_1111_0011_1101 ;
		x = I32[0] ;
		#10 O32[0] = out ;
		for(i = 1; i < 32; i = i+1)  begin
			#10 x = I32[i] ; #10 ;
			O32[i] = out ;
		end
		$display(" TEST CASE 3.1 || Input : %d | Output : %b | Is Multiple Of 3 : %b", I32, O32, out);
		
		// TEST CASE 3.2 : 32-bit input whose decimal value is of type 3k
		rst = 1 ;
		#10 ; rst = 0 ;
		I32 = 32'b1001_0011_1011_0000_1011_1111_0011_1110 ;
		x = I32[0] ;
		#10 O32[0] = out ;
		for(i = 1; i < 32; i = i+1)  begin
			#10 x = I32[i] ; #10 ;
			O32[i] = out ;
		end
		$display(" TEST CASE 3.2 || Input : %d | Output : %b | Is Multiple Of 3 : %b", I32, O32, out);

		// TEST CASE 3.3 : 32-bit input whose decimal value is of type 3k+1
        rst = 1 ;
		#10 ; rst = 0 ;
		I32 = 32'b1001_0011_1011_0000_1011_1111_0011_1111 ;
		x = I32[0] ;
		#10 O32[0] = out ;
		for(i = 1; i < 32; i = i+1)  begin
			#10 x = I32[i] ; #10 ;
			O32[i] = out ;
		end
		$display(" TEST CASE 3.3 || Input : %d | Output : %b | Is Multiple Of 3 : %b", I32, O32, out);

		// TEST CASE 3.4 : 32-bit input whose decimal value is of type 3k+2
        rst = 1 ;
		#10 ; rst = 0 ;
		I32 = 32'b1001_0011_1011_0000_1011_1111_0100_0000 ;
		x = I32[0] ;
		#10 O32[0] = out ;
		for(i = 1; i < 32; i = i+1)  begin
			#10 x = I32[i] ; #10 ;
			O32[i] = out ;
		end 
		$display(" TEST CASE 3.4 || Input : %d | Output : %b | Is Multiple Of 3 : %b", I32, O32, out);
	end

endmodule