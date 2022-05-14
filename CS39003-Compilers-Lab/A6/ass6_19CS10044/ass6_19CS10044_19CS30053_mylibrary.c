
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O6 -- Read-Write Library Functions
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)

#include "myl.h"	// Include myl.h (My Library)
#define BUFF 1000		// Define a buffer size to be 20

// Prints a string of characters to the console
int printStr(char *buff) 
{
	// Calculating the number of characters in the string buff excluding '\0'
	int i = 0;
	while(buff[i] != '\0')
	{
		i++;
	}
	
	// Number of bytes required to store buff (same as the number of characters)
	int bytes = i;
	
	// Part of the assembly code
	// Assembler will use it
	
	// %-indicates an argument, %%-indicates a register
	__asm__ __volatile__(
		"movl $1, %%eax \n\t" // $1 : Perform write operation
		"movq $1, %%rdi \n\t" // $1 : Output to STDOUT(console)
		"syscall \n\t"
		:
		:"S"(buff), "d"(bytes) // Pass the string and the number of characters as input arguments
	);	
	
	return bytes; // Number of characters being printed
}

// Read an signed integer from the console
int readInt(int *n) 
{

	char buff[BUFF]; // Buffer to store input by user
	
	// charsread will contain the number of characters read from the console
	// i is an iterator
	// num will store the signed integer inputted by the user
	// sign_flag is set to 1 if the input integer is negative else 0
	int charsread, i, num, sign_flag = 0;
	
	// Part of the assembly code
	// Assembler will use it
	__asm__ __volatile__ (
            "movl $0, %%eax \n\t" 	// $0 : Perform read operation
            "movq $0, %%rdi \n\t"   // $0 : Read from STDIN(console)
            "syscall \n\t"
            : "=a"(charsread)	// charsread is passed as output argument
            // buff will store the string inputted
            :"S"(buff), "d"(sizeof(buff)) // Pass the buffer by reference and the size of buffer as input arguments
        );
	
	// Store NULL(0x0) in extreme end of the string read from the console (NULL terminate the string)
	buff[--charsread] = 0x0;
	
	// Start from just before null termination
	i = charsread - 1;
    while(i >= 0 && buff[i--] == ' '); // Keep traversing all trailing empty spaces
    
    buff[i+2] = 0x0; // Store NULL(0x0) just after the integer input
    
    int end = i + 2; // Store the last position of input string (null termination)
    
    // Start from just before the buffer
    i = -1; 
    while(buff[++i] == ' '); // Keep traversing all the leading empty spaces 
           
    // i now contains the first position of integer input
	
    // Check if the integer is negative or not
    if(buff[i] == '-')
    {
        i++;
        sign_flag = 1;
    }   
    else if(buff[i] == '+') // Check if user has explicitly put '+' sign
    {
    	i++;
    }   
    
    // Check if the first digit is valid
    // If valid, store it in num else give out an error
    if(buff[i] >= '0' && buff[i] <= '9')
    {
        num = buff[i] - '0';
        i++;
    }
    else 
    {
    	return ERR; // character is not a digit
    }
    
    // Check for validity of each digit 
    // If valid, update num as num*10 + new_digit, else give out an error
    for( ; i < end ; i++)
    {             
        if(!(buff[i] >= '0' && buff[i] <= '9'))
        {
            return ERR; // charactr is not a digit and end of string input is not reached
        }
        num = num*10 + (buff[i] - '0'); // Update num 
    }       
    
    // num currently is magnitude of the integer input
    
    // If the sign_flag is set, num is made negative
    if(sign_flag)
    {
        num = -num;       
    }
    
    // If num < 0 and sign_flag is not set i.e. integer entered might be out of range then give out an error
    if(num < 0 && sign_flag == 0)
    {
    	return ERR;
    }
    
    // If num >= 0 and sign_flag is set i.e. integer entered might be out of range then give out an error
    if(num >= 0 && sign_flag == 1)
    {
    	return ERR;
    }
              
    (*n) = num; // Pass the integer back using pass-by-reference
	
    return OK;
}

// Prints a signed integer to the console
int printInt(int n)	
{
	// Declare a buffer of size BUFF
	// Intialize zero to the character constant '0'
	char buff[BUFF], zero = '0'; 
	
	
	// i is the iterator for string buff
	// j and k are indexes used in swap procedure during reversal of string buff
	// bytes - Store the number of bytes required to store the string printed to the console (same as number of characters)
	int i = 0, j, k, bytes;
	
	
	if(n == 0) 	
	{
		buff[i] = zero; // buff string is just "0"
		i++;
	}
	else
	{
		if(n<0) // n is negative
		{
			buff[i] = '-'; // Put the negative sign at the beginning of buff
			n = -n; // Make n positive
			
			i++;
		}
		
		// Extract each digit and put corresponding character in buff
		// Note: The digits are being stored in reverse. 123 ==> "321"
		while(n!=0) 
		{
			int digit = n%10;
			
			buff[i] = (char)(zero+digit); // Store each digit's corresponding character in the buffer
			
			if(!(buff[i]>='0' && buff[i]<='9'))
			{
				return ERR; // Give out an error if buffer does not contain a digit
			}
			
			n = n/10; 
			i++;
		}
		
		// Check for negative sign at the beginning of string buff
		if(buff[0] == '-')
		{
			j = 1; // j starts from 2nd character in buff(n is negative)
		}
		else
		{
			j = 0; // j starts from 1st character in buff(n is positive)
		}
		
		// Reverse the string to bring the digits in the correct order
		
		// i contains length[buff]
		// k contains length[buff]-1
		k = i-1; 
		
		// Swap procedure to reverse the string buff
		while(j<k)
		{
			char temp = buff[j];
			buff[j] = buff[k];
			buff[k] = temp;
			
			j++;
			k--;
		}
		
	}
	
	// Number of bytes required to store buff (same as the number of characters in buff)
	bytes = i;
	
	// Part of the assembly code
	// Assembler will use it
	
	// %-indicates an argument, %%-indicates a register
	__asm__ __volatile__(
		"movl $1, %%eax \n\t" // $1 : Perform write operation
		"movq $1, %%rdi \n\t" // $1 : Output to STDOUT(console)
		"syscall \n\t"
		:
		:"S"(buff), "d"(bytes)	// Pass the string and the number of characters as input arguments
	);	
	
	if(bytes+1 > BUFF)
	{
		return ERR; // overflow of characters
	}
	
	return OK; // Number of characters being printed
}

