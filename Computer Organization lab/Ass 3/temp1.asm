.data
array:          .space 40            #Creating a space of 40 bytes as 10x4=40 for 10 integers
size:           .word 10             
newline:        .asciiz " "         
original_array: .asciiz "The Original array is : "
heapified_array:.asciiz "\nThe Heapified array is : "
prompt_message_for_integer_in_array: .asciiz "Enter integer number "
colon: .asciiz " :"
endline_int_the_end: .asciiz "\n"

.text
.globl main

heapify:   # Function thet checks and updates the largest lement in the recurrsion of the heapify 
    addi $sp, $sp, -28         
    sw $ra, 24($sp)            
    sw $s0, 20($sp)            
    sw $s1, 16($sp)            
    sw $s2, 12($sp)            
    sw $s3, 8($sp)             
    sw $s4, 4($sp)             
    sw $s5, 0($sp)             

    move $s0, $a2              
    move $s1, $a0              
    sll $s2, $s0, 2            
    add $s3, $s1, $s2          
    lw $s4, 0($s3)             
    move $s5, $s4              
    move $s6, $s0              

    sll $t0, $s0, 1            
    addi $t0, $t0, 1           
    bge $t0, $a1, check_right  
    sll $t1, $t0, 2            
    add $t2, $s1, $t1          
    lw $s7, 0($t2)             
    bgt $s7, $s5, update_left  
    j check_right

update_left:
    move $s5, $s7              
    move $s6, $t0              

check_right:# checkng the right element is  lagrest or not 
    sll $t0, $s0, 1            
    addi $t0, $t0, 2           
    bge $t0, $a1, check_swap   
    sll $t1, $t0, 2            
    add $t2, $s1, $t1          
    lw $s7, 0($t2)             
    bgt $s7, $s5, update_right 
    j check_swap

update_right:# updating the right element ot lagrest 
    move $s5, $s7              
    move $s6, $t0              

check_swap: 
    beq $s6, $s0, restore      

    sll $s2, $s6, 2            
    add $s3, $s1, $s2          
    lw $s4, 0($s3)             
    sll $s5, $s0, 2            
    add $s5, $s1, $s5          
    lw $s7, 0($s5)             
    sw $s7, 0($s3)             
    sw $s4, 0($s5)             

    move $a2, $s6              
    jal heapify                

restore:# restore the stack elements 
    lw $ra, 24($sp)            
    lw $s0, 20($sp)            
    lw $s1, 16($sp)            
    lw $s2, 12($sp)            
    lw $s3, 8($sp)             
    lw $s4, 4($sp)             
    lw $s5, 0($sp)             
    addi $sp, $sp, 28          
    jr $ra                     

main:
    li $t1, 0    #iniatialaize t1 to zero 
    la $t0, array      #load array adddress into t0            
read_loop:
    li $v0, 4 #call fo reading the elemets
    la $a0, prompt_message_for_integer_in_array #asking the user for the input 
    syscall

    li $v0, 1 #printing the number of the integer to be takeo into teh array 
    move $a0, $t1
    addi $a0, $a0, 1
    syscall

    li $v0, 4
    la $a0, colon
    syscall

    li $v0, 5                  
    syscall                    
    sw $v0, 0($t0)             
    addi $t0, $t0, 4           
    add $t1, $t1, 1            
    bne $t1, 10, read_loop        

    li $v0, 4                  
    la $a0, original_array     
    syscall                    

    la $t0, array              
    li $t1, 10                
print_original: #function for printing the elements of original array for the rrefefrrence
    lw $a0, 0($t0)             
    li $v0, 1                  
    syscall                    

    li $v0, 4                  
    la $a0, newline            
    syscall                    

    addi $t0, $t0, 4           
    sub $t1, $t1, 1            
    bnez $t1, print_original   

    la $a0, array              
    lw $a1, size               

    move $s0, $a1              
    srl $s0, $s0, 1            
    sub $s0, $s0, 1            

    move $s1, $s0              
heapify_loop: #Recurrsive function for callling the heapify processs 
    bltz $s1, exit_heapify_loop  
    move $a2, $s1              
    jal heapify                
    sub $s1, $s1, 1            

    j heapify_loop

exit_heapify_loop:# function to end the heapijfy process
    li $v0, 4                  
    la $a0, heapified_array    
    syscall                    

    la $t0, array              
    li $t1, 10                 
print_heapified:# function for orinting the elements afte rthe heapify 
    lw $a0, 0($t0)             
    li $v0, 1                  
    syscall                    

    li $v0, 4                  
    la $a0, newline            
    syscall                    

    addi $t0, $t0, 4           
    sub $t1, $t1, 1            
    bnez $t1, print_heapified  

    li $v0, 4
    la $a0, endline_int_the_end
    syscall

    li $v0, 10
    syscall
