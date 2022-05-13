
# Computer Organization Laboratory (CS39001)
# Semester 05 (Autumn 2021-22)
# Assignment 03 -- Problem 03
#   [ This program computes transpose of a two-dimensional integeral matrix ]
# Group No. 16
#      Hritaban Ghosh (19CS30053)
#      Nakul Aggarwal (19CS10044)

# ++++ DATA SEGMENT ++++ #
# Definitions of all the string literals that are printed by the program through system calls
.data
prompt:         .asciiz " Enter four positive integers m, n, a and r : "
error_msg:      .asciiz " [ ERROR : Sanity check failed. All integers must be positive. ] "
overflow_msg:   .asciiz " [ ERROR : GP terms overflowed. ] "
tab:            .asciiz "\t"
double_space:   .asciiz "  "
newline:        .asciiz "\n"
matrix_A:       .asciiz "\n   +++ MATRIX A +++\n"
matrix_B:       .asciiz "\n   +++ MATRIX B (Transpose(A)) +++\n"

# ++++ TEXT SEGMENT ++++ #
# +++ PROGRAM VARIABLES +++ #
#   'm' ($s0) -- number of rows in matrix A (columns in matrix B)
#   'n' ($s1) -- number of columns in matrix A (rows in matrix B)
#   'a' ($s2) -- first term of GP
#   'r' ($s3) -- common ratio of Gp
#   'A' ($s4) -- starting address of mxn array A
#   'B' ($s5) -- starting address of nxm array B
.text
.globl main
main:
    # Print prompt asking the user to enter 4 positive integers -- m, n, a, r 
    jal initStack
    la $a0, prompt
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $s0, $v0   # scanned the value of 'm'
    
    li $v0, 5
    syscall
    move $s1, $v0   # scanned the value of 'n'
    
    li $v0, 5
    syscall
    move $s2, $v0   # scanned the value of 'a'
    
    li $v0, 5
    syscall
    move $s3, $v0   # scanned the value of 'r'
    
    # sanity check -- force exit if any of m, n, a, r is non-positive
    ble $s0, $zero, error
    ble $s1, $zero, error
    ble $s2, $zero, error
    ble $s3, $zero, error

    mul $a0, $s0, $s1
    sll $a0, $a0, 2     # 4mn -- memory required to store A and B on stack
    jal mallocInStack   # allocate 4mn bytes for stack A
    move $s4, $v0       # and return the starting address in $v0
    jal mallocInStack   # allocate 4mn bytes for stack B
    move $s5, $v0       # and return the starting address in $v0

    li $t0, 0   # outer loop iterator 'i' (row index) -- loops over the rows of matrix A
    move $t3, $s2   # next term in GP 't' -- GP is defined by the first term 'a' and common ratio 'r'
                    # 't' is intialized to first term 'a'

# +++ PROGRAM VARIABLES +++ #
#   'i' ($t0)
#   'j' ($t1)
#   't' ($t3)
populate_outer_loop:    # loop over rows of A (outer loop)
    bge $t0, $s0, break_loop    # break out of outer loop if (i >= m)
    li $t1, 0   # inner loop iterator 'j' (column index) -- 
                # loops over the columns of a particular row in matrix A

populate_inner_loop:    # loop over columns of A (inner loop)
    bge $t1, $s1, reiterate_populate_outer_loop    # break out of inner loop if (j >= n) and re-iterate over outer loop
    mul $t2, $t0, $s1
    add $t2, $t2, $t1   # (i * n + j) -- position of (i,j)th element of A wrt its starting 
                        # address in the row-major-flattened format of A
    sll $t2, $t2, 2
    sub $t2, $s4, $t2   # address of A[i][j] on the stack
    sw $t3, 0($t2)      # populate A[i][j] with the current term in GP
    move $t4, $t3
    mul $t3, $t3, $s3   # and update 't' with the next term in GP

    ble $t3, $zero, overflow    # check if the next term in GP overflows (if $t3 <= 0)
    blt $t3, $t4, overflow      # check if the next term in GP is less than current term (if $t3 < $t4)

    addi $t1, $t1, 1
    j populate_inner_loop   # re-iterate over inner loop for the next column of A in the same row

