
# Computer Organization Laboratory (CS39001)
# Semester 05 (Autumn 2021-22)
# Assignment 04 -- Problem 01
#   [ This program computes determinant of a n x n matrix using a recursive procedure ]
# Group No. 16
#      Hritaban Ghosh (19CS30053)
#      Nakul Aggarwal (19CS10044)

# ++++ DATA SEGMENT ++++ #
# Definitions of all the string literals that are printed by the program through system calls
.data
prompt:         .asciiz " Enter four positive integers (n, a, r and m) : "
determinant:    .asciiz " Final determinant of matrix A is "
error_msg:      .asciiz " [ ERROR : Sanity check failed. All integers must be positive. ] "
overflow_msg:   .asciiz " [ ERROR : GP terms overflowed. ] "
arrow:          .asciiz "-->"
tab:            .asciiz "\t"
double_space:   .asciiz "  "
newline:        .asciiz "\n"
matrix_A:       .asciiz "\n   +++ MATRIX A +++\n"

# ++++ TEXT SEGMENT ++++ #
# +++ PROGRAM VARIABLES +++ #
#   'n' ($s0) -- number of rows and columns in square matrix A
#   'a' ($s1) -- first term of GP
#   'r' ($s2) -- common ratio of GP
#   'A' ($s3) -- starting address of nxn array A
#   'm' ($s4) -- the term by which we need to take modulus
.text
.globl main
main:
    # Print prompt asking the user to enter 4 positive integers -- n, a, r, m
    jal initStack
    la $a0, prompt
    li $v0, 4
    syscall
    
    li $v0, 5
    syscall
    move $s0, $v0   # scanned the value of 'n'
    
    li $v0, 5
    syscall
    move $s1, $v0   # scanned the value of 'a'
    
    li $v0, 5
    syscall
    move $s2, $v0   # scanned the value of 'r'

    li $v0, 5
    syscall
    move $s4, $v0   # scanned the value of 'm'
    
    # sanity check -- force exit if any of n, a, r, m is non-positive
    ble $s0, $zero, error
    ble $s1, $zero, error
    ble $s2, $zero, error
    ble $s4, $zero, error

    mul $a0, $s0, $s0   # Compute the value n.n (size of square matrix)
    sll $a0, $a0, 2     # 4.n.n -- memory required to store A

    jal mallocInStack   # allocate 4.n.n bytes for stack A
    move $s3, $v0       # and return the starting address in $v0

    li $t0, 0   # outer loop iterator 'i' (row index) -- loops over the rows of matrix A
    div $s1, $s4    # division stores the resultant remainder in HI
    mfhi $t3        # $t3 <-- remainder when first term 'a' is divided by 'm' (move remainder from HI to $t3)
    # INVARIANT -- $t3 ('t') always stores the next term in GP modulo 'm' where 
    #              GP is defined by the first term 'a' and common ratio 'r'
    # 't' is intialized to a%m

# +++ PROGRAM VARIABLES +++ #
#   'i' ($t0)
#   'j' ($t1)
#   't' ($t3)
populate_outer_loop:    # loop over rows of A (outer loop)
    bge $t0, $s0, break_loop    # break out of outer loop if (i >= n)
    li $t1, 0   # inner loop iterator 'j' (column index) -- 
                # loops over the columns of a particular row in matrix A

populate_inner_loop:    # loop over columns of A (inner loop)
    bge $t1, $s0, reiterate_populate_outer_loop    # break out of inner loop if (j >= n) and re-iterate over outer loop
    mul $t2, $t0, $s0
    add $t2, $t2, $t1   # (i * n + j) -- position of (i,j)th element of A wrt its starting 
                        # address in the row-major-flattened format of A
    sll $t2, $t2, 2
    sub $t2, $s3, $t2   # address of A[i][j] on the stack
    sw $t3, 0($t2)      # populate A[i][j] with the current term 't' in the sequence

    div $s2, $s4        # division stores the resultant remainder in HI
    mfhi $t4            # $t4 <-- r % m         (move remainder from HI to $t4)
    mul $t3, $t3, $t4   # t <-- t * (r % m)
    div $t3, $s4        # division stores the resultant remainder in HI
    mfhi $t3            # t <-- t % m           (move remainder from HI to $t3)
    # [ INVARIANCE OF $t3 MAINTAINED ]

    blt $t3, $zero, overflow    # check if the next term in the sequence overflows (if $t3 < 0)
    
    addi $t1, $t1, 1
    j populate_inner_loop   # re-iterate over inner loop for the next column of A in the same row

