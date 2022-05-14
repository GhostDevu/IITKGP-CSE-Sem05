	.file	"ass6_19CS10044_19CS30053_asm1.s"
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
	.globl	FiboRec
	.type	FiboRec, @function
FiboRec:
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
	jmp	FiboRec_RETURN
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
	jmp	FiboRec_RETURN
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
	jmp	FiboRec_RETURN
	jmp .L7
.L7: 
	movl	$1, %eax
	movl 	%eax, -52(%rbp)
	movl 	-20(%rbp), %eax
	movl 	-52(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -56(%rbp)
	movl 	-56(%rbp), %eax
	movq 	-56(%rbp), %rdi
	call 	FiboRec
	movl 	%eax, -60(%rbp)
	movl	$2, %eax
	movl 	%eax, -64(%rbp)
	movl 	-20(%rbp), %eax
	movl 	-64(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -68(%rbp)
	movl 	-68(%rbp), %eax
	movq 	-68(%rbp), %rdi
	call 	FiboRec
	movl 	%eax, -72(%rbp)
	movl 	-60(%rbp), %eax
	movl 	-72(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -76(%rbp)
	movl	-76(%rbp), %eax
	jmp	FiboRec_RETURN
FiboRec_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	FiboRec, .-FiboRec
	.globl	TriboRec
	.type	TriboRec, @function
TriboRec:
.LFB1:
	.cfi_startproc
	endbr64
	pushq 	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$108, %rsp
	movq	%rdi, -20(%rbp)
	movl	$0, %eax
	movl 	%eax, -24(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jle .L10
	jmp .L11
	jmp .L11
.L10: 
	movl	$1, %eax
	movl 	%eax, -28(%rbp)
	negl	-28(%rbp)
	movl	-32(%rbp), %eax
	jmp	TriboRec_RETURN
	jmp .L11
.L11: 
	movl	$1, %eax
	movl 	%eax, -36(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-36(%rbp), %eax
	je .L12
	jmp .L13
	jmp .L13
.L12: 
	movl	$0, %eax
	movl 	%eax, -40(%rbp)
	movl	-40(%rbp), %eax
	jmp	TriboRec_RETURN
	jmp .L13
.L13: 
	movl	$2, %eax
	movl 	%eax, -44(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-44(%rbp), %eax
	je .L14
	jmp .L15
	jmp .L15
.L14: 
	movl	$1, %eax
	movl 	%eax, -48(%rbp)
	movl	-48(%rbp), %eax
	jmp	TriboRec_RETURN
	jmp .L15
.L15: 
	movl	$3, %eax
	movl 	%eax, -52(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-52(%rbp), %eax
	je .L16
	jmp .L17
	jmp .L17
.L16: 
	movl	$2, %eax
	movl 	%eax, -56(%rbp)
	movl	-56(%rbp), %eax
	jmp	TriboRec_RETURN
	jmp .L17
.L17: 
	movl	$1, %eax
	movl 	%eax, -60(%rbp)
	movl 	-20(%rbp), %eax
	movl 	-60(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -64(%rbp)
	movl 	-64(%rbp), %eax
	movq 	-64(%rbp), %rdi
	call 	TriboRec
	movl 	%eax, -68(%rbp)
	movl	$2, %eax
	movl 	%eax, -72(%rbp)
	movl 	-20(%rbp), %eax
	movl 	-72(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -76(%rbp)
	movl 	-76(%rbp), %eax
	movq 	-76(%rbp), %rdi
	call 	TriboRec
	movl 	%eax, -80(%rbp)
	movl 	-68(%rbp), %eax
	movl 	-80(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -84(%rbp)
	movl	$3, %eax
	movl 	%eax, -88(%rbp)
	movl 	-20(%rbp), %eax
	movl 	-88(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -92(%rbp)
	movl 	-92(%rbp), %eax
	movq 	-92(%rbp), %rdi
	call 	TriboRec
	movl 	%eax, -96(%rbp)
	movl 	-84(%rbp), %eax
	movl 	-96(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -100(%rbp)
	movl	-100(%rbp), %eax
	jmp	TriboRec_RETURN
TriboRec_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	TriboRec, .-TriboRec
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
	call 	FiboRec
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
	call 	TriboRec
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
