
# Computer Organization Laboratory (CS39001)
# Semester 05 (Autumn 2021-22)
# Assignment 03 -- Question 01
#   [ This program computes the product of two 16 bit integers using Booth's Multiplication Algorithm ]
# Group No. 16
#      Hritaban Ghosh (19CS30053)
#      Nakul Aggarwal (19CS10044)

# ++++ DATA SEGMENT ++++ #
# Definitions of all the string literals that are printed by the program through system calls
.data
prompt_first:
    .asciiz     " Enter the first number : "
prompt_second:
    .asciiz     " Enter the second number : "
print_product_message:
    .asciiz     " Product of the two numbers are: "
out_of_range_error:
    .asciiz     " [ ERROR : The entered number is out of range. ] "
newline:
    .asciiz     "\n"

# ++++ TEXT SEGMENT ++++ #

.text
.globl main
main:
    # +++ main PROGRAM VARIABLES +++ #
    #   $t0 <-- Multiplicand M
    #   $t1 <-- Multiplier Q
    #   $t2 <-- Product

    # Print prompt asking the user to enter the first number
    la $a0, prompt_first
    li $v0, 4
    syscall

    # Scan the first number
    li $v0, 5
    syscall
    move $t0, $v0

    # Sanity checking to ensure that the number entered is within proper numerical range
    blt $t0, -32767, out_of_range   # -32768 is an illegal input because (A <-- A - M) might cause A to overflow if (A = 0) initially
    bgt $t0, 32767, out_of_range

    # Print prompt asking the user to enter the second number
    la $a0, prompt_second
    li $v0, 4
    syscall

    # Scan the second number
    li $v0, 5
    syscall
    move $t1, $v0

    # Sanity checking to ensure that the number entered is within proper numerical range
    blt $t1, -32768, out_of_range
    bgt $t1, 32767, out_of_range

    # Put the Multiplicand and Multiplier in $a0 and $a1 respectively as arguments
    move $a0, $t0
    move $a1, $t1

    # Jump and link to multiply_booth procedure
    jal multiply_booth

    # Store the result from $v0 in $t2 and jump to print_product
    move $t2, $v0
    j print_product

multiply_booth:
    # +++ multiply_booth PROGRAM VARIABLES +++ #
    #   $a0 <-- Argument Multiplicand
    #   $a1 <-- Argument Multiplier
    #   Upper 16 bits of $t0 <-- M
    #   Lower 16 bits of $t1 <-- Q
    #   Upper 16 bits of $t1 <-- A
    #   $t3 <-- Q[-1]
    #   $t4 <-- Count (Initialised to 16)
    #   $t5 <-- Q[0]
    #   $v0 <-- Result (Product formed by concatenating A and Q)
    
    addi $sp, $sp, -4       # Make room on stack for one registers
    sw $ra, 0($sp)          # Save the return address on the stack
    
    move $t0, $a0           # M <-- Multiplicand
    sll $t0, $t0, 16        # Upper 16 bits of $t0 <-- M

    move $t1, $a1           # Q <-- Multiplier
    sll $t1, $t1, 16
    srl $t1, $t1, 16        # Upper 16 bits of $t1 <-- A and Lower 16 bits of $t1 <-- Q

    move $t3, $zero         # Q[-1] <-- 0
    li $t4, 16              # Count <-- n(16)

loop:
    # Get the LSB of Q which is Q[0]
    sll $t5, $t1, 31        
    srl $t5, $t5, 31        # $t5 <-- Q[0]

    # If Q[0] == Q[-1] then jump to Shift else continue
    beq $t5, $t3, Shift

    # If Q[0] != 0 then jump to Q_0_is_1 else continue
    bne $t5, $zero, Q_0_is_1

    # Case where Q[0] = 0 and Q[-1] = 1

    # A <-- A + M
    add $t1, $t1, $t0

    # Jump to Shift
    j Shift

Q_0_is_1:   # Case where Q[0] = 1 and Q[-1] = 0   
    # A <-- A - M
    sub $t1, $t1, $t0
    
Shift:
    # Get Q[0] and put it in Q[-1]
    sll $t7, $t1, 31        # LSB of Q
    srl $t3, $t7, 31        # Q[-1] <-- Q[0]
    
    sra $t1, $t1, 1         # Arithmetic Right Shift of A, Q by 1
    
    # Decrement count
    addi $t4, $t4, -1       # Count <-- Count - 1

    # If Count != 0 then keep looping else continue
    bne $t4, $zero, loop

    # Product which is in $t1 is stored in $v0
    move $v0, $t1

    lw $ra, 0($sp)      # Load the return address from stack
    addi $sp, $sp, 4    # Restore stack pointer
    jr $ra              # Jump to return address

print_product:
    # Print out product 
    la $a0, print_product_message
    li $v0, 4
    syscall

    # Print the product
    move $a0, $t2
    li $v0, 1
    syscall

    # Jump to exit
    j exit
    
out_of_range:
    # Print out of range error because sanity checking failed
    la $a0, out_of_range_error
    li $v0, 4
    syscall

exit:
    # exit the program
    li $v0, 10
    syscall