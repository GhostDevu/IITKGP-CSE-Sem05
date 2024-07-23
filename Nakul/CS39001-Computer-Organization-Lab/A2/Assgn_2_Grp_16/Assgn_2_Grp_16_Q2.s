
# Computer Organization Laboratory (CS39001)
# Semester 05 (Autumn 2021-22)
# Assignment 02 -- Problem 02
#   [ This program computes the GCD of two non-negative integers entered by the user ]
# Group No. 16
#      Hritaban Ghosh (19CS30053)
#      Nakul Aggarwal (19CS10044)

# ++++ DATA SEGMENT ++++ #
# Definitions of all the string literals that are printed by the program through system calls
.data
prompt_first:
    .asciiz  " Enter the first non-negative integer : "
prompt_second:
    .asciiz  " Enter the second non-negative integer : "
error_msg:
    .asciiz " [ * SANITY CHECK FAILED * BOTH NOS. MUST BE NON-NEGATIVE * ] "
gcd_result:
    .asciiz " GCD of the two integers is "

# ++++ TEXT SEGMENT ++++ #

# +++ PROGRAM VARIABLES +++ #
#   'a' ($t0)
#   'b' ($t1)
.text
.globl main
main:
    # Print prompt asking the user to enter the first non-negative integer
    la $a0, prompt_first
    li $v0, 4
    syscall

    # Scan the first non-negative integer
    li $v0, 5
    syscall
    move $t0, $v0

    # Sanity checking on the first non-negative integer
    slt $t2, $t0, $zero
    bne $t2, $zero, error   # goto "error" if the entered integer is not non-negative

    # Print prompt asking the user to enter the second non-negative integer
    la $a0, prompt_second
    li $v0, 4
    syscall

    # Scan the second non-negative integer
    li $v0, 5
    syscall
    move $t1, $v0

    # Sanity checking on the second non-negative integer
    slt $t2, $t1, $zero
    bne $t2, $zero, error   # goto "error" if the entered integer is not non-negative

# At this point, the first non-negative number 'a' is stored in register $t0,
# second non-negative number 'b' is stored in register $t1

base_case:  # return the answer for the trivial case when (a = 0)
    bne $t0, $zero, loop    # check base case condition, i.e, if (a = 0)

    # Print result statement
    la $a0, gcd_result
    li $v0, 4
    syscall

    # Print result value (value of 'b')
    move $a0, $t1
    li $v0, 1
    syscall

    # exit the program
    li $v0, 10
    syscall

loop:   # enter the while loop
    beq $t1, $zero, return  # loop condition -- (b is not 0)

    sgt $t2, $t0, $t1
    bne $t2, $zero, if  # if (a > b) goto "if"
    sub $t1, $t1, $t0   # otherwise do {b = b - a}
    b loop  # re-iterate

if:    # if (a > b) a = a - b
    sub $t0, $t0, $t1
    b loop  # re-iterate

return:     # break out of while loop
    # Print result statement
    la $a0, gcd_result
    li $v0, 4
    syscall

    # Print result value (value of 'a')
    move $a0, $t0
    li $v0, 1
    syscall

    # exit the program
    li $v0, 10
    syscall

error:      # sanity checking failed
    # print error message
    la $a0, error_msg
    li $v0, 4
    syscall

    # exit the program
    li $v0, 10
    syscall