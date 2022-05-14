
#   COMPILERS LABORATORY CS39003
#   ASSIGNMENT O6 -- Target Code Generator for tinyC
#   Semester O5 (Autumn 2021-22)
#   Group Members :	Hritaban Ghosh (19CS30053)
# 					Nakul Aggarwal (19CS10044)

a.out: lex.yy.o ass6_19CS10044_19CS30053.tab.o ass6_19CS10044_19CS30053_translator.o ass6_19CS10044_19CS30053_target_translator.o
	g++ lex.yy.c ass6_19CS10044_19CS30053.tab.o ass6_19CS10044_19CS30053_translator.o ass6_19CS10044_19CS30053_target_translator.o -lfl

testall: a.out libass6_19CS10044_19CS30053_mylibrary.a myl.h
	./a.out < ass6_19CS10044_19CS30053_test1.c 1 > ass6_19CS10044_19CS30053_quads1.out
	./a.out < ass6_19CS10044_19CS30053_test2.c 2 > ass6_19CS10044_19CS30053_quads2.out
	./a.out < ass6_19CS10044_19CS30053_test3.c 3 > ass6_19CS10044_19CS30053_quads3.out
	./a.out < ass6_19CS10044_19CS30053_test4.c 4 > ass6_19CS10044_19CS30053_quads4.out
	./a.out < ass6_19CS10044_19CS30053_test5.c 5 > ass6_19CS10044_19CS30053_quads5.out
	
	gcc -c ass6_19CS10044_19CS30053_asm1.s
	gcc -c ass6_19CS10044_19CS30053_asm2.s
	gcc -c ass6_19CS10044_19CS30053_asm3.s
	gcc -c ass6_19CS10044_19CS30053_asm4.s
	gcc -c ass6_19CS10044_19CS30053_asm5.s

	gcc ass6_19CS10044_19CS30053_asm1.o -o test1.exe -L. -lass6_19CS10044_19CS30053_mylibrary -no-pie
	gcc ass6_19CS10044_19CS30053_asm2.o -o test2.exe -L. -lass6_19CS10044_19CS30053_mylibrary -no-pie
	gcc ass6_19CS10044_19CS30053_asm3.o -o test3.exe -L. -lass6_19CS10044_19CS30053_mylibrary -no-pie
	gcc ass6_19CS10044_19CS30053_asm4.o -o test4.exe -L. -lass6_19CS10044_19CS30053_mylibrary -no-pie
	gcc ass6_19CS10044_19CS30053_asm5.o -o test5.exe -L. -lass6_19CS10044_19CS30053_mylibrary -no-pie

tinyC: ass6_19CS10044_19CS30053_asm_CUSTOM.s libass6_19CS10044_19CS30053_mylibrary.a myl.h
	gcc -c ass6_19CS10044_19CS30053_asm_CUSTOM.s
	gcc ass6_19CS10044_19CS30053_asm_CUSTOM.o -o test.exe -L. -lass6_19CS10044_19CS30053_mylibrary -no-pie

test1: a.out libass6_19CS10044_19CS30053_mylibrary.a myl.h
	./a.out < ass6_19CS10044_19CS30053_test1.c 1 > ass6_19CS10044_19CS30053_quads1.out
	gcc -c ass6_19CS10044_19CS30053_asm1.s
	gcc ass6_19CS10044_19CS30053_asm1.o -o test1.exe -L. -lass6_19CS10044_19CS30053_mylibrary -no-pie

test2: a.out libass6_19CS10044_19CS30053_mylibrary.a myl.h
	./a.out < ass6_19CS10044_19CS30053_test2.c 2 > ass6_19CS10044_19CS30053_quads2.out
	gcc -c ass6_19CS10044_19CS30053_asm2.s
	gcc ass6_19CS10044_19CS30053_asm2.o -o test2.exe -L. -lass6_19CS10044_19CS30053_mylibrary -no-pie

