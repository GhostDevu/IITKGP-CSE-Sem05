	.file	"ass6_19CS10044_19CS30053_asm5.s"
	.section	.rodata
.LC0:
	.string	" ** Function not available currently **"
.LC1:
	.string	"\n\n"
.LC2:
	.string	" [ +++ LIBRARY || VECTOR ALGEBRA +++ ]\n"
.LC3:
	.string	"\n Functions supporting the following operations are defined in the library."
.LC4:
	.string	"\n  >> Square of 2-Norm of a vector"
.LC5:
	.string	"\n  >> Infinite-Norm of a vector"
.LC6:
	.string	"\n  >> Dot product of two vectors"
.LC7:
	.string	"\n  >> Magnitude of cross product of two vectors (under maintainence)"
.LC8:
	.string	"\n  >> Maximum element of a vector"
.LC9:
	.string	"\n  >> Minimum element of a vector"
.LC10:
	.string	"\n  >> Reverse direction of a vector"
.LC11:
	.string	"\n  >> Scalar multiplication with a vector"
.LC12:
	.string	"\n  >> Vector copy creation"
.LC13:
	.string	"\n  >> Vector addition"
.LC14:
	.string	"\n  >> Vector subtraction"
.LC15:
	.string	"\n\n"
	.text	
	.globl	Norm2Sq
	.type	Norm2Sq, @function
