
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O6 -- Intermediate Code Generator Header File
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)

#include <iostream>
#include <vector>
#include <string>
#include <map>
using namespace std ;
extern int yyparse ( ) ;
extern char * yytext ;
void yyerror ( string ) ; // to print an error encountered while parsing

// Size of different data types - Target Machine Dependent
#define __SIZE_OF_CHAR__ 1
#define __SIZE_OF_FLOAT__ 8
#define __SIZE_OF_INT__ 4
#define __SIZE_OF_VOID__ 0

// ++++ Classes (Data Structures) -- forward declaration ++++
class Quad ;            // stores the TAC quad in the form of (op, result, arg1, arg2)
class SymbolTable ;     // symbol table needed to store emtities in the global scope, a function or a block
class QuadArray ;       // to maintain an array of quads for "lazy spitting"
class Symbol ;          // every entry in the symbol table corresponds to a symbol
class Label ;           // correspond to the labels (like "L0:") that we write in the source-code, stores the address, name etc of the label
class SymbolType ;      // data structure that stores the type of a symbol alongwith several other important information
struct E ;  // describes Expression-type entities while parsing
struct A ;  // describes array-type entities while parsing
struct S ;  // describes Statement-type entities while parsing
//  [ Each of these data structures are explained in much detail later. ]


// ++++ External Global Definitions ++++
extern SymbolTable * __current_ST__ ;   // points to the current ST || needed to store symbols according to the scope in which they lie
extern SymbolTable * __global_ST__ ;    // points to the global ST || all function definitions are a part of global ST, other variable 
                                        // definitions are also stored in global ST if the parser is not in any specific function scope.
extern SymbolTable * __current_parent_ST__ ;    // points to the parent of the current ST || important for maintaining a hierarchy of STs
extern Symbol * __current_symbol__ ;    // points to the most recently created symbol || it is imp. to keep track of current symbol because
                                        // we might need to update the "nested table" field with the ST entirely dedictated to this current symbol, this happens
                                        // in case the current symbol is a block (block inside a block OR block inside a function) or a function; in either case
                                        // there will be a separate ST that is dedicated to the current symbol.
extern QuadArray __quad_array__ ;   // stores all the emitted quads in the form of an array || these quads are printed when the parser terminates (lazy splitting)
extern vector<pair<string, int>> __basic_type__ ;   // not used by the parser but is a helpful data structure to remember the sizes of the various data types; it enables easy
                                                    // extension of the translator to more data types in future; implemented as array of string(name of type) & int(size of type) pairs.
extern int __num_tables__ ;     // stores the ID (or the count) of the next ST in the ST-heirarchy || imp. in order to name the STs meaningfully and without any name-conflict.
extern string __current_loop__ ;    // stores the name of the loop the parser is current inside || imp. in order to name the STs meaningfully, like ST for a "for"-block
                                    // will be named by something as FOR.$0.$1
extern vector<Label> __labels__ ;   // a lookup tabel for labels || "__labels__" is to "Label" what "SymbolTable" is to "Symbol"; we can store all the labels together in the same list
extern int __next_temp_id__ ;   // stores the ID for the next compiler-generated-temporary || maintained in order to name temporaries meaningfully & without naming-conflict
extern vector<string> __string_literals__ ; // stores all the string constants in the source code || important in order to allocate them in the
                                            // data segment of the assembly code that will finally be generated

// ++++ Global Functions ++++
vector<int> makelist ( int ) ;  // to create a new list containing a single quad-array index and return it.
vector<int> merge ( vector<int> & , vector<int> & ) ; // concatenate two lists into a new list and return the new one.
void backpatch ( vector<int> & , int ) ; // insert the given quad-index as the target label for all the quads in the given list.
int nextinstr ( ) ; // returns the address of the next instruction (i.e, index of the next quad in quad-array).

E * convBool2Int ( E * ) ;  // a function that converts expression of boolean-type to int
E * convBool2Flt ( E * ) ;  // a function that converts expression of boolean-type to float
E * convBool2Char ( E * ) ; // a function that converts expression of boolean-type to char
E * convInt2Bool ( E * ) ;  // a function that converts expression of int type to boolean
E * convInt2Flt ( E * ) ;   // a function that converts expression of int type to float (possible w/o loss of information)
E * convFlt2Bool ( E * ) ;  // a function that converts expression of float type to boolean
E * convChar2Int ( E * ) ;  // a function that converts expression of char type to int (possible w/o loss of information)
E * convChar2Flt ( E * ) ;  // a function that converts expression of char type to float (possible w/o loss of information)
E * convChar2Bool ( E * ) ; // a function that converts expression of char type to boolean

