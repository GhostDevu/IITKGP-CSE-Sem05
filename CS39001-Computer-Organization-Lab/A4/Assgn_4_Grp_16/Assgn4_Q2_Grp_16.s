
# Computer Organization Laboratory (CS39001)
# Semester 05 (Autumn 2021-22)
# Assignment 04 -- Problem 02
#   [ This program sorts an array of integers using a recursive quick-sort algorithm ]
# Group No. 16
#      Hritaban Ghosh (19CS30053)
#      Nakul Aggarwal (19CS10044)

# ++++ DATA SEGMENT ++++ #
# Definitions of all the string literals that are printed by the program through system calls
.data
prompt:         .asciiz " Enter 10 integers :\n"
sorted_array:   .asciiz "\n Sorted array : "
whitespace:     .asciiz " "
newline:        .asciiz "\n"

.align 5    # align the datum on a 32 byte boundary
array:          .space  40  # allocate consecutive bytes (with storage uninitialized)
                            # to be used as a 10-element uni-dimensional integer array

# ++++ TEXT SEGMENT ++++ #
# +++ PROGRAM VARIABLES +++ #
#   'array' ($s0) -- starting address of integer-array "array"
#   'n'     ($s1) -- search query (integer to be searched in array)
.text
.globl main
main:
    jal initStack   # initialize stack for main function
    
    # print prompt asking the user to fill the integer-array
    la $a0, prompt
    li $v0, 4
    syscall

    la $s0, array   # load starting address of array "array" to $s0
    li $t0, 0       # 'i' (iterator) -- iterates over the array elements

# +++ PROGRAM VARIABLES +++ #
#   'i' ($t0) -- iterator (iterates over the array elements)
populate_loop:
    bge $t0, 10, populate_break    # break loop if (i >= 10)
    
    la $a0, whitespace
    li $v0, 4
    syscall

    li $v0, 5
    syscall     # take integer input from user

    sll $t1, $t0, 2
    add $t1, $s0, $t1   # $t1 <-- address of array[i]
    sw $v0, 0($t1)  # array[i] <-- $v0 (load the integer at the designated location in 'array')

    addi $t0, $t0, 1    # increment 'i' and
    j populate_loop     # re-iterate

populate_break:
    move $a0, $s0   # $a0 <-- array (integer-array to be sorted)
    li $a1, 0       # $a1 <-- start index
    li $a2, 9       # $a2 <-- end index
    jal recursive_sort  # call recursive_sort procedure to sort the 'array' from 'start' to 'end'

    # printing the sorted array
    la $a0, sorted_array
    li $v0, 4
    syscall

    move $a0, $s0   # $a0 <-- array (starting address of array to be printed)
    li $a1, 10      # $a1 <-- size of array
    jal printArray  # call printArray procedure to print the sorted array elements

    jal destructFrame   # destruct the stack frame for the main function
    li $v0, 10
    syscall     # exit the program

# +++ PROCEDURE ARGUEMENTS +++ #
#   'A' ($a0) -- starting address of the integer array
#   'n' ($a1) -- size of the array A
printArray: # print the elements of array A of size n
    # [ Function Type : Iterative ]

    move $t0, $ra   # remember the original values of $ra and
    move $t1, $a0   # $a0 (might be changed by pushToStack/initStack procedure calls)

    # initialize stack-frame (remember old $fp and set $fp for the current frame)
    jal initStack

    # push arguements onto the stack
    jal pushToStack
    move $a0, $a1
    jal pushToStack
    move $a0, $t0       # save original return address onto the stack
    jal pushToStack
    
    move $a0, $t1
    li $t0, 0       # 'i' (iterator) -- iterates over the array elements

# +++ PROCEDURE VARIABLES +++ #
#   'i' ($t0) -- iterator (iterates over the array elements)
print_loop:
    bge $t0, $a1, print_break   # break loop if (i >= n)

    sll $t1, $t0, 2
    add $t1, $a0, $t1   # $t1 <-- address of array[i]
    lw $a0, 0($t1)      # $a0 <-- array[i] (load the integer at the designated location in 'array')
    li $v0, 1
    syscall     # print array[i]

    la $a0, whitespace
    li $v0, 4
    syscall     # print blank space for formatting

    lw $a0, -4($fp)     # restore the value of $a0 register
    addi $t0, $t0, 1    # increment 'i' and
    j print_loop        # re-iterate

