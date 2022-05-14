
// Compilers Laboratory CS39003 -- Autumn 2021
// Assignment 02 -- Creating Library
// Nakul Aggarwal | 19CS10044

#include "myl.h"
#define READ_INT_BUFFER_SIZE                50
#define READ_FLOAT_IPART_BUFFER_SIZE        50
#define READ_FLOAT_FPART_BUFFER_SIZE        50
#define READ_FLOAT_EPART_BUFFER_SIZE        10
#define WRITE_INT_BUFFER_SIZE               12
#define WRITE_FLOAT_BUFFER_SIZE             100
#define WRITE_FLOAT_PRECISION               6
#define WRITE_FLOAT_PRECISION_PLACE_VALUE   1E-6
#define READ_FLOAT_LOWER_LIMIT              -3.4E38
#define READ_FLOAT_UPPER_LIMIT              3.4E38

int printStr ( char * str ) {
    int len = 0 ;
    while ( str[len] != '\0' ) len ++ ;

    if ( len == 0 ) 
        return 0 ;

    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(str), "d"(len)
    ) ;
    return len ;
}

int readInt ( int * i ) {
    char buff[READ_INT_BUFFER_SIZE] = { } ;
    int counter, val, is_number_negative, j ;
    char c = 0 ;

    counter = 0 ;
    while ( 1 ) {
        __asm__ __volatile__ (
            "movl $0, %%eax \n\t"
            "movq $0, %%rdi \n\t"
            "syscall \n\t"
            :
            :"S"(&c), "d"(1)
        ) ;

        if ( c == '\n' ) {
            if ( counter == 0 ) continue ;
            else    break ;
        }

        if ( c != '-' && c != '+' && ! (c >= '0' && c <= '9') ) return ERR ;
        if ( (c == '-' || c == '+') && counter > 0 )            return ERR ; 
        if ( counter == READ_INT_BUFFER_SIZE )                  return ERR ;

        buff[counter ++] = c ;
    }

    if ( buff[0] == '+' || buff[0] == '-' )
        if ( counter == 1 ) return ERR ;

    if ( counter >= 11 && buff[0] == '-' ) {
        int leading_zeros = counter - 11 ;
        int all_zeros = 1 ;

        for ( int k = 1 ; k <= leading_zeros ; k ++ ) {
            if ( buff[k] != '0' ) {
                all_zeros = 0 ;
                break ;
            }
        }

        if ( all_zeros == 1 ) {
            char least_negative_number_for_4_byte_int_mag[12] = "2147483648" ;
            int least_number_scanned = 1 ;

            for ( int k = leading_zeros + 1 ; k < counter ; k ++ ) {
                if ( least_negative_number_for_4_byte_int_mag[k - leading_zeros - 1] != buff[k] ) {
                    least_number_scanned = 0 ;
                    break ;
                }
            }

            if ( least_number_scanned == 1 ) {
                *i = -2147483648 ;
                return OK ;
            }
        }
    }

    val = 0 ;
    is_number_negative = (buff[0] == '-') ? 1 : 0 ;
    j = (buff[0] == '-' || buff[0] == '+') ? 1 : 0 ;

    for ( ; j < counter ; j ++ ) {
        if ( val * 10 < 0 ) return ERR ;
        val = (val * 10) + buff[j] - '0' ;
        if ( val < 0 ) return ERR ;
    }

    if ( is_number_negative == 1 )  val *= -1 ;

    *i = val ;
    return OK ;
}

int printInt ( int i ) {
    if ( i == -2147483648 ) {
        char least_negative_number_for_4_byte_int[12] = "-2147483648" ;
        return printStr(least_negative_number_for_4_byte_int) ;
    }

    char buff[WRITE_INT_BUFFER_SIZE] = { } ;
    int counter = 0 ;
    int orig = i ;

    if ( i == 0 )
        buff[counter++] = '0' ;
    else {
        if ( i < 0 ) {
            i *= -1 ;
            buff[counter++] = '-' ;
        }
        while ( i > 0 ) {
            if ( counter == WRITE_INT_BUFFER_SIZE)    return ERR ;
            buff[counter ++] = (char)(i % 10 + '0') ;
            i /= 10 ;
        }

        int ptri = 0 ;
        if ( orig < 0 ) ptri = 1 ;
        int ptrj = counter - 1 ;

        for ( ; ptri < ptrj ; ptri ++ , ptrj -- ) {
            char t = buff[ptri] ;
            buff[ptri] = buff[ptrj] ;
            buff[ptrj] = t ;
        }
    }

    if ( counter == WRITE_INT_BUFFER_SIZE)    return ERR ;

    buff[counter ++] = '\0' ;
    return printStr(buff) ;
}

