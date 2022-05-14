	.file	"ass1.c"									# name of the source file from which this assembly code was generated
	.text												# codes starts -- switch to the text segment (where code goes); define the current section as ".text"
	.section	.rodata									# read-only data section
	.align 8											# align with 8-byte boundary
.LC0:													# [LABEL] of f-string (1st printf statement on line 11)
	.string	"Enter how many elements you want:"			# the actual string passed as arguement in printf on line 11
.LC1:													# [LABEL] of f-string for scanf statement(s)
	.string	"%d"										# the actual string passed as arguement in scanf statement(s)
.LC2:													# [LABEL] of f-string (2nd printf statement on line 14)
	.string	"Enter the %d elements:\n"					# the actual string passed as arguement in printf on line 14
.LC3:													# [LABEL] of f-string (3rd printf statement on line 19)
	.string	"\nEnter the item to search"				# the actual string passed as arguement in printf on line 19
.LC4:													# [LABEL] of f-string (4th printf statement on line 24)
	.string	"\n%d found in position: %d\n"				# the actual string passed as arguement in printf on line 24
	.align 8											# align with 8-byte boundary
.LC5:													# [LABEL] of f-string (5th printf statement on line 26)
	.string	"\nItem is not present in the list."		# the actual string passed as arguement in printf on line 26
	.text												# codes starts -- switch to the text segment (where code goes); define the current section as ".text"
	.globl	main										# "main" is a global name
	.type	main, @function								# "main" is a function
main:													# main function starts
.LFB0:													# [LABEL] -- stack-frame allocation for main function and declaration of local variables
	.cfi_startproc										# call frame information
	endbr64												# terminate indirect branch in 64 bits
	pushq	%rbp										# save old base pointer
	.cfi_def_cfa_offset 16								# CFI directive
	.cfi_offset 6, -16									# CFI directive
	movq	%rsp, %rbp									# rbp <-- rsp (set new stack base pointer)
	.cfi_def_cfa_register 6								# CFI directive
	subq	$432, %rsp									# create space for local array and variables in main function scope (allocate 432 bytes on stack frame)
	movq	%fs:40, %rax								# rax <-- fs:40 (fs:40 stores special sentinel stack-guard value) -- used in performing stack-guard check later
	movq	%rax, -8(%rbp)								# (rbp - 8) <-- rax (move stack-guard value stored in rax register to (rbp - 8))
	xorl	%eax, %eax									# set 0 as return value (set integer register to 0)
	leaq	.LC0(%rip), %rdi							# load effective starting address of .LC0 format string to rdi (first parameter to first printf function call on line 11)
	call	puts@PLT									# call to "puts" function to print the string on the console -- first printf (line 11) -- first parameter stored in rdi
	leaq	-432(%rbp), %rax							# rax <-- &(rbp - 432) (load effective address of "n" integer variable, i.e, rax <-- &n)
	movq	%rax, %rsi									# rsi <-- rax (move value stored in rax register to rsi register, i.e, rsi <-- &n)
	leaq	.LC1(%rip), %rdi							# load effective starting address of .LC1 format string to rdi (first parameter to scanf function call on line 12)
	movl	$0, %eax									# eax <-- 0 (move 0 to eax register)
	call	__isoc99_scanf@PLT							# first call to scanf function (on line 12) to scan the value of "n" integer variable -- first, second parameters stored in rdi, rsi respectively
	movl	-432(%rbp), %eax							# eax <-- rbp - 432 (move the scanned value of "n" to eax register, i.e, eax <-- n)
	movl	%eax, %esi									# esi <-- eax (move value stored in eax register to esi, i.e, esi <-- n) --- second parameter to second printf function call (line 14)     
	leaq	.LC2(%rip), %rdi							# load effective starting address of .LC2 format string to rdi (first parameter to second printf function call on line 14)
	movl	$0, %eax									# eax <-- 0 (move 0 to eax register)
	call	printf@PLT									# second printf call (line 14) -- first, second parameters stored in rdi, esi respectively
	movl	$0, -424(%rbp)								# (rbp - 424) <-- 0 (assign "i" integer variable value of 0, i.e, i <-- 0) -- initialization step in for-loop definition on line 15
	jmp	.L2												# go to the begining of the for-loop (line 15)
