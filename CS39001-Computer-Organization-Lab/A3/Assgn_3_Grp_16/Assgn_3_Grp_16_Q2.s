
# Computer Organization Laboratory (CS39001)
# Semester 05 (Autumn 2021-22)
# Assignment 03 -- Question 02
#   [ This program finds the kth largest element in an array of integers ]
# Group No. 16
#      Hritaban Ghosh (19CS30053)
#      Nakul Aggarwal (19CS10044)

# ++++ DATA SEGMENT ++++ #
# Definitions of all the string literals that are printed by the program through system calls
.data
prompt_for_array:
    .asciiz     "Enter 10 elements of the array : "
prompt_for_k:
    .asciiz     "Enter the value of k : "
print_sorted_array:
    .asciiz     "The array in acsending order is : "
print_kth_largest:
    .asciiz     "-th largest element of the array is : "
out_of_range_error:
    .asciiz     " [ ERROR : k must be from 1 to 10 ] "
newline:
    .asciiz     "\n"
white_space:
    .asciiz     " "

    .align      5       # Align the next datum on a 2^5=32 byte boundary. This aligns the next value on a word boundary 
array:
    .space      40      # Create a empty 40-byte memory, an integer array of fixed size=10.


# ++++ TEXT SEGMENT ++++ #

.text
.globl main
main:

    # +++ main PROGRAM VARIABLES +++ #
    # $t0 <-- Iterator i 
    # $t1 <-- Base address of array
    # $t2 <-- k 

    # Print prompt asking the user to enter the array elements
    la $a0, prompt_for_array
    li $v0, 4
    syscall

    la $a0, newline
    li $v0, 4
    syscall

    move $t0, $zero     # Intialize Iterator to 0 for scanning

scan_loop:      # Loop for scanning the 10 elements of the array

    # Check if end of array is reached
    # If i == 40, then break out of the scanning loop 
    beq $t0, 40, break_out_of_scan_loop 

    # Load the base address of array in $t1
    la $t1, array

    # Calculate the effective address where the entered element is to be stored
    add $t1, $t1, $t0   # array+i

    # Scan the element and store it in memory
    li $v0, 5
    syscall
    sw $v0, ($t1)

    # Increment the Iterator
    addi $t0, $t0, 4    # i <-- i+4
    
    j scan_loop # Keep looping

break_out_of_scan_loop:

    la $a0, newline
    li $v0, 4
    syscall

    # Print prompt asking the user to enter the value of k
    la $a0, prompt_for_k
    li $v0, 4
    syscall

    # Scan the value of k and store in $t2
    li $v0, 5
    syscall
    move $t2, $v0

    # Sanity checking for the value of k to reside in [1,10]
    blt $t2, 1, out_of_range
    bgt $t2, 10, out_of_range

    # Pass the arguments to the find_k_largest procedure
    la $t0, array               # Load the base address of array
    move $a0, $t0           # Argument 1 <-- array
    addi $a1, $zero, 10     # Argument 2 <-- 10 (Number of elements in the array)
    move $a2, $t2           # Argument 3 <-- k

    # Call the find_k_largest procedure
    jal find_k_largest

    j exit      # Jump to exit

find_k_largest:
    # +++ find_k_largest Procedure arguments +++
    # $a0 <-- Base Address of array
    # $a1 <-- n <- Number of elements in the array
    # $a2 <-- k

    # +++ find_k_largest PROGRAM VARIABLES +++ 
    # $sp <-- Stack pointer
    # $ra <-- Return address 
    # $t0 <-- Base Address of array
    # $t1 <-- n <- Number of elements in the array
    # $t2 <-- k

    addi $sp, $sp, -4       # Make room on stack for one registers
    sw $ra, 0($sp)          # Save the return address on the stack

    # Save all the variables
    move $s0, $a0           # Base Address of array
    move $s1, $a1           # n <- Number of elements in the array 
    move $s2, $a2           # k 

    # Pass the arguments to the find_k_largest procedure
    move $a0, $s0           # Argument 1 <-- array
    move $a1, $s1           # Argument 2 <-- n (Number of elements in the array)

    # Call the sort_array procedure
    jal sort_array

    # Get the variables 
    move $t0, $s0
    move $t1, $s1
    move $t2, $s2

    la $a0, newline
    li $v0, 4
    syscall

    # Print the sorted array
    la $a0, print_sorted_array
    li $v0, 4
    syscall
    
    la $a0, newline
    li $v0, 4
    syscall

    move $t3, $zero     # Intialize Iterator i to 0 for printing

