
#   COMPILERS LABORATORY CS39003
#   ASSIGNMENT O3 -- Lexer for tinyC
#   Semester O5 (Autumn 2021-22)
#   Group Members :	Hritaban Ghosh (19CS30053)
# 					Nakul Aggarwal (19CS10044)

a.out: lex.yy.c ass3_19CS10044_19CS30053_test.c
		cc lex.yy.c -ll

lex.yy.c: ass3_19CS10044_19CS30053.l ass3_19CS10044_19CS30053_main.c
		flex -w ass3_19CS10044_19CS30053.l ass3_19CS10044_19CS30053_main.c

test:
		./a.out ass3_19CS10044_19CS30053_test.c

clean:
		rm a.out lex.yy.c