overflow:   # GP term overflows the maximum value that can be stored in a 32-bit register
    # print an appropriate error message
    la $a0, overflow_msg
    li $v0, 4
    syscall

    # de-allocate space from stack for the matrix A
    mul $t0, $s0, $s0
    sll $t0, $t0, 2     # 4.n.n -- total bytes space occupied by matrix A
    add $sp, $sp, $t0   # memory freed

    j exit  # exit the program

reiterate_populate_outer_loop:
    addi $t0, $t0, 1
    j populate_outer_loop  # re-iterate over outer loop for the next row of matrix A

break_loop: # population of matrix A in row-major fashion with elements in GP is done
    la $a0, matrix_A
    li $v0, 4
    syscall

    # set the arguments and call "printMatrix" procedure to print matrix A
    move $a0, $s0
    move $a1, $s3
    jal printMatrix

    # set the arguments and call "recursive_Det" procedure to calculate determinant of matrix A
    move $a0, $s0
    move $a1, $s3
    jal recursive_Det
    move $t0, $v0

    la $a0, newline
    li $v0, 4
    syscall

    la $a0, newline
    li $v0, 4
    syscall

    # Print the message for final determinant
    la $a0, determinant
    li $v0, 4
    syscall
    
    # Print the determinant of matrix A
    move $a0, $t0
    li $v0, 1
    syscall

    # de-allocate space from stack for the matrix A
    mul $t0, $s0, $s0
    sll $t0, $t0, 2     # 4.n.n -- total bytes space occupied by matrix A
    add $sp, $sp, $t0   # memory freed

    j exit  # exit the program

# +++ PROCEDURE ARGUEMENTS +++ #
#   'n' ($a0) -- number of rows and columns in square matrix M
#   'M' ($a1) -- starting address of nxn array M
printMatrix:    # print the matrix M in a proper two-dimensional format in a row-major fashion
    # [ Function Type : Iterative ]

    move $t0, $ra
    move $t1, $a0

    # initialize stack-frame (remember old $fp and set $fp for the current frame)
    jal initStack

    # push values of callee-saved registers ($s0-$s4, $ra whichever reqd.) onto the stack
    move $a0, $s0
    jal pushToStack
    move $a0, $s1
    jal pushToStack
    move $a0, $s2
    jal pushToStack
    move $a0, $s3
    jal pushToStack
    move $a0, $s4
    jal pushToStack
    move $a0, $t0       # store original return address onto the stack
    jal pushToStack
    
    move $a0, $t1       # $a0 <-- n

    li $t0, 0  # outer loop iterator 'i' (row index) -- loops over the rows of matrix M

# +++ PROCEDURE VARIABLES +++ #
#   'i' ($t0)
#   'j' ($t1)
print_outer_loop:    # loop over rows of M (outer loop)
    bge $t0, $a0, print_return    # break out of outer loop if (i >= n)

    # introduce appropriate white-spaces for formatting
    move $t1, $a0
    la $a0, newline
    li $v0, 4
    syscall
    la $a0, double_space
    li $v0, 4
    syscall
    move $a0, $t1

    li $t1, 0   # inner loop iterator 'j' (column index) -- 
                # loops over the columns of a particular row in matrix M

print_inner_loop:    # loop over columns of M (inner loop)
    bge $t1, $a0, reiterate_print_outer_loop    # break out of inner loop if (j >= n) and re-iterate over outer loop
    
    mul $t2, $t0, $a0
    add $t2, $t2, $t1   # (i * n + j) -- position of (i,j)th element of M wrt its starting 
                        # address in the row-major-flattened format of M
    sll $t2, $t2, 2
    sub $t2, $a1, $t2   # address of M[i][j] on the stack
    lw $t2, 0($t2)      # $t2 <-- value of M[i][j]
    
    move $t3, $a0

    # print the value of M[i][j]
    move $a0, $t2
    li $v0, 1
    syscall

    # followed by a tab space for formatting
    la $a0, tab
    li $v0, 4
    syscall

    move $a0, $t3

    addi $t1, $t1, 1
    j print_inner_loop   # re-iterate over inner loop for the next column of M in the same row

reiterate_print_outer_loop:
    addi $t0, $t0, 1
    j print_outer_loop  # re-iterate over outer loop for the next row of matrix M

print_return:   # de-allocate memory from stack frame after restoring the values in callee-saved registers
    # restore the values of all #s0-$s4, $ra (whichever required) registers
    jal popFromStack
    move $ra, $v0
    move $t0, $ra

    jal popFromStack
    move $s4, $v0
    jal popFromStack
    move $s3, $v0
    jal popFromStack
    move $s2, $v0
    jal popFromStack
    move $s1, $v0
    jal popFromStack
    move $s0, $v0
    
    jal destructFrame   # call "destructFrame" procedure to restore the value of $fp
    move $ra, $t0
    jr $ra              # return to caller address

