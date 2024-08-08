# group number-> 29
# Devanshu Agrawal 22CS30066
# More Aayush Babasaheb 22CS30063

# LOGIC - concept of Binary Exponentiation


.text
start: # Jumping to Main label
    j main

main:

    # Taking input for M($s0),N($s1),d($s2)
    la $a0, inputM
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $s0,$v0

    la $a0, inputN
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $s1,$v0

    la $a0, inputd
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $s2,$v0

    move $a0,$s2
    jal DecimalToBinary

    la $a0, prompt1
    li $v0, 4
    syscall
    jal print_binary
    
    la $a0, newline
    li $v0, 4
    syscall

    move $a0,$s0
    move $a1,$s1
    move $a2,$s2
    jal modExp
    move $s3,$v0

    la $a0,prompt2
    li $v0, 4
    syscall
    move $a0,$s3
    li $v0, 1
    syscall
    
exit:
    li $v0, 10   
    syscall

# ModExp
modExp:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)

    # $s3 ----- S , store the answer that is to be returned
    li $s3,1

    # $s4 ----- loop iterator, s4 keeps track of di
    li $s4,0

    # $s7 ----- base, store the squaring term of binary exponentiation
    move $s7,$a0

    # $s5 ---- stores the size 
    # $s6 ---- stores the array access point
    li $s5,31
    li $t0,4
    mul $s6,$s5,$t0

    addi $s5,$s5,1

    whileModExp:
        # Conddtion to check if all bits have been dealt with
        beq $s4,$s5,exitWhileModExp

        lw $t0,binary($s6)

        # Check if we need the to multiply now
        beq $t0,$zero,skip

            # Multiply
            move $a0,$s3
            move $a1,$s7    
            jal Muliply
            move $s3,$v0

        skip:
        # Squaring 
        move $a0,$s7
        jal Square
        move $s7,$v0

        # updating access iterator
        addi $s6,$s6,-4
        addi $s4,$s4,1

        # loop
        j whileModExp

    exitWhileModExp:
    # putting return value
    move $v0,$s3

returnModExp:
    lw $ra, 0($sp)
    addi $sp, $sp, 12
    jr $ra


# Mod function
mod: 
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)

    move $t0,$a0
    div $t0,$s1

    mfhi $v0 

returnMod:
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra


# Multiply Function
Muliply:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)

    move $t0,$a0
    move $t1,$a1

    multu $t0, $t1

    mflo $a0

    jal mod

    move $v0,$v0

exitMultiply:
    lw $ra, 0($sp)
    addi $sp, $sp, 12
    jr $ra



# Square function
Square:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)

    move $t0,$a0

    multu $t0,$t0

    mflo $a0

    jal mod

    move $v0,$v0

returnSquare:
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra

# Decimal to Binary function
DecimalToBinary:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)


    move $t0,$a0

    li $t3,31
    li $t1,4
    mul $t3,$t3,$t1


    li $t1,1
    
    whileDTB:
        beq $t0,$zero, exitWhileDTB
        and $t2,$t0,$t1
        sw $t2,binary($t3)

        addi $t3,$t3,-4
        srl $t0,$t0,1

        j whileDTB

    exitWhileDTB:

exitDecimalToBinary:
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra

# printing array
print_binary:
    la $t0, binary
    la $t2, size
    lw $t1, 0($t2)

    j loop

loop:
    beq $t1, $zero, return
    li $v0, 1
    lw $a0, 0($t0)
    syscall
    addi $t0, $t0, 4
    addi $t1, $t1, -1

    j loop
    
return:
    jr $ra


.data
    
    # CHANGE SIZE HERE
    binary: .word 0:32
    size: .word 32
    # Prompts 
    inputM: .asciiz "Enter M:"
    inputN: .asciiz "Enter N:"
    inputd: .asciiz "Enter d:"
    prompt1: .asciiz "The exponent in binary is "
    prompt2: .asciiz "The answer of M raised to power d against mod N is: "
    newline: .asciiz "\n"
