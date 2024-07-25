
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O5 -- Test File 04
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)
//  [ STATEMENTS PHASE -- CONDITIONAL CONSTRUCTS, RELATIONAL/LOGICAL EXPRESSIONS ]

int IfElse ( int x , int y , int z , int w ) {
	int res = -1 ;
	if ( x < y && z ) {
		if ( y != x || z > w ) {
			int temp = x ;
			x = w ;
			w = temp ;
			res = (y - x) * (z - w) ;
		}
		else if ( y == x ) {
			if ( z <= w ) {
				int temp = y ;
				y = z ;
				z = temp ;
				res = (y - w) * (z - x) ;
			}
			else 
				res = x + y + z + w ;
		}
		else {
			res = x + y - z - w ;
			if ( res < 0 )	
				res = res * (-1 * res) ;
		}
	}
	else if ( x >= y ) {
		if ( ! z ) {
			res = (x + y + w) / 3 ;
			z = 0 ;
		}
		else {
			x = (w + y + z) / 3 ;
			res = x*x + y*y + w*w - z*z*z ;
		}
	}
	else 
		res = x ;
	return res ;
} 

int main ( ) {
	int res1 = IfElse(2, -4, 8, -16) ;
	int res2 = IfElse(3, 9, -6, 0) ;
	int res = IfElse(res1, res2, res1, res2) ;
	return 0 ;
}
