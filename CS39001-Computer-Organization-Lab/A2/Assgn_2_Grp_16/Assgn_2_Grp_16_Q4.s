
# Computer Organization Laboratory (CS39001)
# Semester 05 (Autumn 2021-22)
# Assignment 02 -- Problem 04
#   [ This program tells if a positive integer 'n' entered by the user is a perfect number or not ]
# Group No. 16
#      Hritaban Ghosh (19CS30053)
#      Nakul Aggarwal (19CS10044)

# ++++ DATA SEGMENT ++++ #
# Definitions of all the string literals that are printed by the program through system calls
.data
prompt:
    .asciiz  " Enter a positive integer : "
perfect_number_msg:
    .asciiz " Entered integer is a perfect number "
non_perfect_number_msg:
    .asciiz " Entered integer is not a perfect number"
error_msg:
    .asciiz " [ * SANITY CHECK FAILED * INTEGER MUST BE POSITIVE * ] "

# ++++ TEXT SEGMENT ++++ #

# +++ PROGRAM VARIABLES +++ #
#   'n'   ($t0)
#   'i'   ($t1)
#   'sum' ($t2)
.text
.globl main
main:
    # Print prompt asking the user to enter a positive integer
    la $a0, prompt
    li $v0, 4
    syscall

    # Scan the positive integer
    li $v0, 5
    syscall
    move $t0, $v0   # 'n' -- positive integer

    # Sanity checking on the integer
    sgt $t1, $t0, $zero
    beq $t1, $zero, error  # goto "error" if the entered integer is not positive

    addi $t1, $zero, 2  # 'i' -- iterates over all the numbers less than 'n' searching for its divisors
    addi $t2, $zero, 1  # 'sum' -- accumulates sum of all the divisors of 'n' encountered

# +++ PROGRAM VARIABLES +++ #
#   'rem' ($t3)
outer_loop:    # outer loop (iterates over integers 'i' upto 'n' searching for divisors of 'n')
    slt $t3, $t1, $t0   # loop condition -- (i < n)
    beq $t3, $zero, exit_outer_loop

    add $t3, $t0, $zero # 'rem' -- stores the value of "n modulo i"

inner_loop:    # loop to compute 'rem', iterative computation of "n modulo i"
    blt $t3, $t1, L1    # break out of inner loop if (rem < i)
    bgt $t3, $t1, L2    # otherwise if (rem > i) then update 'rem'
    add $t2, $t2, $t1   # otherwise ( rem = i ) <--> 'i' is a divisor of 'n'; so add 'i' to 'sum'

L1:
    addi $t1, $t1, 1    # increment 'i' and
    b outer_loop        # re-iterate over outer-loop

L2:    
    sub $t3, $t3, $t1   # update 'rem' and
    b inner_loop        # re-iterate over inner-loop

exit_outer_loop:   # break out of outer loop
    bne $t2, $t0, not_perf  # 'n' is a perfect number if and only if (n = sum)

    # print an affirmation message (when n = sum)
    la $a0, perfect_number_msg
    li $v0, 4
    syscall

    # exit the program
    li $v0, 10
    syscall

not_perf:  # when (n != sum)
    # print a negation message
    la $a0, non_perfect_number_msg
    li $v0, 4
    syscall

    # exit the program
    li $v0, 10
    syscall

error: # sanity checking failed
    # print error message
    la $a0, error_msg
    li $v0, 4
    syscall

    # exit the program
    li $v0, 10
    syscall