void typecheck ( E * & , E * & ) ;
// A global function to check if two expressions are of same types. If not, then
// to check if they have compatible types (that is, one can be converted to the 
// other without any possible loss of information). In this case, the first one is
// converted into the type of the second one or the second one is converted to the
// type of the first one using an appropriate function conv<t1>2<t2>(E1,E2) from
// above. If the types are incomaptible, a yyerror is reported.

bool comparetype ( Symbol * & , Symbol * & ) ;  // similar as "typecheck" function but works for any Symbol (not particularly an Expression)
bool comparetype ( SymbolType * , SymbolType * ) ;  // returns true if and only if the types described by the two SymbolType objects are exactly the same,
                                                    // this includes a recursive-checking routine in case the type is a multi-dimensional array, in which case
                                                    // all the dimensions should have the same width.
Symbol * typecast ( Symbol * , string , int = 0 ) ; // typecasts a Symbol object to any (compatible) type passed as a string; there are many important details
                                                    // related to this particular function that will be described in the .cxx file.


// Every entry in the symbol table corresponds to a "Symbol", that can be of any type
// ranging from int/float/pointers/array to functions/blocks.
// A symbol primarily has name, type/category, initial value, offset & nested table
// attributes printed in the ST; though it can have several other attributes at the back-end.
class Symbol {
	public:
        string _name ;  // name of the symbol, can be the same as in the program (like "my_integer"), 
                        // can be a compiler generated name (like "t#12") or can be name of a block (like "main.FOR$0.FOR$3")
        SymbolType * _type ;    // type of the symbol stored as a SymbolType object 
        int _size ; // size/width of the symbol (like 4 for int, 8 for float, 0 for block etc -- more on this later)
        int _offset ;   // offset of the symbol in the symbol table (updated once the parsing is over)
        SymbolTable * _nested ; // in case a symbol is of type "function" or "block", it will have another ST completely
                                // dedicated for it; _nested in this case points to that ST.
        string _initVal ;   // initial value of the symbol (default -- "", empty string)
        int _isFunction ;   // is 1 if and only if the symbol corresponds to a function type, otherwise 0 (default)
        SymbolType * _retType ; // if the symbol corresponds to a function-type, _retType stores the return type of the function
                                // as a SymbolType object.
        string _category ; // category of the symbol (is displayed in the symbol tables)
                           // category can be one of -- function, global, local, temp
        
        Symbol ( string , string , SymbolType * = NULL, int = 0 ) ; // constructor
        void print ( ) const ;  // non-static method that prints some selected attributes of the symbol in a nice format in a ST
        Symbol * updateType ( SymbolType * ) ;  // non-static method to update the type of the symbol
        Symbol * updateOffset ( int ) ; // non-static method to update the offset of the symbol in the ST it resides inside of.
} ;


// Data structure that stores the type of a symbol alongwith several other important information
class SymbolType {
    public:
        string _type ;  // type of the symbol is stored as a string (one of [null, void, char, int, float, ptr, arr, func, block])
        int _width ;    // width/size of the data-type described by the SymbolType object
        SymbolType * _arrayType ;   // _arrayType is NULL for non-arr-type SymbolType's. Arrays must be defined in a recursive fashion,
                                    // because an n-dimensional array is an array of (n-1)-dimensional arrays. For arrays, _arrayType points
                                    // to the SymbolType object that describes the type of the element of that array.
                                    // Eg - type of element of arr(2, arr(3, int)) is array(3, int)
        int _isFunction ;   // is 1 if and only if the symbol-type is a function, otherwise 0 (default)

        SymbolType ( string , SymbolType * = NULL, int = 0 ) ;  // constructor
        int size ( ) const ;    // non-static method that returns the size of the SymbolType object
        string print ( ) const ;    // non-static method that returns the type of the SymbolType object as a string
        SymbolType * copy ( ) const ;   // non-static method that dynamically creates a deep-copy of the SymbolType object and returns the pointer to it.
} ;


// Data structure that stores all the symbols that are encountered in a certain scope of the program.
// This scope can be a global scope, function scope or a block scope. The way SymbolTable objects are
// instantiated produces a hierarchical tree-like structure of STs, rooted at the global symbol table
// by the name of "ST.Global". All non-global STs have a unique parent ST. All STs can branch off to
// multiple child STs. So the implementation SymbolTable takes care of this hierarchy.
class SymbolTable {
    public:
        string _name ;  // name of the symbol table; can be same as defined in the program (like "My_Func"), or can be
                        // compiler-defined (like "ST.Global", "main.FOR$0.FOR$3" etc)
        vector <Symbol*> _symbols ; // list of Symbol objects (must be in the same scope) that are stored in this ST
        SymbolTable * _parent ; // points to the parent ST (NULL for ST.Global)
        map<string, int> _activationRec ;   // activation record of the symbol table, stored as (symbol-name, offset) pairs
        