# +++ PROCEDURE ARGUEMENTS +++
#   'val' ($a0) -- 'n' (dimension of matrix) 
#   'address' ($a1) -- starting address of the nxn matrix M
# +++ PROCEDURE RETURN VALUES +++
#   'val' ($v0) -- determinant of M
recursive_Det:  # computes the determinant of a square matrix recursively
    # [ Function Type : Recursive ]

    move $t0, $ra
    move $t1, $a0

    # initialize stack-frame (remember old $fp and set $fp for the current frame)
    jal initStack

    # push values of callee-saved registers ($s0-$s4, $ra whichever reqd.) onto the stack
    move $a0, $s0
    jal pushToStack
    move $a0, $s1
    jal pushToStack
    move $a0, $s2
    jal pushToStack
    move $a0, $s3
    jal pushToStack
    move $a0, $s4
    jal pushToStack
    move $a0, $t0       # store original return address onto the stack
    jal pushToStack
    
    move $a0, $t1       # $a0 <-- n

    lw $t0, ($a1)           # Stores the determinant of matrix of size 1x1
    li $t1, 1
    beq $a0, $t1, det_end   # If n==1 then return form the procedure

    li $t0, 0           # Stores the determinant, initialized to 0
    li $t1, -1          # Stores the (-1)^(i+j) factor for calculating the determinant
    li $t2, 0           # loop iterator j intialized to 0

det_loop:
    bge $t2, $a0, det_end # if (j>=n) then goto det_end

    li $t3, -1
    mul $t1, $t1, $t3   # Update the factor (-1)^(i+j)

    li $t3, 0           # i 
    add $t3, $t3, $t2   # (i * n + j) -- position of (i,j)th element of M wrt its starting 
                        # address in the row-major-flattened format of M
    sll $t3, $t3, 2
    sub $t3, $a1, $t3   # address of M[i][j] on the stack
    lw $t3, 0($t3)      # $t3 <-- value of M[i][j]

    mul $t3, $t3, $t1   # M[i][j]*(-1)^(i+j)

    # $a0, $a1, $t0, $t1, $t2, and $t3 are to be saved onto the stack before recursive call.
    move $t4, $a0

    # Save the current machine status onto the stack
    move $a0, $t4       
    jal pushToStack
    move $a0, $a1       
    jal pushToStack
    move $a0, $t0       
    jal pushToStack
    move $a0, $t1       
    jal pushToStack
    move $a0, $t2       
    jal pushToStack
    move $a0, $t3      
    jal pushToStack

    # +++ CREATE THE MINOR MATRIX Mrc where r = i and c = j +++ #

    # Get current i as r and j as c in $t5 and $t6 respectively
    move $t5, $0
    move $t6, $t2

    # Create the minor Mrc
    move $t0, $t4       # $t0 <-- n

    addi $t1, $t0, -1   # Compute n - 1
    mul $t2, $t1, $t1   # Compute the value (n - 1).(n - 1) (size of square matrix)
    sll $t2, $t2, 2     # 4.(n - 1).(n - 1) -- memory required to store Mrc

    move $a0, $t2
    jal mallocInStack   # allocate 4.(n - 1).(n - 1) bytes for stack Mrc
    move $t3, $v0       # and return the starting address in $v0

    move $t4, $t3       # initialize $t4 with address of Mrc

    li $t2, 0   # outer loop iterator 'i' (row index) -- loops over the rows of matrix Mrc

outer_loop_for_minor:
    bge $t2, $t0, break_minor_loop    # break out of outer loop if (i >= n)

    beq $t2, $t5, reiterate_outer_loop_for_minor      # if i == r then go to reiterate_outer_loop_for_minor

    li $t7, 0   # inner loop iterator 'j' (column index) -- 
                # loops over the columns of a particular row in matrix Mrc

inner_loop_for_minor:    # loop over columns of Mrc (inner loop)
    bge $t7, $t0, reiterate_outer_loop_for_minor    # break out of inner loop if (j >= n) and re-iterate over outer loop

    beq $t7, $t6, reiterate_inner_loop_for_minor    # if j == c then go to reiterate_inner_loop_for_minor

    mul $t8, $t2, $t0   # i * n
    add $t8, $t8, $t7   # (i * n + j) -- position of (i,j)th element of A wrt its starting 
                        # address in the row-major-flattened format of A

    sll $t8, $t8, 2
    sub $t8, $a1, $t8   # address of A[i][j] on the stack
    lw $t9, 0($t8)      # Load the value in A[i][j]

    sw $t9, 0($t4)      # Store A[i][j] in Mrc

    addi $t4, $t4, -4   # next adrress in Mrc

    addi $t7, $t7, 1    # Increment j
    j inner_loop_for_minor   # re-iterate over inner loop for the next column of A in the same row