overflow:   # GP term overflows the maximum value that can be stored in a 32-bit register
    # print an appropriate error message
    la $a0, overflow_msg
    li $v0, 4
    syscall

    # de-allocate space from stack for the matrices A and B
    mul $t0, $s0, $s1
    sll $t0, $t0, 3     # 8mn -- total bytes space occupied by matrices A and B
    add $sp, $sp, $t0   # memory freed

    j exit  # exit the program

reiterate_populate_outer_loop:
    addi $t0, $t0, 1
    j populate_outer_loop  # re-iterate over outer loop for the next row of matrix A

break_loop: # population of matrix A in row-major fashion with elements in GP is done
    la $a0, matrix_A
    li $v0, 4
    syscall

    # set the arguements and call "printMatrix" procedure to print matrix A
    move $a0, $s0
    move $a1, $s1
    move $a2, $s4
    jal printMatrix

    # set the arguements and call "transposeMatrix" procedure to 
    # compute and store transpose of matrix A in matrix B
    move $a0, $s0
    move $a1, $s1
    move $a2, $s4
    move $a3, $s5
    jal transposeMatrix

    la $a0, newline
    li $v0, 4
    syscall
    
    la $a0, matrix_B
    li $v0, 4
    syscall

    # set the arguements and call "printMatrix" procedure to print matrix B
    move $a0, $s1
    move $a1, $s0
    move $a2, $s5
    jal printMatrix
    
    # de-allocate space from stack for the matrices A and B
    mul $t0, $s0, $s1
    sll $t0, $t0, 3     # 8mn -- total bytes space occupied by matrices A and B
    add $sp, $sp, $t0   # memory freed

    j exit  # exit the program

# +++ PROCEDURE ARGUEMENTS +++ #
#   'm' ($a0) -- number of rows in matrix A (columns in matrix B)
#   'n' ($a1) -- number of columns in matrix A (rows in matrix B)
#   'A' ($a2) -- starting address of mxn array A
#   'B' ($a3) -- starting address of nxm array B
transposeMatrix:    # compute and store the transpose of matrix A in matrix B
    move $t0, $ra
    move $t1, $a0

    # initialize stack-frame (remember old $fp and set $fp for the current frame)
    jal initStack

    # push values of callee-saved registers ($s0-$s7, $ra whichever reqd.) onto the stack
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
    move $a0, $s5
    jal pushToStack
    move $a0, $t0       # store original return address onto the stack
    jal pushToStack
    
    move $a0, $t1

    li $t0, 0  # outer loop iterator 'i' (row index) -- loops over the rows of matrix A

# +++ PROCEDURE VARIABLES +++ #
#   'i' ($t0)
#   'j' ($t1)
transpose_outer_loop:    # loop over rows of A (outer loop)
    bge $t0, $a0, transpose_return    # break out of outer loop if (i >= m)
    li $t1, 0   # inner loop iterator 'j' (column index) -- 
                # loops over the columns of a particular row in matrix A

transpose_inner_loop:    # loop over columns of A (inner loop)
    bge $t1, $a1, reiterate_transpose_outer_loop    # break out of inner loop if (j >= n) and re-iterate over outer loop
    
    mul $t2, $t0, $a1
    add $t2, $t2, $t1   # (i * n + j) -- position of (i,j)th element of A wrt its starting 
                        # address in the row-major-flattened format of A
    sll $t2, $t2, 2
    sub $t2, $a2, $t2   # address of A[i][j] on the stack
    lw $t2, 0($t2)      # $t2 <-- value of A[i][j]

    mul $t3, $t1, $a0
    add $t3, $t3, $t0   # (j * m + i) -- position of (j,i)th element of B wrt its starting 
                        # address in the row-major-flattened format of B
    sll $t3, $t3, 2
    sub $t3, $a3, $t3   # address of B[j][i] on the stack
    sw $t2, 0($t3)      # B[j][i] <-- A[i][j]
    
    addi $t1, $t1, 1
    j transpose_inner_loop   # re-iterate over inner loop for the next column of A in the same row