.L3:													# [LABEL] -- for-loop in main function (line 15)
	leaq	-416(%rbp), %rax							# rax <-- &(rbp - 416) (load effective address of first element of "a" integer array, i.e, {rax <-- &a[0]} or {rax <-- &a} or {rax <-- a})
	movl	-424(%rbp), %edx							# edx <-- (rbp - 424) (move value stored in (rbp - 424) to edx register, i.e, edx <-- i)
	movslq	%edx, %rdx									# rdx <-- signExt(edx) (rdx <-- signExt(i))
	salq	$2, %rdx									# rdx <-- rdx << 2 (arithmetic left shift by 2 places, stored value becomes 4 times, i.e, rdx <-- 4 * i)
	addq	%rdx, %rax									# rax <-- rax + rdx (rax stores "&a + 4 * i", which is the address of "a[i]", i.e, rax <-- &a[i])
	movq	%rax, %rsi									# rsi <-- rax (move value stored in rax register to rsi register, i.e, rsi <-- &a[i])
	leaq	.LC1(%rip), %rdi							# load effective starting address of .LC1 format string to rdi (first parameter to scanf function call on line 15, inside for-loop)
	movl	$0, %eax									# eax <-- 0 (move 0 to eax register)
	call	__isoc99_scanf@PLT							# call to scanf function (on line 15, inside for-loop) to scan the value of "a[i]" -- first, second parameters stored in rdi, rsi respectively
	addl	$1, -424(%rbp)								# (rbp - 424) <-- (rbp - 424) + 1 ("i" integer variable is incremented by 1 in increment step of for-loop definition on line 15, i.e, i <-- i + 1)