int readFlt ( float * f ) {
    char buff_int_part[READ_FLOAT_IPART_BUFFER_SIZE] = { } ;
    char buff_frac_part[READ_FLOAT_FPART_BUFFER_SIZE] = { } ;
    char buff_exp_part[READ_FLOAT_EPART_BUFFER_SIZE] = { } ;
    int int_part_counter, frac_part_counter, exp_part_counter ;
    int state, total_length, decimal_scanned, e_scanned, abs_exponent ;
    char c = 0 ;
    float scanned_float_val ;

    int_part_counter = 0 ;
    frac_part_counter = 0 ;
    exp_part_counter = 0 ;
    state = 1 ;
    total_length = 0 ;
    decimal_scanned = e_scanned = 0 ;

    while ( 1 ) {
        __asm__ __volatile__ (
            "movl $0, %%eax \n\t"
            "movq $0, %%rdi \n\t"
            "syscall \n\t"
            :
            :"S"(&c), "d"(1)
        ) ;

        if ( c == '\n' ) {
            if ( total_length == 0 ) continue ;
            else    break ;
        }

        if ( state == 1 ) {
            if ( c == '.' ) {
                decimal_scanned = 1 ;
                total_length ++ ;
                state = 2 ;
                continue ;
            }
            if ( c == 'E' || c == 'e' ) {
                e_scanned = 1 ;
                total_length ++ ;
                state = 3 ;
                continue ;
            }

            if ( c != '-' && c != '+' && ! (c >= '0' && c <= '9') )     return ERR ;
            if ( (c == '-' || c == '+') && int_part_counter > 0 )       return ERR ; 
            if ( int_part_counter == READ_FLOAT_IPART_BUFFER_SIZE )     return ERR ;

            total_length ++ ;
            buff_int_part[int_part_counter ++] = c ;
            continue ;
        }

        if ( state == 2 ) {
            if ( c == 'E' || c == 'e' ) {
                e_scanned = 1 ;
                total_length ++ ;
                state = 3 ;
                continue ;
            }

            if ( c < '0' || c > '9' )     return ERR ;
            if ( frac_part_counter == READ_FLOAT_FPART_BUFFER_SIZE )     return ERR ;

            total_length ++ ;
            buff_frac_part[frac_part_counter ++] = c ;
            continue ;
        }

        if ( state == 3 ) {
            if ( c != '-' && c != '+' && ! (c >= '0' && c <= '9') )     return ERR ;
            if ( (c == '-' || c == '+') && exp_part_counter > 0 )       return ERR ; 
            if ( exp_part_counter == READ_FLOAT_EPART_BUFFER_SIZE )     return ERR ;

            total_length ++ ;
            buff_exp_part[exp_part_counter ++] = c ;
            continue ;
        }
    }
    
    if ( int_part_counter == 0 ) {
        if ( decimal_scanned == 0 )     return ERR ;
        if ( frac_part_counter == 0 )   return ERR ;
    }
    else {
        if ( buff_int_part[0] == '+' || buff_int_part[0] == '-' )
            if ( int_part_counter == 1 )    return ERR ;
    }

    if ( e_scanned == 1 ) {
        if ( exp_part_counter == 0 )    return ERR ;
        if ( buff_exp_part[0] == '+' || buff_exp_part[0] == '-' )
            if ( exp_part_counter == 1 )    return ERR ;
    }

    int is_float_neg = (int_part_counter > 0 && buff_int_part[0] == '-') ? 1 : 0 ;
    long long integeral_part = 0 ;
    float fractional_part = 0 ;
    int exponent = 0 ;

    if ( exp_part_counter > 0 ) {
        int is_number_negative = (buff_exp_part[0] == '-') ? 1 : 0 ;
        int j = (buff_exp_part[0] == '-' || buff_exp_part[0] == '+') ? 1 : 0 ;

        for ( ; j < exp_part_counter ; j ++ ) 
            exponent = (exponent * 10) + buff_exp_part[j] - '0' ;
        
        if ( is_number_negative == 1 )
            exponent *= -1 ;

        if ( exponent < -26 ) {
            *f = 0.0 ;
            return OK ;
        }
    }

    if ( int_part_counter > 0 ) {

        int is_initialized = 0 ;

        if ( buff_int_part[0] == '-' && int_part_counter >= 20 ) {
            int leading_zeros = int_part_counter - 20 ;
            int all_zeros = 1 ;

            for ( int k = 1 ; k <= leading_zeros ; k ++ ) {
                if ( buff_int_part[k] != '0' ) {
                    all_zeros = 0 ;
                    break ;
                }
            }

            if ( all_zeros == 1 ) {
                char least_negative_number_for_8_byte_int[21] = "-9223372036854775808" ;
                int least_int_scanned = 1 ;

                for ( int k = leading_zeros + 1 ; k < int_part_counter ; k ++ ) {
                    if ( least_negative_number_for_8_byte_int[k - leading_zeros] != buff_int_part[k] ) {
                        least_int_scanned = 0 ;
                        break ;
                    }
                }

                if ( least_int_scanned == 1 ) {
                    is_initialized = 1 ;
                    integeral_part = -922337203685477580 * 10 - 8 ;
                }
            }
        }

        if ( is_initialized == 0 ) {
            int is_number_negative = (buff_int_part[0] == '-') ? 1 : 0 ;
            int j = (buff_int_part[0] == '-' || buff_int_part[0] == '+') ? 1 : 0 ;
            
            for ( ; j < int_part_counter ; j ++ ) {
                if ( integeral_part * 10 < 0 ) return ERR ;
                integeral_part = (integeral_part * 10) + buff_int_part[j] - '0' ;
                if ( integeral_part < 0 ) return ERR ;
            }

            if ( is_number_negative == 1 )
                integeral_part *= -1 ;
        }
    }

    if ( frac_part_counter > 0 ) {
        long long denom = 10 ;
        for ( int i = 0 ; i < frac_part_counter ; i ++ , denom *= 10 ) {
            if ( denom <= 0 )   break ;
            fractional_part += (1.0 * (buff_frac_part[i] - '0')) / denom ;
        }
    }

    if ( integeral_part < 0 )
        scanned_float_val = -1.0 * (-1.0 * integeral_part + fractional_part ) ;
    else
        scanned_float_val = 1.0 * integeral_part + fractional_part ;

    if ( is_float_neg == 1 && scanned_float_val > 0.0 )
        scanned_float_val *= -1 ;

    abs_exponent = exponent ;
    if ( abs_exponent < 0 )
        abs_exponent *= -1 ;

    for ( int e = 0 ; e < abs_exponent ; e++ ) {
        if ( scanned_float_val > READ_FLOAT_UPPER_LIMIT || scanned_float_val < READ_FLOAT_LOWER_LIMIT  )   return ERR ;
        if ( exponent < 0 ) scanned_float_val *= 0.1 ;
        else    scanned_float_val *= 10.0 ;
    }

    if ( scanned_float_val > READ_FLOAT_UPPER_LIMIT || scanned_float_val < READ_FLOAT_LOWER_LIMIT  )   return ERR ; 

    *f = scanned_float_val ;
    return OK ;
}

