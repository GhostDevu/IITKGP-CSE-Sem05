
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O6 -- Test File 04
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)

int readInt ( int * arg ) ;
int printInt ( int arg ) ;
int printStr ( char * arg ) ;

// Global Static Variables (Scalars & Arrays)
int __error__ ;
int __stack_ptr__ ;
int __stack__ [2048] ;
char __gbl_string__ [10] ;
char __gbl_charac__ ;

int Tak ( int x , int y , int z ) {
    if ( x <= 0 || y <= 0 || z <= 0 )   return 0 ;
    // taken from wikipedia
    if ( y < x ) {
        int recCall1 = Tak(x-1, y, z) ;
        int recCall2 = Tak(y-1, z, x) ;
        int recCall3 = Tak(z-1, x, y) ;
        return Tak(recCall1, recCall2, recCall3) ;
    }
    return z ;
}

int Tarai ( int x , int y , int z ) {
    // taken from wikipedia
    while ( x > y ) {
        int oldx = x ;
        int oldy = y ;
        x = Tarai(x - 1, y, z) ;
        y = Tarai(y - 1, z, oldx) ;
        if ( x <= y )   return y ;
        z = Tarai(z - 1, oldx, oldy) ;
    }
}

int main ( ) {
    printStr("\n\n") ;
    __error__ = -1 ;
    int __x__, __y__,  __z__ ;
    
    printStr(" Enter x : ") ; readInt(&__x__) ;
    printStr(" Enter y : ") ; readInt(&__y__) ;
    printStr(" Enter z : ") ; readInt(&__z__) ;
    int func = -1 ;
    printStr(" Select Tak(0) or Tarai(1) : ") ; readInt(&func) ;

    if ( func != 0 && func != 1 ) {
        printStr(" [ Invalid function choice ]\n\n") ;
        return 0 ;
    }

    if ( func == 0 ) {
        __stack_ptr__ = 0 ;
        int val = Tak(__x__, __y__, __z__) ;
        printStr(" Tak(x, y, z) : ") ; printInt(val) ;
    }
    else {
        __stack_ptr__ = 0 ;
        int val = Tarai(__x__, __y__, __z__) ;
        printStr(" Tarai(x, y, z) : ") ; printInt(val) ;
    }

    printStr("\n\n") ;
    return 0 ;
}