.L2:													# [LABEL] -- iteration over for-loop inside main function & post for-loop statements 
	movl	-432(%rbp), %eax							# eax <-- (rbp - 432) (move value stored in (rbp - 432) to eax register, i.e, eax <-- n)
	cmpl	%eax, -424(%rbp)							# compare values stored in eax ("n" integer variable) and (rbp - 424) ("i" integer variable) --- condition of for-loop defined in line 15
	jl	.L3												# jump if less, i.e, jump to .L3 to execute the statement(s) inside for-loop if value stored in (rbp - 424) is less than in eax register (i.e, if i < n)
	movl	-432(%rbp), %edx							# edx <-- (rbp - 432) (move value stored in (rbp - 432) to edx register, i.e, edx <-- n) --- (for second parameter to "inst_sort" function call; line 17)
	leaq	-416(%rbp), %rax							# rax <-- &(rbp - 416) (load effective address of first element of "a" integer array to rax, i.e, rax <-- &a or rax <-- a) --- (for first parameter to "inst_sort" function call; line 17)
	movl	%edx, %esi									# esi <-- edx (move value stored in edx to esi register, i.e, esi <-- n)
	movq	%rax, %rdi									# rdi <-- rax (move value stored in rax to rdi register, i.e, rdi <-- a)
	call	inst_sort									# call "inst_sort" function (callee function is "main" -- line 17) with first, second parameters stored in rdi, esi respectively
	leaq	.LC3(%rip), %rdi							# load effective starting address of .LC3 format string to rdi (first parameter to third printf function call on line 19)
	call	puts@PLT									# call to "puts" function to print the string on the console -- third printf (line 19) -- first parameter stored in rdi
	leaq	-428(%rbp), %rax							# rax <-- &(rbp - 428) (load effective address of "item" integer variable, i.e, rax <-- &item)
	movq	%rax, %rsi									# rsi <-- rax (move value stored in rax to rsi register, i.e, rsi <-- &item)
	leaq	.LC1(%rip), %rdi							# load effective starting address of .LC1 format string to rdi (first parameter to scanf function call on line 20)
	movl	$0, %eax									# eax <-- 0 (move 0 to eax register)
	call	__isoc99_scanf@PLT							# call to scanf function (on line 20) to scan the value of "item" integer variable -- first, second parameters stored in rdi, rsi respectively
	movl	-428(%rbp), %edx							# edx <-- (rbp - 428) (move value of variable stored in (rbp - 428) to edx register, i.e, edx <-- item) --- (for third parameter of "bsearch" function call; line 21)
	movl	-432(%rbp), %ecx							# ecx <-- (rbp - 432) (move value of variable stored in (rbp - 432) to ecx register, i.e, ecx <-- n) --- (for second parameter of "bsearch" function call; line 21)
	leaq	-416(%rbp), %rax							# rax <-- &(rbp - 416) (load effective address of first element of "a" integer array to rax, i.e, rax <-- &a or rax <-- a) --- (for first parameter of "bsearch" function call; line 21)
	movl	%ecx, %esi									# esi <-- ecx (move value stored in ecx to esi register, i.e, esi <-- n)
	movq	%rax, %rdi									# rdi <-- rax (move value stored in rax to rdi register, i.e, rdi <-- a)
	call	bsearch										# call "bsearch" function (callee function is "main" -- line 21) with first, second, third parameters stored in rdi, esi, edx respectively
	movl	%eax, -420(%rbp)							# (rbp - 420) <-- eax  (assign to "loc" integer variable the value returned from call to bsearch function, i.e, loc <-- bsearch(a,n,item))
	movl	-420(%rbp), %eax							# eax <-- (rbp - 420)  (move value of variable stored in (rbp - 420) to eax register, i.e, eax <-- loc)
	cltq												# rax <-- signExt(eax) (rax <-- signExt(loc))
	movl	-416(%rbp,%rax,4), %edx						# edx <-- Mem[(rbp - 416) + 4 * rax] (move the value of "a[loc]" to edx register  (or)  edx <-- a[loc])
	movl	-428(%rbp), %eax							# eax <-- (rbp - 428) (move value stored in (rbp - 428) to eax register, i.e, eax <-- item)
	cmpl	%eax, %edx									# compare values stored in eax ("item" integer variable) and edx (value of "a[loc]") --- "if" condition in line 23
	jne	.L4												# jump if not equal, i.e, jump to .L4 to execute the else-block statement(s) if values stored in eax and edx registers are unequal, i.e, if (item != a[loc])
	movl	-420(%rbp), %eax							# eax <-- (rbp - 420) (move value stored in (rbp - 420) to eax register, i.e, eax <-- loc)
	leal	1(%rax), %edx								# edx <-- (rax + 1)   (edx <-- loc + 1) -- third parameter to fourth printf function call, on line 24 inside "if" statement block
	movl	-428(%rbp), %eax							# eax <-- (rbp - 428) (move value stored in (rbp - 428) to eax register, i.e, eax <-- item)
	movl	%eax, %esi									# esi <-- eax (move value stored in eax to esi register, i.e, esi <-- item) -- second parameter to fourth printf function call, on line 24 inside "if" statement block
	leaq	.LC4(%rip), %rdi							# load effective starting address of .LC4 format string to rdi (first parameter to fourth printf function call on line 24, in "if" statement block)
	movl	$0, %eax									# eax <-- 0 (move 0 to eax register)
	call	printf@PLT									# fourth printf call (line 24, inside "if" block) -- first, second, third parameters stored in rdi, esi, edx respectively
	jmp	.L5												# goto .L5 (skip the "else" block) to deallocate stack frame memory and return from main function 
.L4:													# [LABEL] -- else-statement block (line 25) in main function
	leaq	.LC5(%rip), %rdi							# load effective starting address of .LC5 format string to rdi (first parameter to fifth printf function call on line 26, in "else" statement block)
	call	puts@PLT									# call to "puts" to print the string on the console -- fifth printf (line 26) -- first parameter stored in rdi
.L5:													# [LABEL] -- check for stack corruption by matching sentinel stack-guard values
	movl	$0, %eax									# eax <-- 0 (move 0 to eax register, return 0)
	movq	-8(%rbp), %rcx								# rcx <-- (rbp - 8) (move stack-guard value stored in (rbp - 8) to rcx)
	xorq	%fs:40, %rcx								# rcx <-- rcx ^ (fs:40) (rcx register stores 0 iff values stored in rcx and (fs:40) are equal, i.e, match successful) -- stack guard check
	je	.L7												# jump if equal, i.e, goto .L7 label to clear stack-frame and return if rcx stores 0 value (non-zero XOR value indicates that values stored in (rbp - 8) and fs:40 are no longer equal, hence stack was corrupted)
	call	__stack_chk_fail@PLT						# abort the main function because stack was corrupted and sentinel value stored on stack was changed
.L7:													# [LABEL] -- stack frame de-allocation, returning from main function
	leave												# clear stack
	.cfi_def_cfa 7, 8									# CFI directive
	ret													# return from main function (value stored in eax register (0) is returned)
	.cfi_endproc										# CFI directive
