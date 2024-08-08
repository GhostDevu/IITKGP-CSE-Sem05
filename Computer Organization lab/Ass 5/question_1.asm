# Group no 29
# More Aayush Babasaheb 22CS30063
# Devanshu Agrawal 22CS30066


.text
.globl main

main:
    
    li $s0,0

    la $a0,prompt
    li $v0,4
    syscall


character_wise_read:
    li $v0, 12
    syscall

    checker:
        beq $v0,10,end_read
        addi $sp,$sp,-1
        sb $v0,0($sp)
        addi $s0,$s0,1
        j character_wise_read

    end_read:
    
    la $a0,end_prompt
    li $v0,4
    syscall

print_reverse:
    beq $s0,$zero,done_print
    lb $a0,0($sp)
    li $v0,11
    syscall

    addi $sp,$sp,1
    addi $s0,$s0,-1

    j print_reverse

done_print:
    exit:
        li $v0,10
        syscall


.data
prompt: .asciiz "Enter the String: "
end_prompt: .asciiz "Reversed String: "