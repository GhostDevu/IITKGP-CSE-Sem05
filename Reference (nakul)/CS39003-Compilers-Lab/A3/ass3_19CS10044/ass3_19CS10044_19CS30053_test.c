
/*
  COMPILERS LABORATORY CS39003
  ASSIGNMENT O3 -- Lexer for tinyC
  Semester O5 (Autumn 2021-22)
  Group Members :   Hritaban Ghosh (19CS30053)
                    Nakul Aggarwal (19CS10044)
*/

// Course MA118899 - 2-Dimensional Coordinate Geometry //
/*
    Tutorial Date - 15 September 2021 | Tutorial Day - Wednesday
    Aim - To study the fundamental formulae of coordinate geometry
    Instructor - Prof. John Doe
*//*
    Exam Date - 30 September 2021 | Exam Day - Friday
    Exam Time - 1200 IST to 1500 IST (180 minutes)
    Exam Venue - Online (Microsoft Teams)
    Maximum Marks - 500 | Final Weightage - 55%
*/

#include "stdio.h"
extern char * __FATAL_ERR__ ;
static float ROOT_2 = 1.414 ;
static float ROOT_3 = 1.732 ;
static float ROOT_5 = 2.236 ;
static double PI = 3.14159 ;
static double E = 2.71828 ;
static double INF = 3.8E+18 ;
static long long INF_INT = 100000 ;

// structure for a 2-D point
typedef struct point {
    int x, y ;
} Point ;

// returns the square of the distance of a point from origin
unsigned Square_Of_Distance_From_Origin ( const Point p ) {
    return (p.x * p.x) + (p.y * p.y) ;
}

// copy function (copies state of one point to the other)
void Copy_Point ( Point * p1 , const Point p2 ) {
    p1->x = p2.x ;
    p1->y = p2.y ;
    return ;
}

// a function that return the dot product of two 2-D vectors
int Dot_Product ( const Point p1 , const Point p2 ) {
    return p1.x * p2.x + p1.y + p2.y ;
}

_Bool Is_Negative ( double x ) {
    return (x < 0.0) ;
}

double Abs ( double x ) {
    if ( Is_Negative(x) )   return -1 * x ;
    return x ;
}

// a function that implements bisection method to find root of a positive number
double Approximate_Root ( long long t ) {
    if ( t < 0 ) {
        printf("%s", __FATAL_ERR__) ;   /* out of domain error */
        return -1.00 ;
    }

    if ( t == 0 )   return 0 ;

    else {
        double low = 0 ;
        double high = INF ;

        while ( Abs(low - high) > 1.0e-5 ) {
            if ( low > high )   break ;
            double mid = (low + high) / 2 ;
            double mid_sq = mid ;
            mid_sq *= mid ;
            if ( Abs(mid_sq - t) < .00001 )    return mid ;
            if ( mid_sq < t ) low = mid ;
            else    high = mid ;
        }

        return low ;
    }
}

// a function that computes the distance of a 2-D point from the origin (0,0)
double Distance_From_Origin ( const Point p ) {
    unsigned square_of_dist = Square_Of_Distance_From_Origin(p) ;
    switch ( square_of_dist ) {
        case 2: return ROOT_2 ;
        case 3: return ROOT_3 ;
        case 5: return ROOT_5 ;
        default: return Approximate_Root(square_of_dist) ;
    }
}

// a function that returns the cosine of the angle between
// two two-dimensional vectors
double Cosine_Of_Angle_Between_Position_Vectors ( const Point p1 , const Point p2 ) {
    return Dot_Product(p1, p2) / (Distance_From_Origin(p1) * Distance_From_Origin(p2)) ;
}

// main function
int main ( int argc , char ** argv ) {

    printf(" +++ Inside Main Function +++\n");
	char info1[100] = "Some operators & escape sequences we'll be frequently using in this tutorial : []{}!@#$%^&*()`~_-+=:;\"\'\\<,>.?/\n";
	char info2[100] = "The distance from\torigin\tis calculated\v using sqrt(x^2 +y^2)\n";
	char info3[100] = "The cirumference of a circle is given by 2*PI*r where r is the radius and PI = 3.14.\n";
	char info4[100] = "****\nUnderstanding fundamentals of 2D geometry is important for higher studies!!\n****\n";
	char char1 = '\"';
	char char2 = '\'';
	char char3 = '\v';
	char char3 = 'Q', char5 = '1';
	
    int n = 10 ;
    Point points[n] ;

    if ( n <= 0 )   goto return_statement ;

    for ( int i = 0 ; i < n ; i += 2 ) {
        points[i].x = i * i ;
        points[i].y = (int)(Approximate_Root(i*PI)) ;   i -- ;
        continue ;
    }

    int counter = 0 ;
    do {
        if ( counter > n )  break ;
        printf('Distance of "(%d, %d)" from origin is %lf.5', 
                        points[counter].x, points[counter].y, Distance_From_Origin(points[counter])) ;
        counter += 1 ;
    }   while ( counter < n ) ;

    return_statement :
    return ;
}

/* Hence the tutorial on 2-D coordinate geometry ends */
//  **************  GOOD LUCK FOR EXAMS  **************