reiterate_inner_loop_for_minor:
    addi $t7, $t7, 1
    j inner_loop_for_minor  # re-iterate over inner loop for the next column of matrix A

reiterate_outer_loop_for_minor:
    addi $t2, $t2, 1
    j outer_loop_for_minor  # re-iterate over outer loop for the next row of matrix A

break_minor_loop: # population of matrix Mrc in row-major fashion with elements of A is done
    
    # Save $t1 which contains the value n-1
    move $s0, $t1

    # +++ RECURSIVELY CALL recursive_Det ON THE MINOR MATRIX Mrc where r = i and c = j +++ #

    # Move n-1($t1) to $a0 and Move the address of minor($t3) to $a1
    move $a0, $t1
    move $a1, $t3
    jal recursive_Det
    move $t8, $v0

    mul $t2, $s0, $s0   # Compute the value (n - 1).(n - 1) (size of square matrix)
    sll $t2, $t2, 2     # 4.(n - 1).(n - 1) -- memory required to store Mrc
     
    add $sp, $sp, $t2   # restore stack pointer, free memory

    # Retrieve the current machine status onto the stack
    jal popFromStack
    move $t3, $v0
    jal popFromStack
    move $t2, $v0
    jal popFromStack
    move $t1, $v0
    jal popFromStack
    move $t0, $v0
    jal popFromStack
    move $a1, $v0
    jal popFromStack
    move $t4, $v0

    move $a0, $t4

    mul $t3, $t3, $t8   # (-1)^(i+j)*M[i][j]*Mij
    add $t0, $t0, $t3   # Update the determinant

    addi $t2, $t2, 1    # Increment the iterator j
    j det_loop

det_end:
    # de-allocate memory from stack frame after restoring the values in callee-saved registers
    # restore the values of all #s0-$s4, $ra (whichever required) registers
    jal popFromStack
    move $ra, $v0
    move $t1, $ra

    jal popFromStack
    move $s4, $v0
    jal popFromStack
    move $s3, $v0
    jal popFromStack
    move $s2, $v0
    jal popFromStack
    move $s1, $v0
    jal popFromStack
    move $s0, $v0
    
    jal destructFrame   # call "destructFrame" procedure to restore the value of $fp
    move $v0, $t0       # $t0 has the determinant
    move $ra, $t1       
    jr $ra              # return to caller address

# +++ PROCEDURE ARGUEMENTS +++ #
#   'space' ($a0) -- space in bytes to be allocated on the stack
# +++ PROCEDURE RETURN VALUES +++ #
#   'address' ($v0) -- starting address of the continuous block of allocated memory
mallocInStack:  # allocates contiguous memory on the stack
    addi $v0, $sp, -4       # save starting address
    sub $sp, $sp, $a0       # allocate memory
    jr $ra

initStack:  # initialize stack pointer sp and frame pointer fp
    addi $sp, $sp, -4   # allocate 4 bytes of space and
    sw $fp, 0($sp)      # store the current value of frame pointer ($fp) onto the stack
    move $fp, $sp       # set $fp to the current stack pointer ($sp)
    jr $ra

# +++ PROCEDURE ARGUEMENTS +++ #
#   'val' ($a0) -- value to be pushed onto the stack
pushToStack:    # pushes an arguement value onto the stack
    addi $sp, $sp, -4   # allocate 4 bytes of space and
    sw $a0, 0($sp)      # store the element on the stack
    jr $ra  # return to caller address

# +++ PROCEDURE RETURN VALUES +++ #
#   'val' ($v0) -- first element from the stack
popFromStack:    # pop the first element from the stack
    lw $v0, 0($sp)      # Load the first element of the stack into $v0
    addi $sp, $sp, 4    # free up 4 bytes of space
    jr $ra  # return to caller address

destructFrame:  # restore the old value of frame pointer fp
    lw $fp, 0($sp)      # set fp to its old value stored onto the stack
    addi $sp, $sp, 4    # free the 4 bytes that stored the old value from the stack
    jr $ra  # return to caller address

error:  # sanity checking of inputs failed
    # print error message
    la $a0, error_msg
    li $v0, 4
    syscall

exit:
    jal destructFrame   # destruct the stack frame for the main driver
    li $v0, 10
    syscall     # exit the program