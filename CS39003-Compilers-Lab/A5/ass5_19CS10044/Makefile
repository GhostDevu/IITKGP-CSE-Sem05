

#   COMPILERS LABORATORY CS39003
#   ASSIGNMENT O3 -- Machine Independent Translator for tinyC
#   Semester O5 (Autumn 2021-22)
#   Group Members :	Hritaban Ghosh (19CS30053)
# 					Nakul Aggarwal (19CS10044)

a.out: lex.yy.o ass5_19CS10044_19CS30053.tab.o ass5_19CS10044_19CS30053_translator.o
	g++ lex.yy.o ass5_19CS10044_19CS30053.tab.o ass5_19CS10044_19CS30053_translator.o -lfl

testall: a.out
	./a.out < ass5_19CS10044_19CS30053_test1.c > ass5_19CS10044_19CS30053_quads1.out
	./a.out < ass5_19CS10044_19CS30053_test2.c > ass5_19CS10044_19CS30053_quads2.out
	./a.out < ass5_19CS10044_19CS30053_test3.c > ass5_19CS10044_19CS30053_quads3.out
	./a.out < ass5_19CS10044_19CS30053_test4.c > ass5_19CS10044_19CS30053_quads4.out
	./a.out < ass5_19CS10044_19CS30053_test5.c > ass5_19CS10044_19CS30053_quads5.out

test1: a.out
	./a.out < ass5_19CS10044_19CS30053_test1.c > ass5_19CS10044_19CS30053_quads1.out

test2: a.out
	./a.out < ass5_19CS10044_19CS30053_test2.c > ass5_19CS10044_19CS30053_quads2.out

test3: a.out
	./a.out < ass5_19CS10044_19CS30053_test3.c > ass5_19CS10044_19CS30053_quads3.out

test4: a.out
	./a.out < ass5_19CS10044_19CS30053_test4.c > ass5_19CS10044_19CS30053_quads4.out

test5: a.out
	./a.out < ass5_19CS10044_19CS30053_test5.c > ass5_19CS10044_19CS30053_quads5.out

ass5_19CS10044_19CS30053_translator.o: ass5_19CS10044_19CS30053_translator.cxx ass5_19CS10044_19CS30053_translator.h
	g++ -c ass5_19CS10044_19CS30053_translator.h
	g++ -c ass5_19CS10044_19CS30053_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

ass5_19CS10044_19CS30053.tab.o: ass5_19CS10044_19CS30053.tab.c
	g++ -c ass5_19CS10044_19CS30053.tab.c

lex.yy.c: ass5_19CS10044_19CS30053.l ass5_19CS10044_19CS30053.tab.h ass5_19CS10044_19CS30053_translator.h
	flex ass5_19CS10044_19CS30053.l

ass5_19CS10044_19CS30053.tab.c: ass5_19CS10044_19CS30053.y
	bison -dtv ass5_19CS10044_19CS30053.y

ass5_19CS10044_19CS30053.tab.h: ass5_19CS10044_19CS30053.y
	bison -dtv ass5_19CS10044_19CS30053.y

clean:
	rm -f lex.yy.c\
	   lex.yy.o\
	   a.out\
	   ass5_19CS10044_19CS30053.tab.c\
	   ass5_19CS10044_19CS30053.tab.h\
	   ass5_19CS10044_19CS30053.tab.o\
	   ass5_19CS10044_19CS30053.output\
	   ass5_19CS10044_19CS30053_translator.o\
	   ass5_19CS10044_19CS30053_translator.h.gch
	   
cleanquads:
	rm -f ass5_19CS10044_19CS30053_quads1.out\
	   ass5_19CS10044_19CS30053_quads2.out\
	   ass5_19CS10044_19CS30053_quads3.out\
	   ass5_19CS10044_19CS30053_quads4.out\
	   ass5_19CS10044_19CS30053_quads5.out
