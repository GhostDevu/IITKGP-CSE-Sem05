# Group no 29
# More Aayush Babasaheb 22CS30063
# Devanshu Agrawal 22CS30066

.text

main:
    # Get No. of rows
    la $a0, row
    li $v0, 4
    syscall

    li $v0, 5
    syscall

    move $s0, $v0 # s0 stores the no. of rows

    # Get No. of columns

    la $a0, column
    li $v0, 4
    syscall

    li $v0, 5
    syscall

    move $s1, $v0 # s1 stores the no. of rows

    # Get a
    la $a0, a_
    li $v0, 4
    syscall

    li $v0, 5
    syscall

    move $s2, $v0 # s2 stores a

    # Get b
    la $a0, b_
    li $v0, 4
    syscall

    li $v0, 5
    syscall

    move $s3, $v0 # s3 stores b

    # passing
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    move $a3, $s3

    move $t0, $v0
    move $t1, $a0

    # Getting normal matrix 
    li $v0, 4
    la $a0, normalM
    syscall

    move $v0, $t0
    move $a0, $t1

    jal init

    move $t0, $v0
    move $t1, $a0

    li $v0, 4
    la $a0, new_line
    syscall

    # Getting the transpose of the matrix
    li $v0, 4
    la $a0, transposeM
    syscall

    move $v0, $t0
    move $a0, $t1

    jal transpose

    li $v0, 10
    syscall

init:

    li $t0, -1 
    li $t2, 1  

loop1:

    addi $t0, $t0, 1
    beq $a0, $t0, return1
    li $t1, -1  
    li $t3, 1   
    li $t7, 1   


    rem $s4, $t0, 2
    beqz $s4, loop2
    mul $t7, $t7, -1

loop2:
    addi $t1, $t1, 1

    beq $a1, $t1, return2


    mul $t4, $t0, 4
    mul $t4, $t4, $a1

    mul $t5, $t1, 4
    add $t4, $t4, $t5     


    move $t8, $t7
    mul $t8, $t8, $t2
    mul $t8, $t8, $t3


    sw $t8, matrix($t4)

    move $t6, $a0

    move $a0, $t8
    li $v0, 1
    syscall

    la $a0, space
    li $v0, 4
    syscall

    move $a0, $t6

    mul $t3, $t3, $a3
    mul $t7, $t7, -1
    j loop2

return2:
    move $t6, $a0

    la $a0, new_line
    li $v0, 4
    syscall
    move $a0, $t6

    mul $t2, $t2, $a2 
    j loop1

transpose:
    li $t0, -1 
    li $t2, 1 

transpose_loop1:
    addi $t0, $t0, 1
    beq $a1, $t0, return1

    li $t1, -1  
    li $t3, 1   
    li $t7, 1   

    rem $s4, $t0, 2
    beqz $s4, transpose_loop2
    mul $t7, $t7, -1

transpose_loop2:
    addi $t1, $t1, 1

    beq $a0, $t1, transpose_return

    mul $t4, $t0, 4
    mul $t5, $t1, 4
    mul $t5, $t5, $a1
    add $t6, $t4, $t5           

    lw $t8, matrix($t6)

    move $t6, $a0

    move $a0, $t8
    li $v0, 1
    syscall

    la $a0, space
    li $v0, 4
    syscall

    move $a0, $t6

    mul $t3, $t3, $a3
    mul $t7, $t7, -1
    j transpose_loop2

transpose_return:
    move $t6, $a0

    la $a0, new_line
    li $v0, 4
    syscall
    move $a0, $t6

    mul $t2, $t2, $a2 
    j transpose_loop1

return1:

    jr $ra

.data
    matrix: .space 1000
    new_line: .asciiz "\n"
    space: .asciiz " "
    normalM: .asciiz "Normal Matrix:\n"
    transposeM: .asciiz "Transpose Matrix: \n"
    row: .asciiz "Enter rows: "
    column: .asciiz "Enter columns: "
    a_: .asciiz "Enter a: "
    b_: .asciiz "Enter b: "