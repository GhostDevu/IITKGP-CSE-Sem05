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
    li $s1, 4
    mul $s1,$s0,$s1

    la $a0, arr
    move $a1, $s0

    la $a0, newline
    li $v0, 4
    syscall

    la $a0, start
    li $v0, 4
    syscall

    jal print_arr

    la $a0, newline
    li $v0, 4
    syscall

    jal Heapsort

    la $a0, end
    li $v0, 4
    syscall

    jal print_arr

    
exit:
    li        $v0, 10   
    syscall

Heapify:
    addi $sp, $sp, -16
    sw $a2, 12($sp)
    sw $a1, 8($sp)
    sw $a0, 4($sp)
    sw $ra, 0($sp)

    # largest $s3 i $a2 n $a1
    move $s3, $a2
    li $t0,2

    # l $t1
    mul $t1,$a2,$t0
    addi $t1,$t1,1

    # r $t2
    mul $t2,$a2,$t0
    addi $t2,$t2,2

    li $t0,4

    bge $t1,$a1,skipcond1
        mul $t3,$t1,$t0
        mul $t5,$s3,$t0
        lw $t6,arr($t3)
        lw $t7,arr($t5)
        ble $t6,$t7,skipcond1
            move $s3,$t1

    skipcond1:

    bge $t2,$a1,skipcond2
        mul $t4,$t2,$t0
        mul $t5,$s3,$t0
        lw $t6,arr($t4)
        lw $t7,arr($t5)
        ble $t6,$t7,skipcond2
            move $s3,$t2

    skipcond2:

    beq $s3,$a2, no_swap
        swap:
            mul $t4,$s3,$t0
            mul $t5,$a2,$t0

            lw $t6,arr($t4)
            lw $t7,arr($t5)

            sw $t6,arr($t5)
            sw $t7,arr($t4)

        move $a0,$a0
        move $a1,$a1
        move $a2,$s3

        jal Heapify

    no_swap:

exitHeapify:
    lw $ra, 0($sp)
    addi $sp, $sp, 16
    jr $ra



Heapsort:
    addi $sp, $sp, -12
    sw $a1, 8($sp)
    sw $a0, 4($sp)
    sw $ra, 0($sp)

    li $t0,2
    div $a1,$t0
    mflo $s2
    addi $s2, $s2, -1
    for:
        blt $s2,$zero, exitHeapsort

        move $a0,$a0
        move $a1,$a1
        move $a2,$s2
        jal Heapify

        addi $s2,$s2,-1
        j for 

exitHeapsort:
    lw $ra, 0($sp)
    addi $sp, $sp, 12
    jr $ra


print_arr:
    la $t0, arr
    la $t2, size
    lw $t1, 0($t2)

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



.data
    space: .asciiz " "
    # CHANGE SIZE HERE
    arr: .word 0:20
    size: .word 20

    # Prompts 
    arrhead: .asciiz "Enter the array:\n"
    arrit: .asciiz "Enter Number#"
    seperator: .asciiz ":"
    start: .asciiz "ORIGINAL ARRAY:"
    newline: .asciiz "\n"
    end: .asciiz "MAX HEAP:"