.LFE0:													# [LABEL]
	.size	main, .-main								# ".size symbol, expr" declares symbol size to be expr
	.globl	inst_sort									# "inst_sort" is a global name
	.type	inst_sort, @function						# inst_sort is a function
inst_sort:												# inst_sort starts
.LFB1:													# [LABEL] -- stack-frame allocation for inst_sort function and declaration of local variables
	.cfi_startproc										# call frame information
	endbr64												# terminate indirect branch in 64 bits
	pushq	%rbp										# save old base pointer register
	.cfi_def_cfa_offset 16								# CFI directive
	.cfi_offset 6, -16									# CFI directive
	movq	%rsp, %rbp									# rbp <-- rsp (set new stack base pointer)
	.cfi_def_cfa_register 6								# CFI directive
	movq	%rdi, -24(%rbp)								# (rbp - 24) <-- rdi (move value stored in rdi to (rbp - 24), i.e, (rbp - 24) <-- &num  (or)  (rbp - 24) <-- num)
	movl	%esi, -28(%rbp)								# (rbp - 28) <-- esi (move value stored in esi to (rbp - 28), i.e, (rbp - 28) <-- n)
	movl	$1, -8(%rbp)								# (rbp - 8) <-- 1 ("j" integer variable assigned value of 1, i.e, j <-- 1) --- initialization step in outer-for-loop defined in line 36
	jmp	.L9												# go to the begining of the outer-for-loop (line 36)
.L13:													# [LABEL] -- outer-for-loop in inst_sort function (line 36)
	movl	-8(%rbp), %eax								# eax <-- (rbp - 8) (move value stored in (rbp - 8) to eax, i.e, eax <-- j)
	cltq												# rax <-- signExt(eax) (rax <-- signExt(j))
	leaq	0(,%rax,4), %rdx							# rdx <-- 4 * rax (rdx register stores 4 times the value stored in rax, i.e, rdx <-- 4*j)
	movq	-24(%rbp), %rax								# rax <-- (rbp - 24) (move value stored in (rbp - 24) to rax, i.e, rax <-- &num  (or)  rax <-- num)
	addq	%rdx, %rax									# rax <-- rax + rdx (rax stores "&num + 4 * j", which is the address of "num[j]", i.e, rax <-- &num[j])
	movl	(%rax), %eax								# eax <-- Mem[rax]  (move value stored in the memory at the address stored in rax to eax, i.e, eax <-- *rax  (or)  eax <-- num[j])
	movl	%eax, -4(%rbp)								# (rbp - 4) <-- eax (move value stored in eax to (rbp - 4), i.e, (rbp - 4) <-- num[j]  (or)  k <-- num[j]) --- assignment statement on line 37
	movl	-8(%rbp), %eax								# eax <-- (rbp - 8) (move value stored in (rbp - 8) to eax, i.e, eax <-- j)
	subl	$1, %eax									# eax <-- eax - 1 (value stored in eax register is reduced by 1, i.e, eax <-- j-1)
	movl	%eax, -12(%rbp)								# (rbp - 12) <-- eax ("i" integer variable assigned value of (j-1), i.e, i <-- j-1) --- initialization step in inner-for-loop defined in line 38
	jmp	.L10											# goto to .L10 to iterate over the inner-for-loop