reiterate_transpose_outer_loop:
    addi $t0, $t0, 1
    j transpose_outer_loop  # re-iterate over outer loop for the next row of matrix A

transpose_return:   # de-allocate memory from stack frame after restoring the values in callee-saved registers 
    # restore the values of all #s0-$s7, $ra (whichever required) registers
    lw $s0, -4($fp)
    lw $s1, -8($fp)
    lw $s2, -12($fp)
    lw $s3, -16($fp)
    lw $s4, -20($fp)
    lw $s5, -24($fp)
    lw $ra, -28($fp)
    addi $sp, $sp, 28
    move $t0, $ra
    jal destructFrame   # call "destructFrame" procedure to restore the value of $fp
    move $ra, $t0
    jr $ra              # return to caller address

# +++ PROCEDURE ARGUEMENTS +++ #
#   'r' ($a0) -- number of rows in matrix M
#   'c' ($a1) -- number of columns in matrix M
#   'M' ($a2) -- starting address of rxc array M
printMatrix:    # print the matrix M in a proper two-dimensional format
    move $t0, $ra
    move $t1, $a0

    # initialize stack-frame (remember old $fp and set $fp for the current frame)
    jal initStack

    # push values of callee-saved registers ($s0-$s7, $ra whichever reqd.) onto the stack
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
    move $a0, $s5
    jal pushToStack
    move $a0, $t0       # store original return address onto the stack
    jal pushToStack
    
    move $a0, $t1

    li $t0, 0  # outer loop iterator 'i' (row index) -- loops over the rows of matrix M

# +++ PROCEDURE VARIABLES +++ #
#   'i' ($t0)
#   'j' ($t1)
print_outer_loop:    # loop over rows of M (outer loop)
    bge $t0, $a0, print_return    # break out of outer loop if (i >= r)

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
    bge $t1, $a1, reiterate_print_outer_loop    # break out of inner loop if (j >= c) and re-iterate over outer loop
    
    mul $t2, $t0, $a1
    add $t2, $t2, $t1   # (i * n + j) -- position of (i,j)th element of M wrt its starting 
                        # address in the row-major-flattened format of M
    sll $t2, $t2, 2
    sub $t2, $a2, $t2   # address of M[i][j] on the stack
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
    # restore the values of all #s0-$s7, $ra (whichever required) registers
    lw $s0, -4($fp)
    lw $s1, -8($fp)
    lw $s2, -12($fp)
    lw $s3, -16($fp)
    lw $s4, -20($fp)
    lw $s5, -24($fp)
    lw $ra, -28($fp)
    addi $sp, $sp, 28
    move $t0, $ra
    jal destructFrame   # call "destructFrame" procedure to restore the value of $fp
    move $ra, $t0
    jr $ra              # return to caller address

# +++ PROCEDURE ARGUEMENTS +++ #
#   'space' ($a0) -- space in bytes to be allocated on the stack
# +++ PROCEDURE RETURN VALUES +++ #
#   'add' ($v0) -- starting address of the continuous block of allocated memory
mallocInStack:  # allocates contiguous memory on the stack
    move $v0, $sp           # save starting address
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
    jr $ra

destructFrame:  # restore the old value of frame pointer fp
    lw $fp, 0($sp)      # set fp to its old value stored onto the stack
    addi $sp, $sp, 4    # free the 4 bytes that stored the old value from the stack
    jr $ra

error:  # sanity checking of inputs failed
    # print error message
    la $a0, error_msg
    li $v0, 4
    syscall

exit:
    jal destructFrame   # destruct the stack frame for the main function
    li $v0, 10
    syscall     # exit the program