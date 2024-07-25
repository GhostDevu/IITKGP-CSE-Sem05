# ASS-1 G-29
# 22CS30063
# 22CS30066

# LOGIC:
# Reducing N as we encounter prime numbers starting from 2 (lets say K)
#   if K divides N then we call next instance for (N = N/K & K=K)
#   else we call the next instace for (N=N & K=K+1)
#   Base case : when N==1  we end our output as we have found all prime factors of N

.text

start: # Jumping to Main label
    j main

recur_factors:
    # initializing instance on stack
    addi $sp, $sp, -12
    sw $ra, 8($sp)
    sw $a1, 4($sp)
    sw $a0, 0($sp)

    # base case
    addi $t0, $zero, 1
    beq $a0, $t0, base_case
    
    # division
    div $a0, $a1
    mfhi $t0

    # Calling next instance of function 
    beq $t0, $zero, Call_printer
    bgt $t0, $zero, Call_non_zero_rem

    # Ending function
    j end_func


Call_printer:
    # Printing a prime factor
    move $a0, $a1
    li $v0, 1
    syscall
    la $a0, space
    li $v0, 4
    syscall

    # next instance
    mflo $a0
    j recur_factors
    

Call_non_zero_rem:
    # next instance
    addi $a1, $a1, 1
    j recur_factors

base_case:
    # Ending message
    la $a0, end_msg
    li $v0, 4
    syscall
    j end_func

end_func:
    # De-intializing the stack
    lw $ra, 8($sp)
    lw $a1, 4($sp)
    lw $a0, 0($sp)
    addi $sp, $sp, 12

    # return to return address
    jr $ra

main:
    # taking in input
    la $a0, msg
    li $v0, 4
    syscall
    
    li $v0, 5
    syscall

    # intializing arguments
    move $a0, $v0
    li $a1, 2

    # Calling the recur_factors function
    jal recur_factors

    # Exit Code
    li $v0 , 10
    syscall 
    

.data
msg: .asciiz "Enter a positive number: "
space: .asciiz " "
end_msg: .asciiz "\nEnd of Output\n"