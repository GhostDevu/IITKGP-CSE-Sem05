.data
msg1: .asciiz "Enter the value of M : "
msg2: .asciiz "Enter the value of d : "
msg3: .asciiz "Enter the value of N : "
msg4: .asciiz "Binary representation: "
array: .word 0:32
size: .word 32
.text
.globl main
main:
    # Input for M
    la $a0, msg1
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $t0, $v0

    # Input for d
    la $a0, msg2
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    # Input for N
    la $a0, msg3
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $t2, $v0

    # Convert d to binary and store it
    move $a0, $t1  # $a0 points to where the binary digits will be stored
    jal DecimalToBinary

    # Print the binary representation
    la $a0, msg4
    li $v0, 4
    syscall

    jal print_binary

    li $v0,10
    syscall

print_binary:
    la $t0, array
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

# Function to convert decimal number in $t3 to binary
DecimalToBinary:
    # Determine the number of bits needed
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)

    move $t3,$a0
    li $t4, 31
    sll $t6,$t4,2
    addi $t4,$t4,1

convert_loop:
    bnez $t3, check_bit   # Check if $t3 is not zero
    
    lw $ra, 0($sp)       # Restore the return address
    addi $sp, $sp, 4     # Deallocate stack space
    jr $ra               # Return

check_bit:
    andi $t5, $t3, 1     # Extract the LSB 
    sw $t5,array($t6)
    addi $t4, $t4, -1 
    addi $t6,$t6,-4
    j convert_loop  