int printFlt ( float f ) {
    if ( f < WRITE_FLOAT_PRECISION_PLACE_VALUE && f > -1 * WRITE_FLOAT_PRECISION_PLACE_VALUE ) {
        char zero_floating_point[] = "0.000000" ;
        printStr(zero_floating_point) ;
        return 8 ;
    }
    
    char buff[WRITE_FLOAT_BUFFER_SIZE] = { } ;
    int total_chars_printed = 0 ;
    int counter = 0 ;
    int is_negative = 0 ;

    if ( f < 0.0 ) {
        is_negative = 1 ;
        f *= -1.0 ;
    }
    
    int decimal_position = 0 ;
    
    if ( f < 1.0 ) {
        buff[counter ++] = '0' ;
        decimal_position = 1 ;
    }

    while ( f >= 1.0 ) {
        decimal_position ++ ;
        f /= 10.0 ;
    }

    int pre_decimal_places = 0 ;
    int max_digits_in_total = decimal_position + WRITE_FLOAT_PRECISION ;

    while ( f > 0.0 && pre_decimal_places < max_digits_in_total ) {
        if ( counter == WRITE_FLOAT_BUFFER_SIZE ) return ERR ;
        int d = (int)(f * 10) ;
        f = f * 10 - d ;
        buff[counter ++] = d + '0' ;
        pre_decimal_places ++ ;
    }

    while ( pre_decimal_places < decimal_position ) {
        if ( counter == WRITE_FLOAT_BUFFER_SIZE ) return ERR ;
        buff[counter ++] = '0' ;
        pre_decimal_places ++ ;
    }

    int fractional_places = counter - decimal_position ;
    while ( fractional_places < WRITE_FLOAT_PRECISION ) {
        if ( counter == WRITE_FLOAT_BUFFER_SIZE ) return ERR ;
        buff[counter ++] = '0' ;
        fractional_places ++ ;
    }

    if ( is_negative == 1 ) {
        char negative_sign = '-' ;
        __asm__ __volatile__ (
            "movl $1, %%eax \n\t"
            "movq $1, %%rdi \n\t"
            "syscall \n\t"
            :
            :"S"(&negative_sign), "d"(1)
        ) ;
        total_chars_printed ++ ;
    }

    for ( int i = 0 ; i < decimal_position ; i ++ ) {
        __asm__ __volatile__ (
            "movl $1, %%eax \n\t"
            "movq $1, %%rdi \n\t"
            "syscall \n\t"
            :
            :"S"(buff + i), "d"(1)
        ) ;
        total_chars_printed ++ ;
    }

    char decimal_point = '.' ;
    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(&decimal_point), "d"(1)
    ) ;
    total_chars_printed ++ ;

    int fractional_places_printed = 0 ;
    for ( int i = decimal_position ; i < counter && fractional_places_printed < 6 ; i ++ ) {
        __asm__ __volatile__ (
            "movl $1, %%eax \n\t"
            "movq $1, %%rdi \n\t"
            "syscall \n\t"
            :
            :"S"(buff + i), "d"(1)
        ) ;
        total_chars_printed ++ ;
        fractional_places_printed ++ ;
    }

    return total_chars_printed ;
}
