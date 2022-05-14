	.file	"ass6_19CS10044_19CS30053_asm2.s"
	.section	.rodata
.LC0:
	.string	"\n\n"
.LC1:
	.string	" Enter n (< 20) : "
.LC2:
	.string	" nth Fibo no. : "
.LC3:
	.string	"\n nth Tribo no. : "
.LC4:
	.string	"\n\n"
	.text	
	.globl	FiboIter
	.type	FiboIter, @function
FiboIter:
.LFB0:
	.cfi_startproc
	endbr64
	pushq 	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$96, %rsp
	movq	%rdi, -20(%rbp)
	movl	$0, %eax
	movl 	%eax, -24(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jle .L2
	jmp .L3
	jmp .L3
.L2: 
	movl	$1, %eax
	movl 	%eax, -28(%rbp)
	negl	-28(%rbp)
	movl	-32(%rbp), %eax
	jmp	FiboIter_RETURN
	jmp .L3
.L3: 
	movl	$1, %eax
	movl 	%eax, -36(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-36(%rbp), %eax
	je .L4
	jmp .L5
	jmp .L5
.L4: 
	movl	$0, %eax
	movl 	%eax, -40(%rbp)
	movl	-40(%rbp), %eax
	jmp	FiboIter_RETURN
	jmp .L5
.L5: 
	movl	$2, %eax
	movl 	%eax, -44(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-44(%rbp), %eax
	je .L6
	jmp .L7
	jmp .L7
.L6: 
	movl	$1, %eax
	movl 	%eax, -48(%rbp)
	movl	-48(%rbp), %eax
	jmp	FiboIter_RETURN
	jmp .L7
.L7: 
	movl	$0, %eax
	movl 	%eax, -56(%rbp)
	movl	-56(%rbp), %eax
	movl 	%eax, -52(%rbp)
	movl	$1, %eax
	movl 	%eax, -64(%rbp)
	movl	-64(%rbp), %eax
	movl 	%eax, -60(%rbp)
	movl	$1, %eax
	movl 	%eax, -72(%rbp)
	movl	-72(%rbp), %eax
	movl 	%eax, -68(%rbp)
	movl	$4, %eax
	movl 	%eax, -80(%rbp)
	movl	-80(%rbp), %eax
	movl 	%eax, -76(%rbp)
.L8: 
	movl	-76(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jle .L10
	jmp .L11
.L9: 
	addl 	$1, -76(%rbp)
	jmp .L8
.L10: 
	movl	-60(%rbp), %eax
	movl 	%eax, -52(%rbp)
	movl	-68(%rbp), %eax
	movl 	%eax, -60(%rbp)
	movl 	-52(%rbp), %eax
	movl 	-60(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -88(%rbp)
	movl	-88(%rbp), %eax
	movl 	%eax, -68(%rbp)
	jmp .L9
.L11: 
	movl	-68(%rbp), %eax
	jmp	FiboIter_RETURN
FiboIter_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	FiboIter, .-FiboIter
	.globl	TriboIter
	.type	TriboIter, @function
TriboIter:
.LFB1:
	.cfi_startproc
	endbr64
	pushq 	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$116, %rsp
	movq	%rdi, -20(%rbp)
	movl	$0, %eax
	movl 	%eax, -24(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jle .L14
	jmp .L15
	jmp .L15
.L14: 
	movl	$1, %eax
	movl 	%eax, -28(%rbp)
	negl	-28(%rbp)
	movl	-32(%rbp), %eax
	jmp	TriboIter_RETURN
	jmp .L15
.L15: 
	movl	$1, %eax
	movl 	%eax, -36(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-36(%rbp), %eax
	je .L16
	jmp .L17
	jmp .L17
.L16: 
	movl	$0, %eax
	movl 	%eax, -40(%rbp)
	movl	-40(%rbp), %eax
	jmp	TriboIter_RETURN
	jmp .L17
.L17: 
	movl	$2, %eax
	movl 	%eax, -44(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-44(%rbp), %eax
	je .L18
	jmp .L19
	jmp .L19
.L18: 
	movl	$1, %eax
	movl 	%eax, -48(%rbp)
	movl	-48(%rbp), %eax
	jmp	TriboIter_RETURN
	jmp .L19
.L19: 
	movl	$3, %eax
	movl 	%eax, -52(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-52(%rbp), %eax
	je .L20
	jmp .L21
	jmp .L21
.L20: 
	movl	$2, %eax
	movl 	%eax, -56(%rbp)
	movl	-56(%rbp), %eax
	jmp	TriboIter_RETURN
	jmp .L21
.L21: 
	movl	$0, %eax
	movl 	%eax, -64(%rbp)
	movl	-64(%rbp), %eax
	movl 	%eax, -60(%rbp)
	movl	$1, %eax
	movl 	%eax, -72(%rbp)
	movl	-72(%rbp), %eax
	movl 	%eax, -68(%rbp)
	movl	$2, %eax
	movl 	%eax, -80(%rbp)
	movl	-80(%rbp), %eax
	movl 	%eax, -76(%rbp)
	movl	$3, %eax
	movl 	%eax, -88(%rbp)
	movl	-88(%rbp), %eax
	movl 	%eax, -84(%rbp)
	movl	$5, %eax
	movl 	%eax, -96(%rbp)
	movl	-96(%rbp), %eax
	movl 	%eax, -92(%rbp)
.L22: 
	movl	-92(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jle .L24
	jmp .L25
.L23: 
	addl 	$1, -92(%rbp)
	jmp .L22
.L24: 
	movl	-68(%rbp), %eax
	movl 	%eax, -60(%rbp)
	movl	-76(%rbp), %eax
	movl 	%eax, -68(%rbp)
	movl	-84(%rbp), %eax
	movl 	%eax, -76(%rbp)
	movl 	-60(%rbp), %eax
	movl 	-68(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -104(%rbp)
	movl 	-104(%rbp), %eax
	movl 	-76(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -108(%rbp)
	movl	-108(%rbp), %eax
	movl 	%eax, -84(%rbp)
	jmp .L23
.L25: 
	movl	-84(%rbp), %eax
	jmp	TriboIter_RETURN
TriboIter_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	TriboIter, .-TriboIter
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	endbr64
	pushq 	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$92, %rsp

	movq 	$.LC0, -24(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
	call 	printStr
	movl 	%eax, -28(%rbp)
	movq 	$.LC1, -36(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
	call 	printStr
	movl 	%eax, -40(%rbp)
	leaq	-32(%rbp), %rax
	movq 	%rax, -44(%rbp)
	movl 	-44(%rbp), %eax
	movq 	-44(%rbp), %rdi
	call 	readInt
	movl 	%eax, -48(%rbp)
	movq 	$.LC2, -52(%rbp)
	movl 	-52(%rbp), %eax
	movq 	-52(%rbp), %rdi
	call 	printStr
	movl 	%eax, -56(%rbp)
	movl 	-32(%rbp), %eax
	movq 	-32(%rbp), %rdi
	call 	FiboIter
	movl 	%eax, -60(%rbp)
	movl 	-60(%rbp), %eax
	movq 	-60(%rbp), %rdi
	call 	printInt
	movl 	%eax, -64(%rbp)
	movq 	$.LC3, -68(%rbp)
	movl 	-68(%rbp), %eax
	movq 	-68(%rbp), %rdi
	call 	printStr
	movl 	%eax, -72(%rbp)
	movl 	-32(%rbp), %eax
	movq 	-32(%rbp), %rdi
	call 	TriboIter
	movl 	%eax, -76(%rbp)
	movl 	-76(%rbp), %eax
	movq 	-76(%rbp), %rdi
	call 	printInt
	movl 	%eax, -80(%rbp)
	movq 	$.LC4, -84(%rbp)
	movl 	-84(%rbp), %eax
	movq 	-84(%rbp), %rdi
	call 	printStr
	movl 	%eax, -88(%rbp)
main_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.ident		"generated by tinyC compiler"
	.ident		">> Hritaban Ghosh (19CS30053)"
	.ident		">> Nakul Aggarwal (19CS10044)"
	.section	.note.GNU-stack,"",@progbits
