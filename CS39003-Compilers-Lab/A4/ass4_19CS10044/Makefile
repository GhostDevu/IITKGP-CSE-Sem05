
#   COMPILERS LABORATORY CS39003
#   ASSIGNMENT O3 -- Lexer for tinyC
#   Semester O5 (Autumn 2021-22)
#   Group Members :	Hritaban Ghosh (19CS30053)
# 					Nakul Aggarwal (19CS10044)

a.out: lex.yy.o ass4_19CS10044_19CS30053_main.o y.tab.o
	gcc lex.yy.o ass4_19CS10044_19CS30053_main.o y.tab.o -lfl 

ass4_19CS10044_19CS30053_main.o: ass4_19CS10044_19CS30053_main.c 
	gcc -c ass4_19CS10044_19CS30053_main.c 

lex.yy.o: lex.yy.c 
	gcc -c lex.yy.c 

lex.yy.c: ass4_19CS10044_19CS30053.l y.tab.h
	flex -w ass4_19CS10044_19CS30053.l

y.tab.o: y.tab.c 
	gcc -c y.tab.c

y.tab.c: ass4_19CS10044_19CS30053.y 
	yacc -dty ass4_19CS10044_19CS30053.y

y.tab.h: ass4_19CS10044_19CS30053.y
	yacc -dty ass4_19CS10044_19CS30053.y

test:
		./a.out ass4_19CS10044_19CS30053_test.c > ass4_19CS10044_19CS30053_test.out

clean:
		rm a.out lex.yy.c lex.yy.o y.tab.c y.tab.o y.tab.h ass4_19CS10044_19CS30053_main.o ass4_19CS10044_19CS30053_test.out
