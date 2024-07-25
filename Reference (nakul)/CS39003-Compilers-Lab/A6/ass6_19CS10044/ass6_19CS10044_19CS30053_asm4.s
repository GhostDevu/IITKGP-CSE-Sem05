	.file	"ass6_19CS10044_19CS30053_asm4.s"
	.comm	__error__, 4, 4
	.comm	__stack_ptr__, 4, 4
	.comm	__stack__, 8192, 32
	.comm	__gbl_string__, 10, 32
	.comm	__gbl_charac__, 1, 1
	.section	.rodata
.LC0:
	.string	"\n\n"
.LC1:
	.string	" Enter x : "
.LC2:
	.string	" Enter y : "
.LC3:
	.string	" Enter z : "
.LC4:
	.string	" Select Tak(0) or Tarai(1) : "
.LC5:
	.string	" [ Invalid function choice ]\n\n"
.LC6:
	.string	" Tak(x, y, z) : "
.LC7:
	.string	" Tarai(x, y, z) : "
.LC8:
	.string	"\n\n"
	.text	
.L2: 
	movl	$2048, %eax
	movl 	%eax, 0(%rbp)
	movl	$10, %eax
	movl 	%eax, 0(%rbp)
	.globl	Tak
	.type	Tak, @function
Tak:
.LFB0:
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
	movl	$0, %eax
	movl 	%eax, -24(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jle .L5
	jmp .L3
.L3: 
	movl	$0, %eax
	movl 	%eax, -28(%rbp)
	movl	-16(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jle .L5
	jmp .L4
.L4: 
	movl	$0, %eax
	movl 	%eax, -32(%rbp)
	movl	-12(%rbp), %eax
	cmpl	-32(%rbp), %eax
	jle .L5
	jmp .L6
	jmp .L6
.L5: 
	movl	$0, %eax
	movl 	%eax, -36(%rbp)
	movl	-36(%rbp), %eax
	jmp	Tak_RETURN
	jmp .L6
.L6: 
	movl	-16(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl .L7
	jmp .L8
	jmp .L8
.L7: 
	movl	$1, %eax
	movl 	%eax, -44(%rbp)
	movl 	-20(%rbp), %eax
	movl 	-44(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -48(%rbp)
	movl 	-48(%rbp), %eax
	movq 	-48(%rbp), %rdi
	movl 	-16(%rbp), %eax
	movq 	-16(%rbp), %rsi
	movl 	-12(%rbp), %eax
	movq 	-12(%rbp), %rdx
	call 	Tak
	movl 	%eax, -52(%rbp)
	movl	-52(%rbp), %eax
	movl 	%eax, -40(%rbp)
	movl	$1, %eax
	movl 	%eax, -60(%rbp)
	movl 	-16(%rbp), %eax
	movl 	-60(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -64(%rbp)
	movl 	-64(%rbp), %eax
	movq 	-64(%rbp), %rdi
	movl 	-12(%rbp), %eax
	movq 	-12(%rbp), %rsi
	movl 	-20(%rbp), %eax
	movq 	-20(%rbp), %rdx
	call 	Tak
	movl 	%eax, -68(%rbp)
	movl	-68(%rbp), %eax
	movl 	%eax, -56(%rbp)
	movl	$1, %eax
	movl 	%eax, -76(%rbp)
	movl 	-12(%rbp), %eax
	movl 	-76(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -80(%rbp)
	movl 	-80(%rbp), %eax
	movq 	-80(%rbp), %rdi
	movl 	-20(%rbp), %eax
	movq 	-20(%rbp), %rsi
	movl 	-16(%rbp), %eax
	movq 	-16(%rbp), %rdx
	call 	Tak
	movl 	%eax, -84(%rbp)
	movl	-84(%rbp), %eax
	movl 	%eax, -72(%rbp)
	movl 	-40(%rbp), %eax
	movq 	-40(%rbp), %rdi
	movl 	-56(%rbp), %eax
	movq 	-56(%rbp), %rsi
	movl 	-72(%rbp), %eax
	movq 	-72(%rbp), %rdx
	call 	Tak
	movl 	%eax, -88(%rbp)
	movl	-88(%rbp), %eax
	jmp	Tak_RETURN
	jmp .L8
.L8: 
	movl	-12(%rbp), %eax
	jmp	Tak_RETURN
Tak_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	Tak, .-Tak
	.globl	Tarai
	.type	Tarai, @function
Tarai:
.LFB1:
	.cfi_startproc
	endbr64
	pushq 	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -12(%rbp)
.L11: 
	movl	-20(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jg .L12
	jmp .L4
.L12: 
	movl	-20(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	-16(%rbp), %eax
	movl 	%eax, -28(%rbp)
	movl	$1, %eax
	movl 	%eax, -32(%rbp)
	movl 	-20(%rbp), %eax
	movl 	-32(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -36(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
	movl 	-16(%rbp), %eax
	movq 	-16(%rbp), %rsi
	movl 	-12(%rbp), %eax
	movq 	-12(%rbp), %rdx
	call 	Tarai
	movl 	%eax, -40(%rbp)
	movl	-40(%rbp), %eax
	movl 	%eax, -20(%rbp)
	movl	$1, %eax
	movl 	%eax, -44(%rbp)
	movl 	-16(%rbp), %eax
	movl 	-44(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -48(%rbp)
	movl 	-48(%rbp), %eax
	movq 	-48(%rbp), %rdi
	movl 	-12(%rbp), %eax
	movq 	-12(%rbp), %rsi
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdx
	call 	Tarai
	movl 	%eax, -52(%rbp)
	movl	-52(%rbp), %eax
	movl 	%eax, -16(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jle .L13
	jmp .L14
	jmp .L14
.L13: 
	movl	-16(%rbp), %eax
	jmp	Tarai_RETURN
	jmp .L14
.L14: 
	movl	$1, %eax
	movl 	%eax, -56(%rbp)
	movl 	-12(%rbp), %eax
	movl 	-56(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -60(%rbp)
	movl 	-60(%rbp), %eax
	movq 	-60(%rbp), %rdi
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rsi
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdx
	call 	Tarai
	movl 	%eax, -64(%rbp)
	movl	-64(%rbp), %eax
	movl 	%eax, -12(%rbp)
	jmp .L11
Tarai_RETURN:
	leave
	.cfi_restore 5
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	Tarai, .-Tarai
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
	subq	$208, %rsp

	movq 	$.LC0, -24(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
	call 	printStr
	movl 	%eax, -28(%rbp)
	movl	$1, %eax
	movl 	%eax, -32(%rbp)
	negl	-32(%rbp)
	movl	-36(%rbp), %eax
	movl 	%eax, 0(%rbp)
	movq 	$.LC1, -52(%rbp)
	movl 	-52(%rbp), %eax
	movq 	-52(%rbp), %rdi
	call 	printStr
	movl 	%eax, -56(%rbp)
	leaq	-40(%rbp), %rax
	movq 	%rax, -60(%rbp)
	movl 	-60(%rbp), %eax
	movq 	-60(%rbp), %rdi
	call 	readInt
	movl 	%eax, -64(%rbp)
	movq 	$.LC2, -68(%rbp)
	movl 	-68(%rbp), %eax
	movq 	-68(%rbp), %rdi
	call 	printStr
	movl 	%eax, -72(%rbp)
	leaq	-44(%rbp), %rax
	movq 	%rax, -76(%rbp)
	movl 	-76(%rbp), %eax
	movq 	-76(%rbp), %rdi
	call 	readInt
	movl 	%eax, -80(%rbp)
	movq 	$.LC3, -84(%rbp)
	movl 	-84(%rbp), %eax
	movq 	-84(%rbp), %rdi
	call 	printStr
	movl 	%eax, -88(%rbp)
	leaq	-48(%rbp), %rax
	movq 	%rax, -92(%rbp)
	movl 	-92(%rbp), %eax
	movq 	-92(%rbp), %rdi
	call 	readInt
	movl 	%eax, -96(%rbp)
	movl	$1, %eax
	movl 	%eax, -104(%rbp)
	negl	-104(%rbp)
	movl	-108(%rbp), %eax
	movl 	%eax, -100(%rbp)
	movq 	$.LC4, -112(%rbp)
	movl 	-112(%rbp), %eax
	movq 	-112(%rbp), %rdi
	call 	printStr
	movl 	%eax, -116(%rbp)
	leaq	-100(%rbp), %rax
	movq 	%rax, -120(%rbp)
	movl 	-120(%rbp), %eax
	movq 	-120(%rbp), %rdi
	call 	readInt
	movl 	%eax, -124(%rbp)
	movl	$0, %eax
	movl 	%eax, -128(%rbp)
	movl	-100(%rbp), %eax
	cmpl	-128(%rbp), %eax
	jne .L17
	jmp .L19
.L17: 
	movl	$1, %eax
	movl 	%eax, -132(%rbp)
	movl	-100(%rbp), %eax
	cmpl	-132(%rbp), %eax
	jne .L18
	jmp .L19
	jmp .L19
.L18: 
	movq 	$.LC5, -136(%rbp)
	movl 	-136(%rbp), %eax
	movq 	-136(%rbp), %rdi
	call 	printStr
	movl 	%eax, -140(%rbp)
	movl	$0, %eax
	movl 	%eax, -144(%rbp)
	movl	-144(%rbp), %eax
	jmp	main_RETURN
	jmp .L19
.L19: 
	movl	$0, %eax
	movl 	%eax, -148(%rbp)
	movl	-100(%rbp), %eax
	cmpl	-148(%rbp), %eax
	je .L20
	jmp .L21
	jmp .L22
.L20: 
	movl	$0, %eax
	movl 	%eax, -152(%rbp)
	movl	-152(%rbp), %eax
	movl 	%eax, 0(%rbp)
	movl 	-40(%rbp), %eax
	movq 	-40(%rbp), %rdi
	movl 	-44(%rbp), %eax
	movq 	-44(%rbp), %rsi
	movl 	-48(%rbp), %eax
	movq 	-48(%rbp), %rdx
	call 	Tak
	movl 	%eax, -160(%rbp)
	movl	-160(%rbp), %eax
	movl 	%eax, -156(%rbp)
	movq 	$.LC6, -164(%rbp)
	movl 	-164(%rbp), %eax
	movq 	-164(%rbp), %rdi
	call 	printStr
	movl 	%eax, -168(%rbp)
	movl 	-156(%rbp), %eax
	movq 	-156(%rbp), %rdi
	call 	printInt
	movl 	%eax, -172(%rbp)
	jmp .L22
.L21: 
	movl	$0, %eax
	movl 	%eax, -176(%rbp)
	movl	-176(%rbp), %eax
	movl 	%eax, 0(%rbp)
	movl 	-40(%rbp), %eax
	movq 	-40(%rbp), %rdi
	movl 	-44(%rbp), %eax
	movq 	-44(%rbp), %rsi
	movl 	-48(%rbp), %eax
	movq 	-48(%rbp), %rdx
	call 	Tarai
	movl 	%eax, -180(%rbp)
	movl	-180(%rbp), %eax
	movl 	%eax, -156(%rbp)
	movq 	$.LC7, -184(%rbp)
	movl 	-184(%rbp), %eax
	movq 	-184(%rbp), %rdi
	call 	printStr
	movl 	%eax, -188(%rbp)
	movl 	-156(%rbp), %eax
	movq 	-156(%rbp), %rdi
	call 	printInt
	movl 	%eax, -192(%rbp)
.L22: 
	movq 	$.LC8, -196(%rbp)
	movl 	-196(%rbp), %eax
	movq 	-196(%rbp), %rdi
	call 	printStr
	movl 	%eax, -200(%rbp)
	movl	$0, %eax
	movl 	%eax, -204(%rbp)
	movl	-204(%rbp), %eax
	jmp	main_RETURN
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
