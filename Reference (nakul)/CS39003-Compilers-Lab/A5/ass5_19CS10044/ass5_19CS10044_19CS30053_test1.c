
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O5 -- Test File 01
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)
//  [ EXPRESSIONS PHASE -- ARITHMETIC/SHIFT/BIT/ASSIGNMENT OPS & TYPE-CASTING OPS ]

int main ( ) {
    int a, b, c, d, e, f, g, h ;
    float i, j, k ;
    a = 16 ;
    b = a + 64 ;
    c = b - a ;
    d = (c * (a - b)) % (a * (b / a)) ;
    d = (a * (b % (c - a * d)) / c) ;
    e = 3 * 14 ;
    f = e << 3 ;
    h = (a - e + f) / ((a + b + c) * 3) ;
    i = h * 2.5 ;
    j = (i + 2.33) / (a - b + 0.0012) ;
    k = a + b / i ;
    j = j - (k + j * (-1.0)) ;
    g = (int)j ;
    char l = 'A' ;
    a = (int)l ;
    a = (int)(i + b) ;
    b = l % ('Z' - 'A') + 'A' ;
    c = b << (d + e) ;
    k = (float)c + j ;
    f = (int)(i * (j - k) * 180 / 3.141) ;
    b = ((f & ((d * e) / g)) | g) ;
    a = ~(('P' + 'Q') % 'R') ;
    h = ~((a | b) & (-249)) ;
    return 0 ;
}