.L12:													# [LABEL] -- inner-for-loop in inst_sort function (line 38)
	movl	-12(%rbp), %eax								# eax <-- (rbp - 12) (move value stored in (rbp - 12) to eax, i.e, eax <-- i)
	cltq												# rax <-- signExt(eax) (rax <-- signExt(i))
	leaq	0(,%rax,4), %rdx							# rdx <-- 4 * rax (rdx register stores 4 times the value stored in rax, i.e, rdx <-- 4*i)
	movq	-24(%rbp), %rax								# rax <-- (rbp - 24) (move value stored in (rbp - 24) to rax, i.e, rax <-- &num  (or)  rax <-- num)
	addq	%rdx, %rax									# rax <-- rax + rdx (rax stores "&num + 4 * i", which is the address of "num[i]", i.e, rax <-- &num[i])
	movl	-12(%rbp), %edx								# edx <-- (rbp - 12) (move value stored in (rbp - 12) to edx, i.e, edx <-- i)
	movslq	%edx, %rdx									# rdx <-- signExt(edx) (rdx <-- signExt(i))
	addq	$1, %rdx									# rdx <-- 1 + rdx (rdx register stores 1 more than its old value, i.e, rdx <-- i+1)
	leaq	0(,%rdx,4), %rcx							# rcx <-- 4 * rdx (rcx register stores 4 times the value stored in rdx, i.e, rcx <-- 4*(i+1))
	movq	-24(%rbp), %rdx								# rdx <-- (rbp - 24) (move value stored in (rbp - 24) to rdx, i.e, rdx <-- &num  (or)  rdx <-- num)
	addq	%rcx, %rdx									# rdx <-- rdx + rcx (rdx stores "&num + 4 * (i+1)", which is the address of "num[i+1]", i.e, rdx <-- &num[i+1])
	movl	(%rax), %eax								# eax <-- Mem[rax] (move value stored in the memory at the address stored in rax to eax, i.e, eax <-- *rax  (or)  eax <-- num[i])
	movl	%eax, (%rdx)								# Mem[rdx] <-- eax (move value stored in eax to the memory at the address stored in rdx, i.e, Mem[rdx] <-- num[i]  (or)  num[i+1] <-- num[i]) --- assignment statement inside inner-for-loop (line 38)
	subl	$1, -12(%rbp)								# (rbp - 12) <-- (rbp - 12) - 1 ("i" integer variable is decremented by 1 in decrement step of inner-for-loop definition on line 38, i.e, i <-- i-1)
.L10:													# [LABEL] -- conditionally re-iterating over the inner-for-loop in inst_sort function
	cmpl	$0, -12(%rbp)								# compare value stored in (rbp - 12) ("i" integer variable) and 0 --- condition step in inner-for-loop declaration, line 38
	js	.L11											# jump if sign flag is set, i.e, jump to .L11 (break out of inner-for-loop) if the comparison yielded negative value, i.e, the difference (i-0) is negative  (or)  (i < 0)
	movl	-12(%rbp), %eax								# eax <-- rbp - 12 (move value stored in (rbp - 12) to eax, i.e, eax <-- i)
	cltq												# rax <-- signExt(eax) (rax <-- signExt(i))
	leaq	0(,%rax,4), %rdx							# rdx <-- 4 * rax (rdx register stores 4 times the value stored in rax, i.e, rdx <-- 4*i)
	movq	-24(%rbp), %rax								# rax <-- (rbp - 24) (move value stored in (rbp - 24) to rax, i.e, rax <-- &num  (or)  rax <-- num)
	addq	%rdx, %rax									# rax <-- rax + rdx (rax stores "&num + 4 * i", which is the address of "num[i]", i.e, rax <-- &num[i])
	movl	(%rax), %eax								# eax <-- Mem[rax] (move value stored in the memory at the address stored in rax to eax, i.e, eax <-- *rax  (or)  eax <-- num[i])
	cmpl	%eax, -4(%rbp)								# compare values stored in (rbp - 4) ("k" integer variable) and eax ("num[i]") --- condition step in inner-for-loop declaration, line 38
	jl	.L12											# jump if less than, i.e, jump to .L12 to execute the inner-for-loop statement(s) if value stored in (rbp - 4) is less than in eax, i.e, (k < num[i])
.L11:													# [LABEL] -- outer-for-loop statements in inst_sort post the inner-for-loop termination (line 39)
	movl	-12(%rbp), %eax								# eax <-- rbp - 12 (move value stored in (rbp - 12) to eax, i.e, eax <-- i)
	cltq												# rax <-- signExt(eax) (rax <-- signExt(i))
	addq	$1, %rax									# rax <-- 1 + rax (rax register stores 1 more than its old value, i.e, rax <-- i+1)
	leaq	0(,%rax,4), %rdx							# rdx <-- 4 * rax (rdx register stores 4 times the value stored in rax, i.e, rdx <-- 4*(i+1))
	movq	-24(%rbp), %rax								# rax <-- (rbp - 24) (move value stored in (rbp - 24) to rax, i.e, rax <-- &num  (or)  rax <-- num)
	addq	%rax, %rdx									# rdx <-- rdx + rax (rdx stores "&num + 4 * (i+1)", which is the address of "num[i+1]", i.e, rdx <-- &num[i+1])
	movl	-4(%rbp), %eax								# eax <-- rbp - 4 (move value stored in (rbp - 4) to eax, i.e, eax <-- k)
	movl	%eax, (%rdx)								# Mem[rdx] <-- eax (move value stored in eax to the memory at the address stored in rdx, i.e, Mem[rdx] <-- k  (or)  num[i+1] <-- k) --- assignment statement inside outer-for-loop (line 39)
	addl	$1, -8(%rbp)								# rbp - 8 <-- (rbp - 8) + 1 ("j" integer variable is incremented by 1 in increment step of outer-for-loop definition on line 36, i.e, j <-- j + 1)