print_break:
    jal popFromStack
    move $t0, $v0   # save return address in temporary

    # pop arguements off the stack frame
    jal popFromStack
    jal popFromStack

    jal destructFrame   # call destructFrame procedure to restore the value of $fp
    move $ra, $t0       # restore the value of $ra (return address)
    jr $ra              # return to caller address

# +++ PROCEDURE ARGUEMENTS +++ #
#   'A'     ($a0) -- starting address of the integer array
#   'left'  ($a1) -- start/left index of A
#   'right' ($a2) -- end/right index of A
recursive_sort: # [ Function Type : Recursive ]
    # a recursive quick-sort algorithm that sorts the elements of the input 
    # array (between 'left' and 'right') in non-decreasing order

    move $t0, $ra   # remember the original values of $ra and
    move $t1, $a0   # $a0 (might be changed by pushToStack/initStack procedure calls)

    # initialize stack-frame (remember old $fp and set $fp for the current frame)
    jal initStack

    # push arguements onto the stack
    jal pushToStack
    move $a0, $a1
    jal pushToStack
    move $a0, $a2
    jal pushToStack

    # push values of callee-saved registers ($s0-$s7, $ra whichever reqd.) onto the stack
    move $a0, $s0
    jal pushToStack
    move $a0, $s1
    jal pushToStack
    move $a0, $s2
    jal pushToStack
    move $a0, $t0       # save original return address onto the stack
    jal pushToStack
    
    move $a0, $t1

# +++ PROCEDURE VARIABLES +++ #
#   'l' ($s0)
#   'r' ($s1)
#   'p' ($s2)
initialization:
    move $s0, $a1   # l <-- left
    move $s1, $a2   # r <-- right
    move $s2, $a1   # p <-- left

while:  # inside while loop
    bge $s0, $s1, recursive_sort_return    # while loop condition -- if (l < r)

inner_loop_1:   # first inner loop
    # loop condition -- if (A[l] <= A[p] and l < right)

    sll $t0, $s0, 2
    add $t0, $a0, $t0   # $t0 <-- address of A[l]
    lw $t1, 0($t0)      # $t1 <-- A[l]

    sll $t0, $s2, 2
    add $t0, $a0, $t0   # $t0 <-- address of A[p]
    lw $t2, 0($t0)      # $t2 <-- A[p]

    bgt $t1, $t2, inner_loop_2  # if (A[l] > A[p]) loop condition not satisfied 
                                #   -- break out of first inner loop and enter second inner loop
    bge $s0, $a2, inner_loop_2  # if (l >= right)  loop condition not satisfied 
                                #   -- break out of first inner loop and enter second inner loop

    addi $s0, $s0, 1    # l <-- l + 1 
    j inner_loop_1      # re-iterate over first inner loop

inner_loop_2:   # second inner loop
    # loop condition -- if (A[r] >= A[p] and r > left)

    sll $t0, $s1, 2
    add $t0, $a0, $t0   # $t0 <-- address of A[r]
    lw $t1, 0($t0)      # $t1 <-- A[r]

    sll $t0, $s2, 2
    add $t0, $a0, $t0   # $t0 <-- address of A[p]
    lw $t2, 0($t0)      # $t2 <-- A[p]

    blt $t1, $t2, if_condition  # if (A[r] < A[p]) loop condition not satisfied 
                                #   -- break out of second inner loop and goto if_condition
    ble $s1, $a1, if_condition  # if (r <= left)  loop condition not satisfied 
                                #   -- break out of second inner loop and goto if_condition

    addi $s1, $s1, -1   # r <-- r - 1
    j inner_loop_2      # re-iterate over second inner loop

if_condition:
    blt $s0, $s1, swap  # if (l < r) goto swap

    sll $t0, $s2, 2
    add $t1, $a0, $t0   # $t1 <-- address of A[p]

    sll $t0, $s1, 2
    add $t2, $a0, $t0   # $t2 <-- address of A[r]

    move $a0, $t1   # $a0 <-- address of A[p]
    move $a1, $t2   # $a1 <-- address of A[r]
    jal SWAP    # call SWAP procedure to swap the values stored in A[p] and A[r]

    # restore arguements $a0, $a1 to the original values from the stack
    lw $a0, -4($fp)
    lw $a1, -8($fp)

