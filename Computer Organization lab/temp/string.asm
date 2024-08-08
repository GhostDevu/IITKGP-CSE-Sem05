.text
.globl main
main:
    la $a0,prompt
    li $v0,4
    syscall

    li $v0,7
    syscall

    mov.d $f12,$f0
    li $v0,3
    syscall

    li $v0,10
    syscall
    

.data
prompt: .asciiz "Enter double:"