.L9:													# [LABEL] -- for-loop execution, stack frame de-allocation, returning from inst_sort function
	movl	-8(%rbp), %eax								# eax <-- (rbp - 8) (move value stored in (rbp - 8) to eax, i.e, eax <-- j)
	cmpl	-28(%rbp), %eax								# compare values stored in (rbp - 28) ("n" integer variable) and eax ("j" integer variable) --- condition step in outer-for-loop declaration, line 36
	jl	.L13											# jump if less than, i.e, jump to .L13 to execute the outer-for-loop statement(s) if value stored in eax is less than in (rbp - 28), i.e, (j < n)
	nop													# no operation (does nothing)
	nop													# no operation (does nothing)
	popq	%rbp										# pop base pointer register from the stack-frame
	.cfi_def_cfa 7, 8									# CFI directive
	ret													# return from "inst_sort" function
	.cfi_endproc										# CFI directive
.LFE1:													# [LABEL]
	.size	inst_sort, .-inst_sort						# ".size symbol, expr" declares symbol size to be expr
	.globl	bsearch										# "bsearch" is a global name
	.type	bsearch, @function							# bsearch is a function
bsearch:												# bsearch starts
.LFB2:													# [LABEL] -- stack-frame allocation for bsearch function and declaration of local variables
	.cfi_startproc										# call frame information
	endbr64												# terminate indirect branch in 64 bits
	pushq	%rbp										# save old base pointer register
	.cfi_def_cfa_offset 16								# CFI directive
	.cfi_offset 6, -16									# CFI directive
	movq	%rsp, %rbp									# rbp <-- rsp (set new stack base pointer)
	.cfi_def_cfa_register 6								# CFI directive
	movq	%rdi, -24(%rbp)								# (rbp - 24) <-- rdi (move value stored in rdi to (rbp - 24), i.e, (rbp - 24) <-- &a  (or)  (rbp - 24) <-- a)
	movl	%esi, -28(%rbp)								# (rbp - 28) <-- esi (move value stored in esi to (rbp - 28), i.e, (rbp - 28) <-- n)
	movl	%edx, -32(%rbp)								# (rbp - 32) <-- edx (move value stored in edx to (rbp - 32), i.e, (rbp - 32) <-- item)
	movl	$1, -8(%rbp)								# (rbp - 8) <-- 1 (assign 1 to the value stored in (rbp - 8), i.e, bottom <-- 1) --- assignment statement on line 47
	movl	-28(%rbp), %eax								# eax <-- (rbp - 28) (move value stored in (rbp - 28) to eax, i.e, eax <-- n)
	movl	%eax, -12(%rbp)								# (rbp - 12) <-- eax (move value stored in eax to (rbp - 12), i.e, (rbp - 12) <-- n  (or)  top <-- n) --- assignment statement on line 48
