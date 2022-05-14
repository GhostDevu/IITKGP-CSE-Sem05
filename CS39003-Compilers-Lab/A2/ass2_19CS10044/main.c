
// Compilers Laboratory CS39003 -- Autumn 2021
// Assignment 02 -- Creating Library
// Nakul Aggarwal | 19CS10044

#include "myl.h"

int main ( ) {
    char action_choice_1[] = " (1.) Read and Write an Integer\n" ;
    char action_choice_2[] = " (2.) Read and Write a Floating Point\n" ;
    char action_choice_3[] = " (3.) Terminate\n" ;
    char ask_choice[] = "\t Enter your choice : " ;
    char invalid_choice[] = "\t\t [ * INVALID CHOICE ENTERED * ] \n" ;
    char you_entered[] = " You entered : " ;
    char length_of_printed_string[] = " No. of characters printed : " ;
    char ask_int[] = " Enter an integer : " ;
    char invalid_int[] = " [ * INVALID INTEGER VALUE ENTERED * ] \n" ;
    char ask_float[] = " Enter a floating point : " ;
    char invalid_float[] = " [ * INVALID FLOATING POINT VALUE ENTERED * ] \n" ;
    char double_newline[] = "\n\n" ;
    char single_newline[] = "\n" ;

    int choice = 1 ;
    int no_error = 0 ;
    int integer = 0 ;
    float floating = 0 ;
    int chars_printed = 0 ;

    printStr(double_newline) ;
    while ( 1 ) {
        printStr(action_choice_1) ;
        printStr(action_choice_2) ;
        printStr(action_choice_3) ;
        printStr(ask_choice) ;
        no_error = readInt(&choice) ;

        if ( no_error == 0 || choice > 3 || choice < 1 ) {
            printStr(invalid_choice) ;
            break ;
        }

        if ( choice == 3 )  break ;

        printStr(single_newline) ;

        if ( choice == 1 ) {
            printStr(ask_int) ;
            no_error = readInt(&integer) ;

            if ( no_error == 0 ) {
                printStr(invalid_int) ;
                break ;
            }

            printStr(you_entered) ;
            chars_printed = printInt(integer) ;
            printStr(single_newline) ;
            printStr(length_of_printed_string) ;
            printInt(chars_printed) ;
            printStr(double_newline) ;
            continue ;
        }

        if ( choice == 2 ) {
            printStr(ask_float) ;
            no_error = readFlt(&floating) ;

            if ( no_error == 0 ) {
                printStr(invalid_float) ;
                break ;
            }

            printStr(you_entered) ;
            chars_printed = printFlt(floating) ;
            printStr(single_newline) ;
            printStr(length_of_printed_string) ;
            printInt(chars_printed) ;
            printStr(double_newline) ;
            continue ;
        }
    }

    printStr(double_newline) ;
    return 0 ;
}