        SymbolTable ( string , SymbolTable * = NULL ) ; // constructor
        static Symbol * gentemp ( SymbolType * , string = "" ) ;    // static method to generate a new temporary, insert it to the ST, and return a pointer to it.
        Symbol * lookup ( string ) ; // non-static method to search a Symbol by the given name/ID in the ST and return a pointer to it. If no Symbol
                                     // with the given name is found, a new entry is created and hence returned.
        void updateOffsets ( ) ; // non-static method to update the offset of all the entries in the ST, and also of all the
                                 // successive STs (children/nested STs) in a recursive manner.
        void update ( string , string , SymbolType * = NULL ) ; // non-static method to update different fields of a ST entry (if found by name);
                                                                // note that only the offset and the type of a Symbol can be changed. (naturally if
                                                                // type changes, _size/_isFunction/etc might also change)
                                                                // Also note that if the offset of one symbol is updated, then the offsets of other symbols
                                                                // in the same ST cannot remain the same, therefore offset of all the symbols in that ST are updated.
        void print ( bool = false ) const ; // non-static method to print the ST in a neat tabular fashion with the name & parent of the ST printed on the top
                                            // followed by a list of all the symbols in the ST with their name, type, init value, size, offset, nested table name
        void switchCurrentST ( ) ;  // non-static method to change the current ST, i.e, "__current_ST__" global variable. It is needed when the scope is
                                    // changed in the program, like you enter a (nested)block or a function.
        void constructActivationRecord ( ) ; // non-static method that constructs the activation record of the ST at the time of target code generation
} ;


// Quad stores a three-address code instruction (TAC) in the form of (op, result, arg1, arg2). Depending upon the
// type of operator "op", any one or both the arguements might be empty.
class Quad {
    public:
        string _result ;    // name of the variable/temporary/symbol that stores the result
        string _op ;    // operator symbol (like "<", "!=", "param" etc)
        string _arg1 ;  // name of the variable/temporary/symbol that stores the 1st arguement/operand (if any)
        string _arg2 ;  // name of the variable/temporary/symbol that stores the 2nd arguement/operand (if any)
        
        Quad ( string , int , string = "=" , string = "" ) ;    // constructor (overloaded)
        Quad ( string , float , string = "=" , string = "" ) ;  // constructor (overloaded)
        Quad ( string , string , string = "=" , string = "" ) ; // constructor (overloaded)
        void print ( ) const ;  // non-static method to print the quad (during lazy spitting)
} ;


// QuadArray is a data-structure needed to remember the quads generated so far in an array. This is
// important because we cannot print the quad as soon as it is "emitted", it has to be stored for
// possible backpatching. Therefore, the quads are stored in an array and once the parser finishes with
// the entire source code, the quads are printed in the same sequence (lazy spitting).
class QuadArray {
    public:
        vector <Quad> _quads ;  // array of Quad objects
        QuadArray ( ) ; // constructor
        static void emit ( string , string , int , string = "" ) ;  // static-method to create a Quad and insert it to the "_quads" 
                                                                    // array of __quad_array__ (global QuadArray object).
        static void emit ( string , string , float , string = "" ) ;  // static-method (overloaded)
        static void emit ( string , string , string = "" , string = "" ) ; // static-method (overloaded)
        void print ( ) const ;  // non-static method to print all the quads in the "_quads" array (during lazy spitting)
} ;

// To handle labels (like "L0:") that we write in the source-code.
class Label {
    public:
        string _name ;      // name of the label
        int _quadArrIndex ; // the address of the label (analogous to the index/position of the quad-array at which the label was defined)
        vector<int> _nextList ; // list of dangling goto statements
        Label ( string , int = -1 ) ;   // constructor
        static Label * lookup ( string ) ;  // static method to search for a label by its name (in the __labels__ global) when seen in the source code.
} ;

// for expression-type symbols
typedef struct E {
    Symbol * _loc ; // points to the ST entry
    string _type ;  // type of the expression
    int _width ;    // size/width of the type of the expression
    vector<int> _trueList ;     // (duality with boolean-types) dangling exits if in the boolean-form the expression evaluates to true/logic-1
    vector<int> _falseList ;    // (duality with boolean-types) dangling exits if in the boolean-form the expression evaluates to false/logic-0
    vector<int> _nextList ;     // list of dangling gotos for the case when expressions-like statements (eg- "3" is as much of a statement as "x=3")
} E ;

// for array-type symbols
typedef struct A {
    Symbol * _loc ;     // location to compute the address of the array element
    Symbol * _array ;   // points to the ST entry (stores name etc)
    string _arrType ;   // type of the entity; due to array-pointer duality, _arrType can be "ptr" or "arr"
    SymbolType * _type ;    // type of the element stored in the array
} A ;

// for statement-like symbols
typedef struct S {
    vector<int> _nextList ; // list of dangling gotos
} S ;