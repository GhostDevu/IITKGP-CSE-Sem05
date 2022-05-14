
# Compilers Laboratory CS39003 -- Autumn 2021
# Assignment 02 -- Creating Library
# Nakul Aggarwal | 19CS10044

a.out: main.o libass2_19CS10044.a
		gcc main.o -L. -lass2_19CS10044

main.o: main.c myl.h
		gcc -Wall -c main.c

libass2_19CS10044.a: ass2_19CS10044.o
		ar -rcs libass2_19CS10044.a ass2_19CS10044.o

ass2_19CS10044.o: ass2_19CS10044.c myl.h
		gcc -Wall -c ass2_19CS10044.c

clean:
		rm a.out main.o libass2_19CS10044.a ass2_19CS10044.o
