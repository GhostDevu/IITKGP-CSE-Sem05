# Group-29
# Devanshu Agrawal - 22CS30066
# More Aayush Babasaheb - 22CS30063

# LOGIC - 
# do Bubble Sort and get kth from last and front

.text
main:
    la $a0, arrhead
    li $v0, 4
    syscall

    lw $s0,size

    li $t0, 0
    li $t1, 0

while:
    beq $t0,$s0,exitWhile

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

    j while
    
exitWhile:
    lw $s0,size
    li $t0, 0
    li $t1, 0

    jal Bubblesort

retrieveValue:
    la $a0, ask_k
    li $v0, 4
    syscall

    li $v0, 5
    syscall

    move $t0,$v0
    addi $t1,$t0,-1

    lw $s0,size
    li $s1,4
    mul $s0,$s0,$s1
    mul $t1,$t1,$s1

    la $a0,lowest
    li $v0,4
    syscall

    lw $a0,arr($t1)
    li $v0,1
    syscall

    la $a0,newline
    li $v0,4
    syscall

    la $a0,greatest
    li $v0,4
    syscall

    addi $s0,$s0,-4
    sub $t2,$s0,$t1

    lw $a0,arr($t2)
    li $v0,1
    syscall


exitMain:
    li $v0,10
    syscall

Bubblesort:
    lw $s0,size
    li $s1,4
    mul $s0,$s0,$s1
    li $t0,0

    outerLoop:
        beq $t0,$s0, exitSort
        addi $t1,$zero,0
        add $s1,$s0,$zero
        sub $s1, $s1, 4

        InnerLoop:

            bge $t1,$s1,exitInner
            addi $t2,$t1,4

            lw $t3,arr($t1)
            lw $t4,arr($t2)

            ble $t3,$t4, no_swap

            sw $t4,arr($t1)
            sw $t3,arr($t2)

            no_swap:
            addi $t1,$t1,4
            j InnerLoop

        exitInner:
            addi $t0,$t0,4
            j outerLoop

    exitSort:
        jr $ra


.data
    # CHANGE SIZE HERE
    arr: .word 0:10 
    size: .word 10

    # Prompts 
    arrhead: .asciiz "Enter the array:\n"
    arrit: .asciiz "Enter Number#"
    seperator: .asciiz ":"
    ask_k: .asciiz "Enter K="
    lowest: .asciiz "lowest="
    newline: .asciiz "\n"
    greatest: .asciiz "greatest="
