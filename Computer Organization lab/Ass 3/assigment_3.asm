# group number-> 29
# Devanshu Agrawal 22CS30066
# More Aayush Babasaheb 22CS30063



.data   
    prompt: .asciiz "Enter number "
    original: .asciiz "Original array: "
    result: .asciiz "Heapifyied array : "
    newline: .asciiz "\n"
    space: .asciiz " "
    arr: .word 0:10
    size: .word 10
    arrit: .asciiz "Enter Number#"
    seperator: .asciiz ":"
    arrhead: .asciiz "Enter the array:\n"

.text

start: # Jumping to Main label
    j main

main:
    la $a0, arrhead
    li $v0, 4
    syscall

    lw $s0,size

    li $t0, 0
    li $t1, 0
    jal input

    la $a0, original
    li $v0, 4
    syscall

    jal print_arr
    lw $s2, size
    li $t0, 2
    div $s2, $t0
    mflo $s2
    addi $s2, $s2, -1
    j initHeapify



initHeapify:
    blt $s2, $zero, finishHeap
    la $a0, arr
    lw $a1, size
    move $a2, $s2
    
    jal Heapify

    addi $s2, $s2, -1
    j initHeapify
    
Heapify:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)

    move $s3, $a2
    move $s4, $a2
    move $s5, $a2
    li $t0, 2
    mult $s4, $t0
    mflo $s4
    mult $s5, $t0
    mflo $s5
    addi $s4, $s4, 1
    addi $s5, $s5, 2
    
    bge $s4, $a1, skip1
    li $t0, 4
    mult $s4, $t0
    mflo $t0
    li $t1, 4
    mult $s3, $t1
    mflo $t1
    lw $t2, arr($t0)
    lw $t3, arr($t1)
    bge $t3, $t2, skip1
    move $s3, $s4

    skip1:

    bge $s5, $a1, skip2
    li $t0, 4
    mult $s5, $t0
    mflo $t0
    li $t1, 4
    mult $s3, $t1
    mflo $t1
    
    lw $t2, arr($t0)
    lw $t3, arr($t1)
    bge $t3, $t2, skip2
    move $s3, $s5

    skip2:

    beq $s3, $a2, skip3

    li $t1, 4
    mult $a2, $t1
    mflo $t1
    li $t2, 4
    mult $s3, $t2
    mflo $t2

    lw $t3,arr($t1)
    lw $t4,arr($t2)
    sw $t4,arr($t1)
    sw $t3,arr($t2)
    
    move $a2, $s3
    jal Heapify

    skip3:

    lw $t0, 0($sp)
    addi $sp, $sp, 16
    jr $t0

finishHeap:
    la $a0, newline
    li $v0, 4
    syscall

    la $a0, result
    li $v0, 4
    syscall

    jal print_arr
    j exit

input:
    beq $t0,$s0,exitInput

    la $a0, arrit
    li $v0, 4
    syscall

    addi $t0,1
    move $a0, $t0 
    li $v0, 1
    syscall

    la $a0, seperator
    li $v0, 4
    syscall

    li $v0, 5
    syscall

    sw $v0,arr($t1)
    addi $t1,4

    j input
    
exitInput:
    lw $s0,size
    li $t0, 0
    li $t1, 0
    j return
    
print_arr:
    la $t0, arr
    lw $t1, size

    j loop

loop:
    beq $t1, $zero, return
    li $v0, 1
    lw $a0, 0($t0)
    syscall

    la $a0, space
    li $v0, 4
    syscall

    addi $t0, $t0, 4
    addi $t1, $t1, -1

    j loop
    
return:
    jr $ra

exit:    
    li $v0, 10      
    syscall





    