.L18:													# [LABEL] -- start of do-while loop in bsearch function (line 49)
	movl	-8(%rbp), %edx								# edx <-- (rbp - 8) (move value stored in (rbp - 8) to edx, i.e, edx <-- bottom)
	movl	-12(%rbp), %eax								# eax <-- (rbp - 12) (move value stored in (rbp - 12) to eax, i.e, eax <-- top)
	addl	%edx, %eax									# eax <-- eax + edx  (add value stored in edx to the value stored in eax, i.e, eax <-- (top + bottom))
	movl	%eax, %edx									# edx <-- eax (move value stored in eax register to edx, i.e, edx <-- (bottom + top))
	shrl	$31, %edx									# edx <-- edx >> 31 (logical right shift) (binary value in edx is shifted rightwards by 31 places, i.e, edx <-- sign(edx)  (or)  edx <-- sign(top+bottom) --- sign(top+bottom) is 1 if (top + bottom) < 0 and 0 otherwise)
	addl	%edx, %eax									# eax <-- eax + edx (add value stored in edx to the value stored in eax, i.e, eax <-- bottom + top + sign(bottom+top))
	sarl	%eax										# eax <-- eax >> 1  (arithmetic right shift by 1 place) (value stored in eax register is halved, i.e, eax <-- (bottom + top + sign(bottom+top)) / 2 )
	movl	%eax, -4(%rbp)								# (rbp - 4) <-- eax (move value stored in eax to (rbp - 4), i.e, (rbp - 4) <-- (bottom + top + sign(bottom+top)) / 2   (or)   mid <-- (bottom + top + sign(bottom+top)) / 2) --- assignment statement inside do-while loop on line 50
	movl	-4(%rbp), %eax								# eax <-- (rbp - 4) (move value stored in (rbp - 4) to eax, i.e, eax <-- mid)
	cltq												# rax <-- signExt(eax) (rax <-- signExt(mid))
	leaq	0(,%rax,4), %rdx							# rdx <-- 4 * rax (rdx register stores 4 times the value stored in rax, i.e, rdx <-- 4*mid)
	movq	-24(%rbp), %rax								# rax <-- (rbp - 24) (move value stored in (rbp - 24) to rax, i.e, rax <-- &a  (or)  rax <-- a)
	addq	%rdx, %rax									# rax <-- rax + rdx (rax stores "&a + 4 * mid", which is the address of "a[mid]", i.e, rax <-- &a[mid])
	movl	(%rax), %eax								# eax <-- Mem[rax] (move value stored in the memory at the address stored in rax to eax, i.e, eax <-- *rax  (or)  eax <-- a[mid])
	cmpl	%eax, -32(%rbp)								# compare values stored in (rbp - 32) ("item" integer variable) and eax ("a[mid]") --- if-condition inside do-while loop on line 51
	jge	.L15											# jump if greater than or equal to, i.e, jump to .L15 to execute the else-block of statement(s) if value in (rbp - 32) is greater than or equal to in eax, i.e, item >= a[mid]
	movl	-4(%rbp), %eax								# eax <-- (rbp - 4) (move value stored in (rbp - 4) to eax, i.e, eax <-- mid)
	subl	$1, %eax									# eax <-- eax - 1   (subract 1 from the value stored in eax, i.e, eax <-- mid - 1)
	movl	%eax, -12(%rbp)								# (rbp - 12) <-- eax (move value stored in eax to (rbp - 12), i.e, (rbp - 12) <-- mid-1  (or)  top <-- mid-1) --- assignment statement on line 52 inside if-statement-block in do-while loop
	jmp	.L16											# goto .L16 to check the while-condition on line 55 for the do-while loop
.L15:													# [LABEL] -- else-block of statement(s) inside do-while loop in bsearch function (line 53)
	movl	-4(%rbp), %eax								# eax <-- (rbp - 4) (move value stored in (rbp - 4) to eax, i.e, eax <-- mid)
	cltq												# rax <-- signExt(eax) (rax <-- signExt(mid))
	leaq	0(,%rax,4), %rdx							# rdx <-- 4 * rax (rdx register stores 4 times the value stored in rax, i.e, rdx <-- 4*mid)
	movq	-24(%rbp), %rax								# rax <-- (rbp - 24) (move value stored in (rbp - 24) to rax, i.e, rax <-- &a  (or)  rax <-- a)
	addq	%rdx, %rax									# rax <-- rax + rdx (rax stores "&a + 4 * mid", which is the address of "a[mid]", i.e, rax <-- &a[mid])
	movl	(%rax), %eax								# eax <-- Mem[rax] (move value stored in the memory at the address stored in rax to eax, i.e, eax <-- *rax  (or)  eax <-- a[mid])
	cmpl	%eax, -32(%rbp)								# compare values stored in (rbp - 32) ("item" integer variable) and eax ("a[mid]") --- if-condition inside else-block in do-while loop on line 53
	jle	.L16											# jump if less than or equal to, i.e, jump to .L16 (to check while-condition of do-while loop) if value in (rbp - 32) is less than or equal to in eax, i.e, item <= a[mid]
	movl	-4(%rbp), %eax								# eax <-- (rbp - 4) (move value stored in (rbp - 4) to eax, i.e, eax <-- mid)
	addl	$1, %eax									# eax <-- eax + 1 (add 1 to the value stored in eax register, i.e, eax <-- mid + 1)
	movl	%eax, -8(%rbp)								# (rbp - 8) <-- eax  (move value stored in eax to (rbp - 8), i.e, (rbp - 8) <-- mid + 1  (or)  bottom <-- mid + 1) --- assignment statement on line 54 inside if-statement-block in else-statement-block