print_loop:     # Loop for printing the 10 elements of the array
    
    # Check if end of array is reached
    # If i == 40, then break out of the scanning loop 
    beq $t3, 40, break_out_of_print_loop

    # Calculate the effective address where the entered element is to be stored
    add $t4, $t0, $t3   # array+i

    # Print the element
    lw $a0, ($t4)
    li $v0, 1
    syscall

    # Print a whitespace
    la $a0, white_space
    li $v0, 4
    syscall

    # Increment the Iterator
    addi $t3, $t3, 4    # i <-- i+4
    
    j print_loop    # Keep looping

break_out_of_print_loop:
    
    la $a0, newline
    li $v0, 4
    syscall

    # Print the kth-largest element in the array
    la $a0, newline
    li $v0, 4
    syscall

    # $t2 has k 
    move $a0, $t2
    li $v0, 1
    syscall

    la $a0, print_kth_largest
    li $v0, 4
    syscall

    sub $t5, $t1, $t2       # i <-- Calculate n - k

    sll $t5, $t5, 2         # Calculate i*4

    # Calculate the effective address where the entered element is to be stored
    add $t5, $t0, $t5   # array+i

    # Print the element
    lw $a0, ($t5)
    li $v0, 1
    syscall

    lw $ra, 0($sp)      # Load the return address from stack
    addi $sp, $sp, 4    # Restore stack pointer
    jr $ra
    
sort_array:
    # +++ sort_array Program Arguments +++ 
    # $a0 <-- Base Address of array
    # $a1 <-- n <- Number of elements in the array

    # +++ sort_array PROGRAM VARIABLES +++ 
    # $sp <-- Stack pointer
    # $ra <-- Return address
    # $t0 <-- Base Address of array 
    # $t1 <-- n <- Number of elements in the array
    # $t2 <-- Iterator j
    # $t3 <-- array+j
    # $t4 <-- temp = *(array+j)
    # $t5 <-- i = j-4
    # $t6 <-- array+i
    # $t7 <-- *(array+i)

    addi $sp, $sp, -16      # Make room on stack for four registers
    sw $ra, 12($sp)          # Save the return address on the stack
    sw $s0, 8($sp)          # Store $s0 on the stack
    sw $s1, 4($sp)          # Store $s1 on the stack
    sw $s2, 0($sp)          # Store $s2 on the stack

    move $t0, $a0           # Base Address of array
    move $t1, $a1           # n <- Number of elements in the array 

    # Calculate n*4 and store in $t1     
    sll $t1, $t1, 2

    addi $t2, $zero, 0      # j <-- Intialize Iterator to 0

for_loop:

    # Increment j   
    add $t2, $t2, 4         # j <-- j+4    

    beq $t2, $t1, end       # Check if Iterator j is equal to n*4

    add $t3, $t0, $t2       # Load address array+j
    lw $t4, ($t3)           # temp = *(array+j)

    addi $t5, $t2, -4       # i <-- j-4

while_loop:
    
    blt $t5, $zero, for_loop    # i > 0

    add $t6, $t0, $t5           # Calculate array+i
    lw $t7, ($t6)               # Load the value of *(array+i) from memory
    blt $t7, $t4, for_loop      # *(array+i) < temp

    addi $t6, $t6, 4            # Calculate array+i+4
    sw $t7, ($t6)               # *(array+i+4) = *(array+i)

    # Decrement i
    addi $t5, $t5, -4           # i = i-4

    add $t6, $t0, $t5           # Calculate array+i
    addi $t6, $t6, 4            # Calculate array+i+4
    sw $t4, ($t6)               # *(array+i+4) = temp

    j while_loop                # Keep looping

end:
    lw $ra, 12($sp)     # Load the return address from stack
    lw $s0, 8($sp)      # Restore saved variable back from the stack
    lw $s1, 4($sp)      # Restore saved variable back from the stack
    lw $s2, 0($sp)      # Restore saved variable back from the stack
    addi $sp, $sp, 16   # Restore stack pointer
    jr $ra              # Jump to return address

out_of_range:
    
    la $a0, newline
    li $v0, 4
    syscall
    
    # Print out of range error because sanity checking failed
    la $a0, out_of_range_error
    li $v0, 4
    syscall 

exit:

    # exit the program
    li $v0, 10
    syscall