recursive_calls:
    addi $a2, $s1, -1   # $a2 <-- (r - 1) -- set 'right' arguement to (r-1) for 
    jal recursive_sort  # recursive call to recursive_sort (recursively sort A from 'left' to 'r-1')
    lw $a2, -12($fp)    # reset $a2 to the original value from the stack

    addi $a1, $s1, 1    # $a1 <-- (r + 1) -- set 'left' arguement to (r+1) for 
    jal recursive_sort  # recursive call to recursive_sort (recursively sort A from 'r+1' to 'right')
    lw $a1, -8($fp)     # reset $a1 to the original value from the stack

    j recursive_sort_return     # jump to recursive_sort_return to clear stack frame and return to the caller

swap:   # if (l < r)
    sll $t0, $s0, 2
    add $t1, $a0, $t0   # $t1 <-- address of A[l]

    sll $t0, $s1, 2
    add $t2, $a0, $t0   # $t2 <-- address of A[r]

    move $a0, $t1   # $a0 <-- address of A[l]
    move $a1, $t2   # $a1 <-- address of A[r]
    jal SWAP    # call SWAP procedure to swap the values stored in A[l] and A[r]

    # restore arguements $a0, $a1 to the original values from the stack
    lw $a0, -4($fp)
    lw $a1, -8($fp)

    j while # re-iterate over the outer-most while loop

recursive_sort_return: # clear stack frame and return to the caller
    # restore the values of all callee-saved registers ($s0-$s7, $ra 
    # whichever required) by popping from stack
    jal popFromStack    # popped saved value of $ra
    move $t0, $v0   # remember the return address $ra in the temporary
                    # ($ra might be changed by popFromStack/destructFrame procedure calls)
    jal popFromStack
    move $s2, $v0
    jal popFromStack
    move $s1, $v0
    jal popFromStack
    move $s0, $v0

    # pop arguements ($a0, $a1, $a2)
    jal popFromStack
    jal popFromStack
    jal popFromStack

    jal destructFrame   # call destructFrame procedure to restore the value of $fp

    move $ra, $t0   # restore the value of $ra (return address)
    jr $ra  # return to caller

# +++ PROCEDURE ARGUEMENTS +++ #
#   'add1'  ($a0)
#   'add2'  ($a1)
SWAP:   # swaps the values stored at the addresses 'add1' and 'add2'
    lw $t0, 0($a0)  # $t0 <-- Memory[add1]
    lw $t1, 0($a1)  # $t1 <-- Memory[add2]
    sw $t0, 0($a1)  # Memory[add2] <-- $t0
    sw $t1, 0($a0)  # Memory[add1] <-- $t1
    jr $ra  # return to caller

initStack:  # initialize stack pointer sp and frame pointer fp
    addi $sp, $sp, -4   # allocate 4 bytes of space and
    sw $fp, 0($sp)      # store the current value of frame pointer ($fp) onto the stack
    move $fp, $sp       # set $fp to the current stack pointer ($sp)
    jr $ra  # return to caller address

# +++ PROCEDURE ARGUEMENTS +++ #
#   'val' ($a0) -- value to be pushed onto the stack
pushToStack:    # pushes an arguement value onto the stack
    addi $sp, $sp, -4   # allocate 4 bytes of space and
    sw $a0, 0($sp)      # store the element on the stack
    jr $ra  # return to caller address

# +++ PROCEDURE RETURN VALUES +++ #
#   'val' ($v0) -- first element from the stack
popFromStack:    # pushes an arguement value onto the stack
    lw $v0, 0($sp)
    addi $sp, $sp, 4   # allocate 4 bytes of space and
    jr $ra  # return to caller address

destructFrame:  # restore the old value of frame pointer fp
    lw $fp, 0($sp)      # set fp to its old value stored onto the stack
    addi $sp, $sp, 4    # free the 4 bytes that stored the old value from the stack
    jr $ra  # return to caller address