Norm2Sq:
.LFB0:
	.cfi_startproc
	endbr64
	pushq 	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$84, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movl	$0, %eax
	movl 	%eax, -24(%rbp)
	movl	-16(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jle .L2
	jmp .L3
	jmp .L3
.L2: 
	movl	$1, %eax
	movl 	%eax, -28(%rbp)
	negl	-28(%rbp)
	movl	-32(%rbp), %eax
	jmp	Norm2Sq_RETURN
	jmp .L3
.L3: 
	movl	$0, %eax
	movl 	%eax, -40(%rbp)
	movl	-40(%rbp), %eax
	movl 	%eax, -36(%rbp)
	movl	$0, %eax
	movl 	%eax, -48(%rbp)
	movl	-48(%rbp), %eax
	movl 	%eax, -44(%rbp)
.L4: 
	movl	-44(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jl .L6
	jmp .L7
.L5: 
	addl 	$1, -44(%rbp)
	jmp .L4
.L6: 
	movl 	-44(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -56(%rbp)
	movq	-20(%rbp), %rax
	movq 	%rax, -60(%rbp)
	movl 	-44(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -64(%rbp)
	movl 	-60(%rbp), %eax
	imull 	-64(%rbp), %eax
	movl 	%eax, -68(%rbp)
	movl 	-36(%rbp), %eax
	movl 	-68(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -72(%rbp)
	movl	-72(%rbp), %eax
	movl 	%eax, -36(%rbp)
	jmp .L5
.L7: 
	movl	-36(%rbp), %eax
	jmp	Norm2Sq_RETURN
Norm2Sq_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	Norm2Sq, .-Norm2Sq
	.globl	NormInf
	.type	NormInf, @function
NormInf:
.LFB1:
	.cfi_startproc
	endbr64
	pushq 	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$88, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movl	$0, %eax
	movl 	%eax, -24(%rbp)
	movl	-16(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jle .L10
	jmp .L11
	jmp .L11
.L10: 
	movl	$1, %eax
	movl 	%eax, -28(%rbp)
	negl	-28(%rbp)
	movl	-32(%rbp), %eax
	jmp	NormInf_RETURN
	jmp .L11
.L11: 
	movl	$0, %eax
	movl 	%eax, -40(%rbp)
	movl 	-40(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -44(%rbp)
	movq	-20(%rbp), %rax
	movq 	%rax, -48(%rbp)
	movl	-48(%rbp), %eax
	movl 	%eax, -36(%rbp)
	movl	$0, %eax
	movl 	%eax, -56(%rbp)
	movl	-56(%rbp), %eax
	movl 	%eax, -52(%rbp)
.L12: 
	movl	-52(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jl .L14
	jmp .L17
.L13: 
	addl 	$1, -52(%rbp)
	jmp .L12
.L14: 
	movl 	-52(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -64(%rbp)
	movq	-20(%rbp), %rax
	movq 	%rax, -68(%rbp)
	movl	-68(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jg .L15
	jmp .L13
	jmp .L16
.L15: 
	movl 	-52(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -72(%rbp)
	movq	-20(%rbp), %rax
	movq 	%rax, -76(%rbp)
	movl	-76(%rbp), %eax
	movl 	%eax, -36(%rbp)
	jmp .L13
.L16: 
	jmp .L13
.L17: 
	movl	-36(%rbp), %eax
	jmp	NormInf_RETURN
NormInf_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	NormInf, .-NormInf
	.globl	Dot
	.type	Dot, @function
Dot:
.LFB2:
	.cfi_startproc
	endbr64
	pushq 	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$104, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -12(%rbp)
	movq	%rcx, -8(%rbp)
	movl	$0, %eax
	movl 	%eax, -24(%rbp)
	movl	-12(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jle .L21
	jmp .L20
.L20: 
	movl	$0, %eax
	movl 	%eax, -28(%rbp)
	movl	-8(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jle .L21
	jmp .L22
	jmp .L22
.L21: 
	movl	$1, %eax
	movl 	%eax, -32(%rbp)
	negl	-32(%rbp)
	movl	-36(%rbp), %eax
	jmp	Dot_RETURN
	jmp .L22
.L22: 
	movl	-12(%rbp), %eax
	cmpl	-8(%rbp), %eax
	jne .L23
	jmp .L24
	jmp .L24
.L23: 
	movl	$1, %eax
	movl 	%eax, -40(%rbp)
	negl	-40(%rbp)
	movl	-44(%rbp), %eax
	jmp	Dot_RETURN
	jmp .L24
.L24: 
	movl	$0, %eax
	movl 	%eax, -52(%rbp)
	movl	-52(%rbp), %eax
	movl 	%eax, -48(%rbp)
	movl	$0, %eax
	movl 	%eax, -60(%rbp)
	movl	-60(%rbp), %eax
	movl 	%eax, -56(%rbp)
.L25: 
	movl	-56(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jl .L27
	jmp .L28
.L26: 
	addl 	$1, -56(%rbp)
	jmp .L25
.L27: 
	movl 	-56(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -68(%rbp)
	movq	-20(%rbp), %rax
	movq 	%rax, -72(%rbp)
	movl 	-56(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -76(%rbp)
	movl 	-72(%rbp), %eax
	imull 	-76(%rbp), %eax
	movl 	%eax, -80(%rbp)
	movl 	-48(%rbp), %eax
	movl 	-80(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -84(%rbp)
	movl	-84(%rbp), %eax
	movl 	%eax, -48(%rbp)
	jmp .L26
.L28: 
	movl	-48(%rbp), %eax
	jmp	Dot_RETURN
Dot_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	Dot, .-Dot
	.globl	Cross
	.type	Cross, @function
Cross:
.LFB3:
	.cfi_startproc
	endbr64
	pushq 	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$56, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -12(%rbp)
	movq	%rcx, -8(%rbp)
	movq 	$.LC0, -24(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
	call 	printStr
	movl 	%eax, -28(%rbp)
	movl	$1, %eax
	movl 	%eax, -32(%rbp)
	negl	-32(%rbp)
	movl	-36(%rbp), %eax
	jmp	Cross_RETURN
Cross_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	Cross, .-Cross
	.globl	Max
	.type	Max, @function
Max:
.LFB4:
	.cfi_startproc
	endbr64
	pushq 	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$36, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movl 	-20(%rbp), %eax
	movq 	-20(%rbp), %rdi
	movl 	-16(%rbp), %eax
	movq 	-16(%rbp), %rsi
	call 	NormInf
	movl 	%eax, -24(%rbp)
	movl	-24(%rbp), %eax
	jmp	Max_RETURN
Max_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	Max, .-Max
	.globl	Min
	.type	Min, @function
Min:
.LFB5:
	.cfi_startproc
	endbr64
	pushq 	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$88, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movl	$0, %eax
	movl 	%eax, -24(%rbp)
	movl	-16(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jle .L35
	jmp .L36
	jmp .L36
.L35: 
	movl	$1, %eax
	movl 	%eax, -28(%rbp)
	negl	-28(%rbp)
	movl	-32(%rbp), %eax
	jmp	Min_RETURN
	jmp .L36
.L36: 
	movl	$0, %eax
	movl 	%eax, -40(%rbp)
	movl 	-40(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -44(%rbp)
	movq	-20(%rbp), %rax
	movq 	%rax, -48(%rbp)
	movl	-48(%rbp), %eax
	movl 	%eax, -36(%rbp)
	movl	$0, %eax
	movl 	%eax, -56(%rbp)
	movl	-56(%rbp), %eax
	movl 	%eax, -52(%rbp)
.L37: 
	movl	-52(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jl .L39
	jmp .L42
.L38: 
	addl 	$1, -52(%rbp)
	jmp .L37
.L39: 
	movl 	-52(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -64(%rbp)
	movq	-20(%rbp), %rax
	movq 	%rax, -68(%rbp)
	movl	-68(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl .L40
	jmp .L38
	jmp .L41
.L40: 
	movl 	-52(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -72(%rbp)
	movq	-20(%rbp), %rax
	movq 	%rax, -76(%rbp)
	movl	-76(%rbp), %eax
	movl 	%eax, -36(%rbp)
	jmp .L38
.L41: 
	jmp .L38
.L42: 
	movl	-36(%rbp), %eax
	jmp	Min_RETURN
Min_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	Min, .-Min
	.globl	Reverse
	.type	Reverse, @function
Reverse:
.LFB6:
	.cfi_startproc
	endbr64
	pushq 	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$60, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movl	$0, %eax
	movl 	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	movl 	%eax, -24(%rbp)
.L45: 
	movl	-24(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jl .L47
	jmp .L48
.L46: 
	addl 	$1, -24(%rbp)
	jmp .L45
.L47: 
	movl 	-24(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -36(%rbp)
	movl	$1, %eax
	movl 	%eax, -40(%rbp)
	negl	-40(%rbp)
	movl 	-24(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -48(%rbp)
	movl 	-44(%rbp), %eax
	imull 	-48(%rbp), %eax
	movl 	%eax, -52(%rbp)
	movl	-36(%rbp), %eax
	cltq
	movl	-52(%rbp), %edx
	movl	%edx, -20(%rbp,%rax,4)
	jmp .L46
.L48: 
	nop
	jmp	Reverse_RETURN
Reverse_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	Reverse, .-Reverse
	.globl	ScalarMult
	.type	ScalarMult, @function
ScalarMult:
.LFB7:
	.cfi_startproc
	endbr64
	pushq 	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$56, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -12(%rbp)
	movl	$0, %eax
	movl 	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	movl 	%eax, -24(%rbp)
.L51: 
	movl	-24(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jl .L53
	jmp .L54
.L52: 
	addl 	$1, -24(%rbp)
	jmp .L51
.L53: 
	movl 	-24(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -36(%rbp)
	movl 	-24(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -40(%rbp)
	movl 	-12(%rbp), %eax
	imull 	-40(%rbp), %eax
	movl 	%eax, -44(%rbp)
	movl	-36(%rbp), %eax
	cltq
	movl	-44(%rbp), %edx
	movl	%edx, -20(%rbp,%rax,4)
	jmp .L52
.L54: 
	nop
	jmp	ScalarMult_RETURN
ScalarMult_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	ScalarMult, .-ScalarMult
	.globl	Add
	.type	Add, @function
Add:
.LFB8:
	.cfi_startproc
	endbr64
	pushq 	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$84, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -12(%rbp)
	movq	%rcx, -8(%rbp)
	movl	$0, %eax
	movl 	%eax, -24(%rbp)
	movl	-12(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jle .L58
	jmp .L57
.L57: 
	movl	$0, %eax
	movl 	%eax, -28(%rbp)
	movl	-8(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jle .L58
	jmp .L59
	jmp .L59
.L58: 
	nop
	jmp	Add_RETURN
	jmp .L59
.L59: 
	movl	-12(%rbp), %eax
	cmpl	-8(%rbp), %eax
	jne .L60
	jmp .L61
	jmp .L61
.L60: 
	nop
	jmp	Add_RETURN
	jmp .L61
.L61: 
	movl	$0, %eax
	movl 	%eax, -36(%rbp)
	movl	-36(%rbp), %eax
	movl 	%eax, -32(%rbp)
.L62: 
	movl	-32(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jl .L64
	jmp .L65
.L63: 
	addl 	$1, -32(%rbp)
	jmp .L62
.L64: 
	movl 	-32(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -44(%rbp)
	movl 	-32(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -48(%rbp)
	movq	-20(%rbp), %rax
	movq 	%rax, -52(%rbp)
	movl 	-32(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -56(%rbp)
	movq	-16(%rbp), %rax
	movq 	%rax, -60(%rbp)
	movl 	-52(%rbp), %eax
	movl 	-60(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -64(%rbp)
	movl	-44(%rbp), %eax
	cltq
	movl	-64(%rbp), %edx
	movl	%edx, -4(%rbp,%rax,4)
	jmp .L63
.L65: 
	nop
	jmp	Add_RETURN
Add_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	Add, .-Add
	.globl	Copy
	.type	Copy, @function
Copy:
.LFB9:
	.cfi_startproc
	endbr64
	pushq 	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$56, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -12(%rbp)
	movl	$0, %eax
	movl 	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	movl 	%eax, -24(%rbp)
.L68: 
	movl	-24(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jl .L70
	jmp .L71
.L69: 
	addl 	$1, -24(%rbp)
	jmp .L68
.L70: 
	movl 	-24(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -36(%rbp)
	movl 	-24(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -40(%rbp)
	movq	-20(%rbp), %rax
	movq 	%rax, -44(%rbp)
	movl	-36(%rbp), %eax
	cltq
	movl	-44(%rbp), %edx
	movl	%edx, -12(%rbp,%rax,4)
	jmp .L69
.L71: 
	nop
	jmp	Copy_RETURN
Copy_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	Copy, .-Copy
	.globl	Sub
	.type	Sub, @function
Sub:
.LFB10:
	.cfi_startproc
	endbr64
	pushq 	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$52, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -12(%rbp)
	movq	%rcx, -8(%rbp)
	movl	$0, %eax
	movl 	%eax, -24(%rbp)
	movl	-12(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jle .L75
	jmp .L74
.L74: 
	movl	$0, %eax
	movl 	%eax, -28(%rbp)
	movl	-8(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jle .L75
	jmp .L76
	jmp .L76
.L75: 
	nop
	jmp	Sub_RETURN
	jmp .L76
.L76: 
	movl	-12(%rbp), %eax
	cmpl	-8(%rbp), %eax
	jne .L77
	jmp .L78
	jmp .L78
.L77: 
	nop
	jmp	Sub_RETURN
	jmp .L78
.L78: 
	movl 	-16(%rbp), %eax
	movq 	-16(%rbp), %rdi
	movl 	-8(%rbp), %eax
	movq 	-8(%rbp), %rsi
	movl 	-4(%rbp), %eax
	movq 	-4(%rbp), %rdx
	call 	Copy
	movl 	%eax, -32(%rbp)
	movl 	-4(%rbp), %eax
	movq 	-4(%rbp), %rdi
	movl 	-12(%rbp), %eax
	movq 	-12(%rbp), %rsi
	call 	Reverse
	movl 	%eax, -32(%rbp)
	movl 	-20(%rbp), %eax
	movq 	-20(%rbp), %rdi
	movl 	-4(%rbp), %eax
	movq 	-4(%rbp), %rsi
	movl 	-12(%rbp), %eax
	movq 	-12(%rbp), %rdx
	movl 	-12(%rbp), %eax
	movq 	-12(%rbp), %rcx
	movq 	-4(%rbp), %rdi
	call 	Add
	movl 	%eax, -32(%rbp)
	nop
	jmp	Sub_RETURN
Sub_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	Sub, .-Sub
	.globl	main
	.type	main, @function
main:
.LFB11:
	.cfi_startproc
	endbr64
	pushq 	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$148, %rsp

	movq 	$.LC1, -24(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
	call 	printStr
	movl 	%eax, -28(%rbp)
	movq 	$.LC2, -32(%rbp)
	movl 	-32(%rbp), %eax
	movq 	-32(%rbp), %rdi
	call 	printStr
	movl 	%eax, -36(%rbp)
	movq 	$.LC3, -40(%rbp)
	movl 	-40(%rbp), %eax
	movq 	-40(%rbp), %rdi
	call 	printStr
	movl 	%eax, -44(%rbp)
	movq 	$.LC4, -48(%rbp)
	movl 	-48(%rbp), %eax
	movq 	-48(%rbp), %rdi
	call 	printStr
	movl 	%eax, -52(%rbp)
	movq 	$.LC5, -56(%rbp)
	movl 	-56(%rbp), %eax
	movq 	-56(%rbp), %rdi
	call 	printStr
	movl 	%eax, -60(%rbp)
	movq 	$.LC6, -64(%rbp)
	movl 	-64(%rbp), %eax
	movq 	-64(%rbp), %rdi
	call 	printStr
	movl 	%eax, -68(%rbp)
	movq 	$.LC7, -72(%rbp)
	movl 	-72(%rbp), %eax
	movq 	-72(%rbp), %rdi
	call 	printStr
	movl 	%eax, -76(%rbp)
	movq 	$.LC8, -80(%rbp)
	movl 	-80(%rbp), %eax
	movq 	-80(%rbp), %rdi
	call 	printStr
	movl 	%eax, -84(%rbp)
	movq 	$.LC9, -88(%rbp)
	movl 	-88(%rbp), %eax
	movq 	-88(%rbp), %rdi
	call 	printStr
	movl 	%eax, -92(%rbp)
	movq 	$.LC10, -96(%rbp)
	movl 	-96(%rbp), %eax
	movq 	-96(%rbp), %rdi
	call 	printStr
	movl 	%eax, -100(%rbp)
	movq 	$.LC11, -104(%rbp)
	movl 	-104(%rbp), %eax
	movq 	-104(%rbp), %rdi
	call 	printStr
	movl 	%eax, -108(%rbp)
	movq 	$.LC12, -112(%rbp)
	movl 	-112(%rbp), %eax
	movq 	-112(%rbp), %rdi
	call 	printStr
	movl 	%eax, -116(%rbp)
	movq 	$.LC13, -120(%rbp)
	movl 	-120(%rbp), %eax
	movq 	-120(%rbp), %rdi
	call 	printStr
	movl 	%eax, -124(%rbp)
	movq 	$.LC14, -128(%rbp)
	movl 	-128(%rbp), %eax
	movq 	-128(%rbp), %rdi
	call 	printStr
	movl 	%eax, -132(%rbp)
	movq 	$.LC15, -136(%rbp)
	movl 	-136(%rbp), %eax
	movq 	-136(%rbp), %rdi
	call 	printStr
	movl 	%eax, -140(%rbp)
	movl	$0, %eax
	movl 	%eax, -144(%rbp)
	movl	-144(%rbp), %eax
	jmp	main_RETURN
main_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	main, .-main
	.ident		"generated by tinyC compiler"
	.ident		">> Hritaban Ghosh (19CS30053)"
	.ident		">> Nakul Aggarwal (19CS10044)"
	.section	.note.GNU-stack,"",@progbits