test3: a.out libass6_19CS10044_19CS30053_mylibrary.a myl.h
	./a.out < ass6_19CS10044_19CS30053_test3.c 3 > ass6_19CS10044_19CS30053_quads3.out
	gcc -c ass6_19CS10044_19CS30053_asm3.s
	gcc ass6_19CS10044_19CS30053_asm3.o -o test3.exe -L. -lass6_19CS10044_19CS30053_mylibrary -no-pie
	
test4: a.out libass6_19CS10044_19CS30053_mylibrary.a myl.h
	./a.out < ass6_19CS10044_19CS30053_test1.c 4 > ass6_19CS10044_19CS30053_quads4.out
	gcc -c ass6_19CS10044_19CS30053_asm4.s
	gcc ass6_19CS10044_19CS30053_asm4.o -o test4.exe -L. -lass6_19CS10044_19CS30053_mylibrary -no-pie
	
test5: a.out libass6_19CS10044_19CS30053_mylibrary.a myl.h
	./a.out < ass6_19CS10044_19CS30053_test5.c 5 > ass6_19CS10044_19CS30053_quads5.out
	gcc -c ass6_19CS10044_19CS30053_asm5.s
	gcc ass6_19CS10044_19CS30053_asm5.o -o test5.exe -L. -lass6_19CS10044_19CS30053_mylibrary -no-pie
	
libass6_19CS10044_19CS30053_mylibrary.a : ass6_19CS10044_19CS30053_mylibrary.o
		ar -rcs libass6_19CS10044_19CS30053_mylibrary.a ass6_19CS10044_19CS30053_mylibrary.o

ass6_19CS10044_19CS30053_mylibrary.o : ass6_19CS10044_19CS30053_mylibrary.c myl.h
		gcc -c ass6_19CS10044_19CS30053_mylibrary.c

ass6_19CS10044_19CS30053_target_translator.o: ass6_19CS10044_19CS30053_target_translator.cxx ass6_19CS10044_19CS30053_translator.h
	g++ -c ass6_19CS10044_19CS30053_translator.h
	g++ -c ass6_19CS10044_19CS30053_target_translator.cxx

ass6_19CS10044_19CS30053_translator.o: ass6_19CS10044_19CS30053_translator.cxx ass6_19CS10044_19CS30053_translator.h
	g++ -c ass6_19CS10044_19CS30053_translator.h
	g++ -c ass6_19CS10044_19CS30053_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

ass6_19CS10044_19CS30053.tab.o: ass6_19CS10044_19CS30053.tab.c
	g++ -c ass6_19CS10044_19CS30053.tab.c

lex.yy.c: ass6_19CS10044_19CS30053.l ass6_19CS10044_19CS30053.tab.h ass6_19CS10044_19CS30053_translator.h
	flex ass6_19CS10044_19CS30053.l

ass6_19CS10044_19CS30053.tab.c: ass6_19CS10044_19CS30053.y
	bison -dtv ass6_19CS10044_19CS30053.y

ass6_19CS10044_19CS30053.tab.h: ass6_19CS10044_19CS30053.y
	bison -dtv ass6_19CS10044_19CS30053.y

cleanquads:
	rm -f *.out

cleanasm:
	rm -f *.s

cleanexe:
	rm -f *.exe

clean:
	rm -f lex.yy.c\
	   lex.yy.o\
	   a.out\
	   ass6_19CS10044_19CS30053.tab.c\
	   ass6_19CS10044_19CS30053.tab.h\
	   ass6_19CS10044_19CS30053.tab.o\
	   ass6_19CS10044_19CS30053.output\
	   ass6_19CS10044_19CS30053_translator.o\
	   ass6_19CS10044_19CS30053_target_translator.o\
	   ass6_19CS10044_19CS30053_translator.h.gch\
	   libass6_19CS10044_19CS30053_mylibrary.a\
	   *.o *.exe
