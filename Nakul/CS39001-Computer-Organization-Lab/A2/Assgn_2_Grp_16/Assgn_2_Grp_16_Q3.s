
# Computer Organization Laboratory (CS39001)
# Semester 05 (Autumn 2021-22)
# Assignment 02 -- Problem 03
#   [ This program tells if an integer 'n' (> 9) entered by the user is a prime number or not ]
# Group No. 16
#      Hritaban Ghosh (19CS30053)
#      Nakul Aggarwal (19CS10044)

# ++++ DATA SEGMENT ++++ #
# Definitions of all the string literals that are printed by the program through system calls
.data
prompt:
	.asciiz	"Enter a positive integer greater than or equals to 10: "
prime:
	.asciiz	"Entered number is a PRIME number."
composite:
	.asciiz	"Entered number is a COMPOSITE number."
newline:
	.asciiz	"\n"
error:
	.asciiz	"ERROR: Entered number is less than 10. Please try again!!!"

# ++++ TEXT SEGMENT ++++ #

# +++ PROGRAM VARIABLES +++ #
#   'n'   ($s0)
#   'i'   ($s1)
.text
.globl main		# main is a global name
main:			# Main Program 
	# Prompts the user for an integer
	la $a0, prompt	# loads $a0 with the address of the string prompt
	li $v0, 4		# prints the string
	syscall

	# Reads the integer entered by the user 
	li $v0, 5		# reads the integer
	syscall
	move $s0, $v0	# result returned in $v0

	# Sanity checking to ensure that integer is greater than or equal to 10
	li $t0, 10		# store 10 in a $t0
	blt $s0, $t0, input_error	# branch to input_error if entered integer is less than 10

	# Initialize iterator i ($s1) to 2
	li $s1, 2	# store 2 in iterator $s1

# Loop to check divisibility of n($s0) by i($s1) 
loop:
	div $s0, $s1		# Perform division $s0/$s1, Remainder is stored in special register $hi and Quotient is stored in special register $lo
	addi $s1, $s1, 1	# Increment the iterator 'i'
	mfhi $t0			# Move the remainder from special register hi to $t0
	beq $t0, $0, IS_COMPOSITE	# Check if remainder is zero, if true then n is composite else continue
	beq $s1, $s0, IS_PRIME		# Check if iterator has reached value of n, if true then n is prime else continue
	j loop		# re-iterate over the loop

# n is found to be prime
IS_PRIME:
	# Print message that n is PRIME
	la $a0, newline	# loads $a0 with the address of the string newline
	li $v0, 4		# prints the string
	syscall
	la $a0, prime	# loads $a0 with the address of the string prime
	li $v0, 4		# prints the string
	syscall
	j exit	# jump to exit

# n is found to be composite
IS_COMPOSITE:
	# Print message that n is COMPOSITE
	la $a0, newline	# loads $a0 with the address of the string newline
	li $v0, 4		# prints the string
	syscall
	la $a0, composite	# loads $a0 with the address of the string composite
	li $v0, 4			# prints the string
	syscall
	j exit	# jump to exit
	
# 'n' is less than 10 -- sanity check failed
input_error:
	# Print error message for an erroneous input 
	la $a0, newline	# loads $a0 with the address of the string newline
	li $v0, 4		# prints the string
	syscall
	la $a0, error	# loads $a0 with the address of the string error
	li $v0, 4		# prints the string
	syscall

# Exit the program
exit:
	li $v0, 10	# exit
	syscall