.L16:													# [LABEL] -- check while-condition (on line 55) for continuing iterating over the do-while loop in bsearch function
	movl	-4(%rbp), %eax								# eax <-- (rbp - 4) (move value stored in (rbp - 4) to eax, i.e, eax <-- mid)
	cltq												# rax <-- signExt(eax) (rax <-- signExt(mid))
	leaq	0(,%rax,4), %rdx							# rdx <-- 4 * rax (rdx register stores 4 times the value stored in rax, i.e, rdx <-- 4*mid)
	movq	-24(%rbp), %rax								# rax <-- (rbp - 24) (move value stored in (rbp - 24) to rax, i.e, rax <-- &a  (or)  rax <-- a)
	addq	%rdx, %rax									# rax <-- rax + rdx (rax stores "&a + 4 * mid", which is the address of "a[mid]", i.e, rax <-- &a[mid])
	movl	(%rax), %eax								# eax <-- Mem[rax] (move value stored in the memory at the address stored in rax to eax, i.e, eax <-- *rax  (or)  eax <-- a[mid])
	cmpl	%eax, -32(%rbp)								# compare values stored in (rbp - 32) ("item" integer variable) and eax ("a[mid]") --- while-condition for do-while loop on line 55
	je	.L17											# jump if equal, i.e, jump to .L17 (exit the do-while loop) if value in (rbp - 32) is equal to in eax, i.e, item == a[mid]
	movl	-8(%rbp), %eax								# eax <-- (rbp - 8) (move value stored in (rbp - 8) to eax, i.e, eax <-- bottom)
	cmpl	-12(%rbp), %eax								# compare value stored in (rbp - 12) ("top" integer variable) and eax ("bottom") --- while-condition for do-while loop on line 55
	jle	.L18											# jump if less than or equal to, i.e, jump to .L18 (reiterate over do-while loop) if value in eax is less than or equal to in (rbp - 12), i.e, bottom <= top
.L17:													# [LABEL] -- stack frame de-allocation, returning from bsearch function
	movl	-4(%rbp), %eax								# eax <-- (rbp - 4) (move value stored in (rbp - 4) to eax, i.e, eax <-- mid) -- return value of bsearch function is "mid"
	popq	%rbp										# pop base pointer register from the stack-frame
	.cfi_def_cfa 7, 8									# CFI directive
	ret													# return from bsearch function (value stored in eax register (mid) is returned)
	.cfi_endproc										# CFI directive
.LFE2:													# [LABEL]
	.size	bsearch, .-bsearch							# ".size symbol, expr" declares symbol size to be expr
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"	# identify which version of the compiler generated this assembly code
	.section	.note.GNU-stack,"",@progbits			# a new section ".note.GNU-stack" is created with attributes (@progbits)
	.section	.note.gnu.property,"a"					# a new section ".note.gnu.property" is created with attributes ("a")
	.align 8											# align with 8-byte boundary
	.long	 1f - 0f									# directive generates a 32-bit integer for "1f - 0f" into the current section
	.long	 4f - 1f									# directive generates a 32-bit integer for "4f - 1f" into the current section
	.long	 5											# directive generates a 32-bit integer for "5" into the current section
0:														# [LABEL]
	.string	 "GNU"										# directive places the characters in string "GNU" into the object module at the current location and terminates the string with a null byte (\0)
1:														# [LABEL]
	.align 8											# align with 8-byte boundary
	.long	 0xc0000002									# declare a 32-bit integer for "0xc0000002" into the current section
	.long	 3f - 2f									# directive generates a 32-bit integer for "3f - 2f" into the current section
2:														# [LABEL]
	.long	 0x3										# directive generates a 32-bit integer for "0x3" into the current section
3:														# [LABEL]
	.align 8											# align with 8-byte boundary
4:														# [LABEL]
