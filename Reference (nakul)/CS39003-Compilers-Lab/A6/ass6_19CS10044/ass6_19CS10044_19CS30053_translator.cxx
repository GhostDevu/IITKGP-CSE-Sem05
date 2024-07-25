
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O6 -- Intermediate Code Generator Source Code
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)

#include "ass6_19CS10044_19CS30053_translator.h"
#include <iostream>
#include <exception>
#include <algorithm>
#include <iomanip>
using namespace std ;
void yyerror ( string err ) { cout << "  " << err << endl ; }


////////////////////////////////////////// ++++ Global Definitions ++++ //////////////////////////////////////////

SymbolTable * __current_ST__ ;  // points to the current ST || needed to store symbols according to the scope in which they lie
SymbolTable * __global_ST__ ;   // points to the global ST || all function definitions are a part of global ST, other variable 
                                // definitions are also stored in global ST if the parser is not in any specific function scope.
SymbolTable * __current_parent_ST__ ;   // points to the parent of the current ST || important for maintaining a hierarchy of STs
Symbol * __current_symbol__ ;   // points to the most recently created symbol || it is imp. to keep track of current symbol because
                                // we might need to update the "nested table" field with the ST entirely dedictated to this current symbol, this happens
                                // in case the current symbol is a block (block inside a block OR block inside a function) or a function; in either case
                                // there will be a separate ST that is dedicated to the current symbol.
QuadArray __quad_array__ ;   // stores all the emitted quads in the form of an array || these quads are printed when the parser terminates (lazy splitting)
vector<pair<string, int>> __basic_type__ ;   // not used by the parser but is a helpful data structure to remember the sizes of the various data types; it enables easy
                                             // extension of the translator to more data types in future; implemented as array of string(name of type) & int(size of type) pairs.
int __num_tables__ ;        // stores the ID (or the count) of the next ST in the ST-heirarchy || imp. in order to name the STs meaningfully and without any name-conflict.
string __current_loop__ ;    // stores the name of the loop the parser is current inside || imp. in order to name the STs meaningfully, like ST for a "for"-block
                             // will be named by something as FOR.$0.$1
vector<Label> __labels__ ;   // a lookup tabel for labels || "__labels__" is to "Label" what "SymbolTable" is to "Symbol"; we can store all the labels together in the same list
int __next_temp_id__ ;      // stores the ID for the next compiler-generated-temporary || maintained in order to name temporaries meaningfully & without naming-conflict
string __variable_type__ ;  // type of the variable/identifier most recently scanned
vector<string> __string_literals__ ; // stores all the string constants in the source code || important in order to allocate them in the
                                     // data segment of the assembly code that will finally be generated

////////////////////////////////////////// ++++ Symbol ++++ //////////////////////////////////////////

Symbol::Symbol ( string name , string type , SymbolType * arrType , int symSize ) : // constructor
    _name(name), _type(new SymbolType(type, arrType, symSize)), _size(_type->size()), 
    _initVal(""), _nested(NULL), _offset(0), _isFunction(0), _retType(NULL), _category("local") { 
        if ( __current_ST__ == __global_ST__ )
            _category = "global" ;  // if the symbol is in global scope then the category will be global
}

void Symbol::print ( ) const {
    cout << "  | " << _name << string(max<int>(0, 23 - _name.size()), ' ') ;    // print name
    
    string type_string = _type->print() ;   // get the type of the symbol
    cout << " | " << type_string << string(max<int>(0, 19 - type_string.size()), ' ') ; // print type

    cout << " | " << _category << string(max<int>(0, 19 - _category.size()), ' ') ; // print type
    cout << "|  " << _initVal << string(max<int>(0, 80 - _initVal.size()), ' ') ;   // print initial value (will be an empty string "" if no initial value)
    cout << "| " << _size << string(8 - to_string(_size).size(), ' ') ;     // print size of the symbol
    cout << "| " <<  _offset << string(max<int>(0, 12 - to_string(_offset).size()), ' ') ;  // print the offset of the symbol in the ST

    // print the name of the name of the nested ST if there is a ST dedicated for this symbol
    if ( ! _nested ) cout <<  "| " << "Null" << string(26, ' ') ;
    else    cout <<  "| " << _nested->_name << string(max<int>(0, 30 - _nested->_name.size()), ' ') ;
    cout << "|" << endl ;
}

Symbol * Symbol::updateOffset ( int offset ) { _offset = offset ; return this ; }   // method that updates offset and returns the updated symbol
Symbol * Symbol::updateType ( SymbolType * t ) {    // method that updates type of the symbol
    _type = t ; _size = t->size() ; 
    if ( t->_type != "func" ) { // if the type is not "func", then _isFunction and _retType should also be reset accordingly
        _isFunction = 0 ;
        _retType = NULL ;
    }
    return this ;   // return the updated symbol
}    


////////////////////////////////////////// ++++ SymbolType ++++ //////////////////////////////////////////

SymbolType::SymbolType ( string type , SymbolType * arrType , int symSize ) :
    _type(type), _width(symSize), _arrayType(arrType), _isFunction(0) { }   // constructor

int SymbolType::size ( ) const {    // method returns the size of the symbol-type
    // __basic_type__ stores the sizes for different basic-types.
    // return size for appropriate types
    if ( _type.compare("null") == 0 )       return __basic_type__[8].second ;
    else if ( _type.compare("void") == 0 )  return __basic_type__[5].second ;
    else if ( _type.compare("char") == 0 )  return __basic_type__[2].second ;
    else if ( _type.compare("int") == 0 )   return __basic_type__[1].second ;
    else if ( _type.compare("float") == 0 ) return __basic_type__[0].second ;
    else if ( _type.compare("ptr") == 0 )   return __basic_type__[3].second ;
    else if ( _type.compare("func") == 0 )  return __basic_type__[6].second ;
    else if ( _type.compare("block") == 0 ) return __basic_type__[7].second ;

    // if the type is "arr", then the size has to be computed recursively because the
    // array can be multi-dimensional.
    else if ( _type.compare("arr") == 0 && _width == 0 )    return __basic_type__[3].second ; // if the _width of "arr" is 0, it means size of array is unspecified (eg - arr(*,int));
                                                                                              // in this case size of a "ptr" should be returned.
    else if ( _type.compare("arr") == 0 )   return _width * _arrayType->size() ;   // "_arrayType->size()" is the size of the elements of the array.
                                                                                   // when multiplied by the width (i.e, length of the array), the size of
                                                                                   // the type is obtained 
    yyerror(" ERROR [ SymbolType::size ] - Invalid type encountered") ; // parsing error if invalid type is encountered
    return 0 ;
}

string SymbolType::print ( ) const {    // method returns the type in the form of a string
    // __basic_type__ stores the official names for all the basic-types.
    // return the name for the appropriate type
    if ( _type.compare("null") == 0 )       return __basic_type__[8].first ;
    else if ( _type.compare("void") == 0 )  return __basic_type__[5].first ;
    else if ( _type.compare("char") == 0 )  return __basic_type__[2].first ;
    else if ( _type.compare("int") == 0 )   return __basic_type__[1].first ;
    else if ( _type.compare("float") == 0 ) return __basic_type__[0].first ;
    else if ( _type.compare("func") == 0 )  return __basic_type__[6].first ;
    else if ( _type.compare("block") == 0 ) return __basic_type__[7].first ;

    // in case of pointers and arrays, their string-formatted types have to be derived recursively.
    // Eg -- int** is returned as ptr(ptr(int)), similarly arr(3, arr(4, float)) is also a recursive definition.
    else if ( _type.compare("ptr") == 0 )   return __basic_type__[3].first + "(" + _arrayType->print() + ")" ; 
                                            // _arrayType in this case stores the the type of the variable to which this pointer points to.
                                            // Eg int** will be printed as  --  int** -> ptr(int*) -> ptr(ptr(int))
    
    else if ( _type.compare("arr") == 0 )   {
        string width_in_str = to_string(_width) ;
        if ( _width == 0 )  width_in_str = string(1, '*') ; // _width = 0 implies that the size of the array was unspecified; hence * must be used.
        return __basic_type__[4].first + "(" + width_in_str + "," + _arrayType->print() + ")" ;
        // _arrayType in this case stores the the type of the element of the array.
        // Eg char[][2][3] will be printed as  --  char[][2][3] -> arr(*, char[2][3]) -> arr(*, arr(2, char[3])) -> arr(*, arr(2, arr(3, char)))
    }
    
    yyerror(" ERROR [ SymbolType::print ] - Invalid type encountered") ; // parsing error if invalid type is encountered
    return 0 ;
}

SymbolType * SymbolType::copy ( ) const {   // method that retuns a copy of the SymbolType object
    SymbolType * st = new SymbolType(_type, _arrayType, _width) ;   // dynamically instantiate a new SymbolType object with the same arguements
    st->_isFunction = _isFunction ; // copy rest of the attributes
    return st ;
}


////////////////////////////////////////// ++++ SymbolTable ++++ //////////////////////////////////////////

SymbolTable::SymbolTable ( string name , SymbolTable * parentTable ) :
    _name(name), _parent(parentTable), _symbols(vector<Symbol*>()) { }  // constructor

Symbol * SymbolTable::lookup ( string name ) {  // method that searches a Symbol by the given name/ID
    Symbol * symbol ;
    int l = _symbols.size() ;
    
    for ( int i = 0 ; i < l ; i ++ ) {  // loop through the entire symbol table searching for the symbol by name
        if ( _symbols[i] && _symbols[i]->_name.compare(name) == 0 ) // if a symbol by the given name is found
            return _symbols[i] ;                                    // tehen return it
    }
    
    Symbol * p = NULL ;
    if ( _parent )  // if the ST is not global (i.e, has a parent ST), then search for the symbol by the same name in the parent ST
        p = _parent->lookup(name) ;
	
    if ( !p && __current_ST__ == this ) {   // if the symbol was not found (even in the parent ST) and "this" ST is the current ST, then
        symbol = new Symbol(name, "int") ;  // create a new symbol with th same name (default type assumed as int, can be changed later)
        _symbols.push_back(symbol) ;        // insert the new symbol into the ST and
        return symbol ;                     // return the symbol
    }
    if ( p )    return p ;  // if the symbol was found in the parent ST, return it
    return NULL ;   // not found (even in the parent ST) but cannot insert a new symbol because "this" ST is not in the current scope (so return NULL)
}

Symbol * SymbolTable::gentemp ( SymbolType * type , string value ) {
    // static method to generate a new temporary, insert it to the ST, and return a pointer to it
    string temporary_name = string(1, 't') + string(1, '#') + to_string(__next_temp_id__) ; // compiler-generated names are of the format "t#{id}" where id is any
                                                                                            // number; "t{id}"-type name was avoided so as to prevent naming conflicts
                                                                                            // with the identifier names in the source code.
    __next_temp_id__ ++ ;   // __next_temp_id__ incremented by 1
    Symbol * temp = new Symbol(temporary_name, type->_type, type->_arrayType, type->_width) ;   // create a new symbol and
    temp->_initVal = value ;                                                                    // assign the initial value "value" passed as arguement
    temp->_category = "temp" ;                                                                  // set the category type as "temp"
    __current_ST__->_symbols.push_back(temp) ;  // insert the temporary into the current ST
    return temp ;   // and return the temporary symbol
}

void SymbolTable::updateOffsets ( ) {   // method to update the offset of all the entries in this and the succesive STs
    vector<SymbolTable*> nestedTables ; // child STs of "this" ST
    int offset = 0 ;    // offset of the symbols in the ST, starts with offset 0 (convention)

    int l = _symbols.size() ;
    for ( int i = 0 ; i < l ; i ++ ) {  // loop through all the symbols and update their offsets in the ST
        _symbols[i]->updateOffset(offset) ;
        offset += _symbols[i]->_size ;
        if ( _symbols[i]->_nested ) // also append nestedTables whenever a child ST is detected
            nestedTables.push_back(_symbols[i]->_nested) ;
    }

    // now update the offset of all the child/nested STs by recursively calling "SymbolTable::updateOffsets"
    l = nestedTables.size() ;
    for ( int i = 0 ; i < l ; i ++ )
        nestedTables[i]->updateOffsets() ;
}

// method to update different fields of a ST entry (if found by name)
void SymbolTable::update ( string name , string field , SymbolType * newType ) { // "field": name of the field that is to be updated, 
                                                                                 // "newType": new type of the symbol in case field = type
                                                                                 // "name": name of the symbol to be updated
    if ( field.compare("offset") == 0 ) {
        // update the offset of all the entries in the ST.
        // As explained in .h file, updating offset of a single ST entry can lead to
        // errors. So offset of all the symbols in this ST should be updated.

        // Similar routine as "SymbolTable::updateOffsets", except that the nested STs are not updated
        int offset ;
        int l = _symbols.size() ;
        for ( int i = 0 ; i < l ; i ++ ) {
            if ( i == 0 ) {
                _symbols[i]->updateOffset(0) ;
                offset = _symbols[i]->_size ;
            }
            else {
                _symbols[i]->updateOffset(offset) ;
                offset += _symbols[i]->_size ;
            }
        }
        return ;
    }

    // "field" can only be "type" or "offset". No other attributes (like name, nested table) of a symbol can be changed
    // once initialized. Note that changing the type naturally causes a change in size/width etc attributes.
    
    // parsing error for invalid demands of changing a symbol's attributes
    if ( field.compare("type") != 0 ) yyerror(" ERROR [ SymbolTable::update ] - Invalid field option") ;
    
    // if the type has to be changed, "newType" cannot be "NULL"; hence the parsing error
    if ( ! newType )    yyerror(" ERROR [ SymbolTable::update ] - New type of the symbol cannot be NULL") ;

    int l = _symbols.size() ;
    for ( int i = 0 ; i < l ; i ++ )    // loop over all the symbols in the ST
        if ( (*_symbols[i])._name.compare(name) == 0 ) {    // and whenever a matching name is found,
            _symbols[i]->updateType(newType) ;  // update the type of the corresponding symbol
            return ;    // and return
        }
    
    return ;
}

// method to print the ST in a neat tabular fashion; demo is as follows.
//   +-------------------------------------------------------------------------------------------------------------------------------------------+
//   |  TABLE NAME : main                               PARENT NAME : ST.Global                                                                  |
//   +-------------------------------------------------------------------------------------------------------------------------------------------+
//   | NAME                    | TYPE                | CATEGORY           | INIT-VALUE   | SIZE    | OFFSET      | NESTED                        |
//   | return                  | int                 | local              |              | 4       | 0           | Null                          |
//   | t#85                    | ptr(char)           | temp               |              | 4       | 4           | Null                          |
//   | A                       | arr(10,int)         | local              |              | 40      | 8           | Null                          |
//   | t#86                    | int                 | temp               |  10          | 4       | 48          | Null                          |
//   | B                       | arr(10,int)         | local              |              | 40      | 52          | Null                          |
//   | t#87                    | int                 | temp               |  44          | 4       | 92          | Null                          |
//   | C                       | arr(10,int)         | local              |              | 40      | 96          | Null                          |
//   | t#88                    | int                 | temp               |  23          | 4       | 136         | Null                          |
//   | res                     | arr(10,int)         | local              |              | 40      | 140         | Null                          |
//   +-------------------------------------------------------------------------------------------------------------------------------------------+
// [ NOTE : Empty "INIT-VALUE" means no initial value is specified (null) ]
void SymbolTable::print ( bool rec ) const { // (the entire routine is based on hit & trial of value of widths and 
                                             // no. of spaces/delimiters/markers to obtain a perfect formatting)
    // if "rec" is true then all the nested STs are also printed in a recursive manner. That is in
    // the hierarchical tree of STs, all the STs contained in the subtree rooted at "this" ST will be printed.
    vector <SymbolTable*> tables ; // nested/child STs of "this" ST
    int width = 207 ;   // width of table (adjustable parameter)
    cout << "  +" << string(width, '-') << '+' << endl ;

    // print the table header that consists of (1.) ST's name, (2.) name of the parent of ST
    cout << "  |  TABLE NAME : " << _name << string(30, ' ') ;
	cout << " PARENT NAME : " ;
    if( ! _parent ) cout << "Null" << string(max<int>(0, width - _name.size() - 64), ' ') ;
    else    cout << _parent->_name << string(max<int>(0, width- _name.size()- _parent->_name.size() - 60), ' ') ;
    cout << "|" << endl ;
    cout << "  +" << string(width, '-') << '+' << endl ;
    
    // print column names (as given in the assignment)
	cout << "  | NAME " << string(19, ' ') ;
    cout << "| TYPE " << string(15, ' ') ;
    cout << "| CATEGORY " << string(10, ' ') ;
    cout << "| INIT-VALUE " << string(70, ' ') ;
    cout << "| SIZE " << string(3, ' ') ;
    cout << "| OFFSET " << string(5, ' ') ;
    cout << "| NESTED " << string(23, ' ') << "|" << endl ;

    int symCount = _symbols.size() ;
    for ( int i = 0 ; i < symCount ; i ++) {    // loop through all the symbols in the ST and print them
        _symbols[i]->print() ;
        if ( _symbols[i]->_nested )
            tables.push_back(_symbols[i]->_nested) ;
    }
    
    cout << "  +" << string(width, '-') << '+' << endl ;
    cout << endl ;

    // if "rec" is true, print the nested STs by recursively calling "SymbolTable::print"
    if ( rec ) {
        int nestedTablesCount = tables.size() ;
        for ( int i = 0 ; i < nestedTablesCount ; i ++ )
            tables[i]->print(true) ;
    }
}

void SymbolTable::switchCurrentST ( ) {
    // method to change the current ST, i.e, "__current_ST__" global variable. It is needed when the scope is
    // changed in the program, like you enter a (nested)block or a function.
    __current_ST__ = this ; // change the "__current_ST__" global variable
}


////////////////////////////////////////// ++++ Quad ++++ //////////////////////////////////////////

Quad::Quad ( string result , int arg1 , string op , string arg2 ) :
    _result(result), _op(op), _arg1(to_string(arg1)), _arg2(arg2)   { } // constructor (overloaded) -- when arg1 is passed as int

Quad::Quad ( string result , float arg1 , string op , string arg2 ) :
    _result(result), _op(op), _arg1(to_string(arg1)), _arg2(arg2)   { } // constructor (overloaded) -- when arg1 is passed as float

Quad::Quad ( string result , string arg1 , string op , string arg2 ) :
    _result(result), _op(op), _arg1(arg1), _arg2(arg2)   { } // constructor (overloaded) -- when arg1 is passed as string

void Quad::print ( ) const {    // method to print the quad (during lazy spitting)
    vector<string> nonRelationalBinaryOps({ "+", "-", "*", "/", "%", "|", "^", "&", "<<", ">>" }) ;
    if ( find(nonRelationalBinaryOps.begin(), nonRelationalBinaryOps.end(), _op) 
            != nonRelationalBinaryOps.end() ) { // if "_op" is in "nonRelationalBinaryOps" then print in the following format.
        cout << _result << " = " << _arg1 << " " << _op << " " << _arg2 << endl ;
        return ;
    }

    vector<string> relationalBinaryOps = { "<", ">", "<=", ">=", "==", "!=" } ;
    if ( find(relationalBinaryOps.begin(), relationalBinaryOps.end(), _op) 
            != relationalBinaryOps.end() ) { // if "_op" is in "relationalBinaryOps" then print in the following format.
        cout << "if " << _arg1 << " " << _op << " " << _arg2 << " goto " << _result << endl ;
        return ;
    }
    
    // print the quad in a suitable format depending upon the type of operation determined by "_op"
    if ( _op == "goto" )        cout << "goto " << _result << endl ;
    else if ( _op == "sizeof" ) cout << _result << " = sizeof(" << _arg1 << ")" << endl ;
    else if ( _op == "=" || find(_op.begin(), _op.end(), '@') != _op.end() )      
        cout << _result << " = " << _arg1 << endl ;
    else if ( _op == "~" )      cout << _result << " = ~ " << _arg1 << endl ;
    else if ( _op == "!" )      cout << _result << " = ! " << _arg1 << endl ;
    else if ( _op == "uminus" ) cout << _result << " = - " << _arg1 << endl ;

    else if ( _op == "*=" )     cout << "*" << _result << " = " << _arg1 << endl ;
    else if ( _op == "=*" )     cout << _result << " = *" << _arg1 << endl ;
    else if ( _op == "=&" )     cout << _result << " = &" << _arg1 << endl ;
    else if ( _op == "[]=" )    cout << _result << "[" << _arg1 << "] = " << _arg2 << endl ;
    else if ( _op == "=[]" )    cout << _result << " = " << _arg1 << "[" << _arg2 << "]" << endl ;

    else if ( _op == "label" || _op == "func" || _op == "loop_block")  cout << _result << " :" << endl ;
    else if ( _op == "param" )  cout << "param " << _result << endl ;
    else if ( _op == "call" )   cout << _result << " = call " << _arg1 << ", " << _arg2 << endl ;
    else if ( _op == "return" )  cout << "return " << _result << endl ;
    else if ( _op == "funcend" ) cout << _result << "_END :" << endl ;
    else    yyerror(" ERROR [ Quad::print ] - Invalid operator encountered")  ; // parsing error when an invalid operator is seen
}


////////////////////////////////////////// ++++ QuadArray ++++ //////////////////////////////////////////

QuadArray::QuadArray ( ) : _quads(vector<Quad>()) { }   // constructor (_quads initialized with empty vector)

// overloaded static methods "emit" create a Quad object and insert it into the _quads field of global __quad_array__ object.
void QuadArray::emit ( string op , string result , int arg1 , string arg2 ) {   // emit when arg1 is passed as int
    Quad * quad = new Quad(result, arg1, op, arg2) ;    // create a new Quad
    __quad_array__._quads.push_back(*quad) ;            // and insert it into the _quads field of __quad_array__ global object.
}

void QuadArray::emit ( string op , string result , float arg1 , string arg2 ) {   // emit when arg1 is passed as float
    Quad * quad = new Quad(result, arg1, op, arg2) ;    // create a new Quad
    __quad_array__._quads.push_back(*quad) ;            // and insert it into the _quads field of __quad_array__ global object.
}

void QuadArray::emit ( string op , string result , string arg1 , string arg2 ) {   // emit when arg1 is passed as string
    Quad * quad = new Quad(result, arg1, op, arg2) ;    // create a new Quad
    __quad_array__._quads.push_back(*quad) ;            // and insert it into the _quads field of __quad_array__ global object.
}

void QuadArray::print ( ) const {   // method to print all the quads in the "_quads" array (during lazy spitting)
    cout << endl << endl ;
    int n = _quads.size() ;
    for ( int i = 0 ; i < n ; i ++ ) {  // loop over all the quads
        cout << setw(4) << i << "  |  " ;   // (formatting)
        if ( _quads[i]._op != "label" ) cout << '\t' ;
        _quads[i].print() ; // print the quad
    }
    cout << endl << endl ;
}


////////////////////////////////////////// ++++ Label ++++ //////////////////////////////////////////

Label::Label ( string name , int idx ) :
    _name(name), _quadArrIndex(idx), _nextList(vector<int>())   { }     // constructor

Label * Label::lookup ( string name ) {     // static method to search for a label by its name (in the __labels__ global) when seen in the source code
    int n = __labels__.size() ;
    for ( int i = 0 ; i < n ; i ++ ) {  // loop through all the Label objects in the __labels__ array
        if ( __labels__[i]._name == name )  // when a matching name is found,
            return &__labels__[i] ;     // return the pointer to that Label
    }
    return NULL ;   // return NULL if nothing is found
}


////////////////////////////////////////// ++++ Global Functions ++++ //////////////////////////////////////////

// ++ INPUTS ++
//      instr - the instruction no. (index in quad array) for which a new list has to be created
// ++ OUTPUTS ++
//      A new list (vector<int>) that only has "instr" as its element
// ++ PURPOSE ++
//      To create a new list containing a single quad-array index and return it
vector<int> makelist ( int instr ) {
    return vector<int>({instr}) ;   // return a new list that only has "instr" as its element
}

// ++ INPUTS ++
//      quadIndices1 - 1st list of quad array indices
//      quadIndices2 - 2nd list of quad array indices
// ++ OUTPUTS ++
//      A new list (vector<int>) that is a concatenation of "quadIndices1" and "quadIndices2"
// ++ PURPOSE ++
//      To concatenate two lists into a new list and return the new one
vector<int> merge ( vector<int> & quadIndices1 , vector<int> & quadIndices2 ) {
    vector<int> merged ;    // new list
    for ( auto & idx : quadIndices1 )   merged.push_back(idx) ; // push all the indices in the first list to the new list
    for ( auto & idx : quadIndices2 )   merged.push_back(idx) ; // push all the indices in the second list to the new list
    return merged ; // return new list
}

// ++ INPUTS ++
//      quadIndices - list of quad array indices with dangling exits
//      address - target instruction address (index in the quad array)
// ++ OUTPUTS ++
//      -- X --
// ++ PURPOSE ++
//      To insert the given quad-index "address" as the target label for all the quads in __quad_array__ at "quadIndices" indices
void backpatch ( vector<int> & quadIndices , int address ) {
    for ( int idx : quadIndices )
        __quad_array__._quads[idx]._result = to_string(address) ;   // update the _result field for all the quads in global __quad_array__, 
                                                                    // at an index in "quadIndices", with the target address/index.
}

// ++ INPUTS ++
//      -- X -- 
// ++ OUTPUTS ++
//      Quad array index that corresponds to the address of the next instruction
// ++ PURPOSE ++
//      To return the address of the next instruction (i.e, index of the next quad in the global __quad_array__)
int nextinstr ( ) {
    return __quad_array__._quads.size() ;   // the size of the __quad_array__._quads array/vector will be the next-instruction index
                                            // (assuming the addresses start with the instruction 0)
}

// ++ INPUTS ++
//      exp - ptr to the E (Expression) whose type has to be converted to int
// ++ OUTPUTS ++
//      Pointer to the same E (Expression) that is type-casted (if the original type was boolean) to int
// ++ PURPOSE ++
//      To convert the type of input E (Expression) to int if the original type is boolean
E * convBool2Int ( E * exp ) {
    if ( exp->_type == "bool" ) {   // convert only if the type of the input is actually boolean
        exp->_loc = SymbolTable::gentemp(new SymbolType("int")) ;   // compiler-generated temporary
        backpatch(exp->_trueList, nextinstr()) ;    // backpatching of dangling exits for true value
        QuadArray::emit("=", exp->_loc->_name, "1") ;   // if the boolean is true, assign 1 to the int
        QuadArray::emit(to_string(nextinstr() + 1), "goto") ;
        backpatch(exp->_falseList, nextinstr()) ;    // backpatching of dangling exits for false value
        QuadArray::emit("=", exp->_loc->_name, "0") ;   // if the boolean is false, assign 0 to the int
    }
    return exp ;
}

// ++ INPUTS ++
//      exp - ptr to the E (Expression) whose type has to be converted to float
// ++ OUTPUTS ++
//      Pointer to the same E (Expression) that is type-casted (if the original type was boolean) to float
// ++ PURPOSE ++
//      To convert the type of input E (Expression) to float if the original type is boolean
E * convBool2Flt ( E * exp ) {
    if ( exp->_type == "bool" ) {   // convert only if the type of the input is actually boolean
        exp->_loc = SymbolTable::gentemp(new SymbolType("float")) ;   // compiler-generated temporary
        backpatch(exp->_trueList, nextinstr()) ;    // backpatching of dangling exits for true value
        QuadArray::emit("=", exp->_loc->_name, "1.000000") ;   // if the boolean is true, assign 1.000000 to the float
        QuadArray::emit(to_string(nextinstr() + 1), "goto") ;
        backpatch(exp->_falseList, nextinstr()) ;    // backpatching of dangling exits for false value
        QuadArray::emit("=", exp->_loc->_name, "0.000000") ;   // if the boolean is false, assign 0.000000 to the float
    }
    return exp ;
}

// ++ INPUTS ++
//      exp - ptr to the E (Expression) whose type has to be converted to char
// ++ OUTPUTS ++
//      Pointer to the same E (Expression) that is type-casted (if the original type was boolean) to char
// ++ PURPOSE ++
//      To convert the type of input E (Expression) to char if the original type is boolean
E * convBool2Char ( E * exp ) {
    if ( exp->_type == "bool" ) {   // convert only if the type of the input is actually boolean
        exp->_loc = SymbolTable::gentemp(new SymbolType("char")) ;   // compiler-generated temporary
        backpatch(exp->_trueList, nextinstr()) ;    // backpatching of dangling exits for true value
        QuadArray::emit("=", exp->_loc->_name, "1") ;   // if the boolean is true, assign 1 (char with ascii 1) to the char
        QuadArray::emit(to_string(nextinstr() + 1), "goto") ;
        backpatch(exp->_falseList, nextinstr()) ;    // backpatching of dangling exits for false value
        QuadArray::emit("=", exp->_loc->_name, "0") ;   // if the boolean is true, assign 0 (char with ascii 0) to the char
    }
    return exp ;
}

// ++ INPUTS ++
//      exp - ptr to the E (Expression) whose type has to be converted to boolean-type
// ++ OUTPUTS ++
//      Pointer to the same E (Expression) that is type-casted (if the original type was int) to boolean-type
// ++ PURPOSE ++
//      To convert the type of input E (Expression) to boolean-type if the original type is int
E * convInt2Bool ( E * exp ) {
    if ( ! exp || ! exp->_loc ) return exp ;
    if ( exp->_loc->_type->_type == "int" )  {   // convert only if the type of the input is actually int
        exp->_falseList = makelist(nextinstr()) ;   // make falselist (dangling exit on false values) for the boolean-type
        QuadArray::emit("==", "", exp->_loc->_name, "0") ;  // dangling false exit (i.e, when int value is 0)
        exp->_trueList = makelist(nextinstr()) ;   // make truelist (dangling exit on true values) for the boolean-type
        QuadArray::emit("goto", "") ;  // dangling true exit (i.e, when int value is not 0)
    }
    return exp ;
}

// ++ INPUTS ++
//      exp - ptr to the E (Expression) whose type has to be converted to float
// ++ OUTPUTS ++
//      Pointer to the same E (Expression) that is type-casted (if the original type was int) to float
// ++ PURPOSE ++
//      To convert the type of input E (Expression) to float if the original type is int
E * convInt2Flt ( E * exp ) {
    if ( exp->_type == "int" )  {   // convert only if the type of the input is actually int
        Symbol * t = SymbolTable::gentemp(new SymbolType("float")) ;   // compiler-generated temporary
        QuadArray::emit("=", t->_name, "=", "int2float(" + exp->_loc->_name + ")") ;    // eg - t0 = int2float(a)
        exp->_loc = t ; exp->_type = t->_type->_type ; exp->_width = t->_size ; // update the loc, type & size/width of the expression
    }
    return exp ;
}

// ++ INPUTS ++
//      exp - ptr to the E (Expression) whose type has to be converted to boolean-type
// ++ OUTPUTS ++
//      Pointer to the same E (Expression) that is type-casted (if the original type was float) to boolean-type
// ++ PURPOSE ++
//      To convert the type of input E (Expression) to boolean-type if the original type is float
E * convFlt2Bool ( E * exp ) {
    if ( ! exp || ! exp->_loc ) return exp ;
    if ( exp->_loc->_type->_type == "float" )  {   // convert only if the type of the input is actually float
        exp->_falseList = makelist(nextinstr()) ;   // make falselist (dangling exit on false values) for the boolean-type
        QuadArray::emit("==", "", exp->_loc->_name, "0.000000") ;   // dangling false exit (i.e, when float value is 0.000000)
        exp->_trueList = makelist(nextinstr()) ;   // make truelist (dangling exit on true values) for the boolean-type
        QuadArray::emit("goto", "") ;  // dangling true exit (i.e, when float value is not 0.000000)
    }
    return exp ;
}

// ++ INPUTS ++
//      exp - ptr to the E (Expression) whose type has to be converted to int
// ++ OUTPUTS ++
//      Pointer to the same E (Expression) that is type-casted (if the original type was char) to int
// ++ PURPOSE ++
//      To convert the type of input E (Expression) to int if the original type is char
E * convChar2Int ( E * exp ) {
    if ( exp->_type == "char" )  {   // convert only if the type of the input is actually char
        Symbol * t = SymbolTable::gentemp(new SymbolType("int")) ;   // compiler-generated temporary
        QuadArray::emit("=", t->_name, "char2int(" + exp->_loc->_name + ")") ;    // eg - t0 = char2int(a)
        exp->_loc = t ; exp->_type = t->_type->_type ; exp->_width = t->_size ; // update the loc, type & size/width of the expression
    }
    return exp ;
}

// ++ INPUTS ++
//      exp - ptr to the E (Expression) whose type has to be converted to float
// ++ OUTPUTS ++
//      Pointer to the same E (Expression) that is type-casted (if the original type was char) to float
// ++ PURPOSE ++
//      To convert the type of input E (Expression) to float if the original type is char
E * convChar2Flt ( E * exp ) {
    if ( exp->_type == "char" )  {   // convert only if the type of the input is actually char
        Symbol * t = SymbolTable::gentemp(new SymbolType("float")) ;   // compiler-generated temporary
        QuadArray::emit("=", t->_name, "char2float(" + exp->_loc->_name + ")") ;    // eg - t0 = char2float(a)
        exp->_loc = t ; exp->_type = t->_type->_type ; exp->_width = t->_size ; // update the loc, type & size/width of the expression
    }
    return exp ;
}

// ++ INPUTS ++
//      exp - ptr to the E (Expression) whose type has to be converted to boolean-type
// ++ OUTPUTS ++
//      Pointer to the same E (Expression) that is type-casted (if the original type was char) to boolean-type
// ++ PURPOSE ++
//      To convert the type of input E (Expression) to boolean-type if the original type is char
E * convChar2Bool ( E * exp ) {
    if ( ! exp || ! exp->_loc ) return exp ;
    if ( exp->_loc->_type->_type == "char" )  {   // convert only if the type of the input is actually char
        exp->_falseList = makelist(nextinstr()) ;   // make falselist (dangling exit on false values) for the boolean-type
        QuadArray::emit("==", "", exp->_loc->_name, "0") ;   // dangling false exit (i.e, when ascii code of char value is 0)
        exp->_trueList = makelist(nextinstr()) ;   // make truelist (dangling exit on true values) for the boolean-type
        QuadArray::emit("goto", "") ;   // dangling true exit (i.e, when ascii code of char value is not 0)
    }
    return exp ;
}

// ++ INPUTS ++
//      exp1 - ptr to the first E (Expression)
//      exp2 - ptr to the second E (Expression)
// ++ OUTPUTS ++
//      -- X --
// ++ PURPOSE ++
//      To check if two expressions are of same types. If not, then to check if they  
//      have compatible types (that is, one can be converted to the other without any 
//      possible loss of information). In this case, the first one is converted into the 
//      type of the second one or the second one is converted to the type of the first 
//      one using an appropriate function conv<t1>2<t2>(E1,E2) from above. If the types
//      are incomaptible or invalid, a yyerror is reported.
// ++ NOTES ++
//      This function enables conversion of type of exp1 to the type of exp2 or vice-versa.
//      As a result of this, as long as the types are compatible (belong to int, float, char), 
//      one of them can always be converted to the other such that the size of the type does
//      not decrease, i.e, if one type is int & other is float, though float can forcefully be 
//      converted to int, but in this case int is converted to float (no loss of information).
//      Therefore, "typecheck" function enables typecasts that can happen implicitly without
//      yielding any warnings.
// ++ COMMENTS ++
//      While using a cast operator, like "(int)x" where x is a float, this function cannot be 
//      used because size of float (8) > size of int (4). So for explicit typecasting in C, 
//      we have written another function "typecast" that will be discussed later.
void typecheck ( E * & exp1 , E * & exp2 ) {
    if ( exp1->_type == exp2->_type ) return ;  // return if the types are already equal
    
    if ( exp1->_type == "int" ) {   // CASE 1. When type(exp1) is int
        if ( exp2->_type == "float" ) { // [type(exp2) is float]
            exp1 = convInt2Flt(exp1) ;  // size(float) = 8 > 4 = size(int)
            return ;                    // so exp1 is converted to float
        }
        else if ( exp2->_type == "char" ) { // [type(exp2) is char]
            exp2 = convChar2Int(exp2) ;  // size(char) = 1 < 4 = size(int)
            return ;                     // so exp2 is converted to int
        }
        yyerror(" ERROR [ typecheck(E*&, E*&) ] - Incompatibility/invalidity of types") ;   // parsing error
    }

    if ( exp1->_type == "float" ) {   // CASE 2. When type(exp1) is float
        if ( exp2->_type == "int" ) { // [type(exp2) is int]
            exp2 = convInt2Flt(exp2) ;  // size(float) = 8 > 4 = size(int)
            return ;                    // so exp2 is converted to float
        }
        else if ( exp2->_type == "char" ) { // [type(exp2) is char]
            exp2 = convChar2Flt(exp2) ;  // size(char) = 1 < 8 = size(float)
            return ;                     // so exp2 is converted to float
        }
        yyerror(" ERROR [ typecheck(E*&, E*&) ] - Incompatibility/invalidity of types") ;   // parsing error
    } 

    if ( exp1->_type == "char" ) {   // CASE 3. When type(exp1) is char
        if ( exp2->_type == "int" ) { // [type(exp2) is int]
            exp1 = convChar2Int(exp1) ;  // size(char) = 1 < 4 = size(int)
            return ;                     // so exp1 is converted to int
        }
        else if ( exp2->_type == "float" ) { // [type(exp2) is float]
            exp1 = convChar2Flt(exp1) ;  // size(char) = 1 < 8 = size(float)
            return ;                     // so exp1 is converted to float
        }
        yyerror(" ERROR [ typecheck(E*&, E*&) ] - Incompatibility/invalidity of types") ;   // parsing error
    }

    yyerror(" ERROR [ typecheck(E*&, E*&) ] - Incompatibility/invalidity of types") ;   // parsing error
}

// ++ INPUTS ++
//      s1 - ptr to the first Symbol
//      s2 - ptr to the second Symbol
// ++ OUTPUTS ++
//      Returns true if the types are valid and one can be converted into the other without
//      any possible loss of information, otherwise false is returned. 
// ++ PURPOSE ++
//      To check if two symbols are of same types. If not, then to check if they have 
//      compatible types (that is, one can be converted to the other without any possible 
//      loss of information). In this case, the first one is converted into the type of
//      the second one or the second one is converted to the type of the first one using
//      the "typecast" global function. If the types are incomaptible, false is returned.
// ++ NOTES ++
//      Similar to the "typecheck" function but this one works for Symbol's while the 
//      "typecheck" worked for Expression's. Like "typecheck" function, this function
//      also permits type conversions bw equal sizes or from smaller to larger sizes.
bool comparetype ( Symbol * & s1 , Symbol * & s2 ) {
    SymbolType * t1 = s1->_type ;   // type of first symbol
    SymbolType * t2 = s2->_type ;   // type of second symbol
    if ( comparetype(t1, t2) ) return true ;    // comparetype(SymbolType*,SymbolType*) global function returns 
                                                // true if and only if two SymbolType objects represent same types.
    if ( t1->_type == "int" ) {   // CASE 1. When type(s1) is int
        if ( t2->_type == "char" )  { typecast(s2, t1->_type) ; return true ; }  // char(size=1) -> int(size=4) conversion
        if ( t2->_type == "float" )  { typecast(s1, t2->_type) ; return true ; } // int(size=4) -> float(size=8) conversion
        return false ;  // incompatible/invalid type
    }

    if ( t1->_type == "float" ) {   // CASE 2. When type(s1) is float
        if ( t2->_type == "char" )  { typecast(s2, t1->_type) ; return true ; } // char(size=1) -> float(size=8) conversion
        if ( t2->_type == "int" )  { typecast(s2, t1->_type) ; return true ; }  // int(size=4) -> float(size=8) conversion
        return false ;  // incompatible/invalid type
    }

    if ( t1->_type == "char" ) {   // CASE 3. When type(s1) is char
        if ( t2->_type == "int" )  { typecast(s1, t2->_type) ; return true ; }      // char(size=1) -> int(size=4) conversion
        if ( t2->_type == "float" )  { typecast(s1, t2->_type) ; return true ; }    // char(size=1) -> float(size=8) conversion
        return false ;  // incompatible/invalid type
    }
    return false ;  // incompatible/invalid type
}

// ++ INPUTS ++
//      t1 - first type (ptr to first SymbolType obj.)
//      t2 - second type (ptr to second SymbolType obj.)
// ++ OUTPUTS ++
//      Returns true if the two SymbolType objects represent exactly the same type,
//      returns false otherwise.
// ++ PURPOSE ++
//      To check if two SymbolType types are equal or not.
// ++ ALGORITHM ++
//      Some types (like ptr and arr) have to be checked for equality recursively. Like
//      for "ptr" types, it is not enough to check if the two types are pointers, we should
//      also check if the types these pointers point to are also equal. Eg - ptr(int) &
//      ptr(ptr(int)) are certainly not equal. Same applies for arrays. Eg - arr(*, int)
//      & arr(*, arr(2, int)) are unequal though they both are of "arr" types. In this case
//      the type of the element of the array has to be checked for equality recursively.
bool comparetype ( SymbolType * t1 , SymbolType * t2 ) {
    if ( ! t1 && ! t2 ) return true ;   // (trivial case)
    else if ( ! t1 || ! t2 || t1->_type != t2->_type )  return false ;  // difference in types found
    return comparetype(t1->_arrayType, t2->_arrayType) ;    // check recursively & return the result
    // Note that _arrayType would be null when the type is not "arr" or "ptr". In that case,
    // the next level of recursion will trivially return true. (line 714)
}

// ++ INPUTS ++
//      sym - pointer to the Symbol that has to be typecasted
//      cast_type - name of the type to which the Symbol has to be typecasted
//      force - Till now "comparetype" and "typecheck" functions allowed only those type 
//      conversions that happen from a type of smaller width to a type of larger (or equal)
//      width. But this "typecast" function can allow conversions that happen the other
//      way round (eg - float-to-int). When these conversions that can lead to a possible 
//      loss of information happen implicitly, a warning should be printed.
//      But when these conversions are "forced" explicitly through cast operators (like
//      "(float)x", where x is an int), then we do not print any warning.
//      So "force" = 1 --> the conversion is an explicit conversion (do not print warnings (if any))
//         "force" = 0 --> the conversion is an implicit conversion (print warnings (if any))
// ++ OUTPUTS ++
//      Returns the pointer to the same input Symbol (may or may not be successfully type-casted)
// ++ PURPOSE ++
//      To enable implicit and explicit type conversions and print warnings if necessary.
// ++ ALGORITHM ++
//      Very similar to "comparetype" and "typecheck" functions.
// [ NOTE : Here by "comparetype" we mean "comparetype(Symbol*&, Symbol*&)" overloaded function ]
Symbol * typecast ( Symbol * sym , string cast_type , int force ) {
    if ( sym->_type->_type == cast_type )   return sym ;    // simply return if the type is already same as requested
    
    if( sym->_type->_type.compare("float") == 0 ) { // CASE 1. type(sym) = float
        // float cannot be implicitly type-casted to int, char without any warning
        if ( force == 0 ) { // force = 0 --> implicit type-casting (so print warning)
            cout << "  WARNING [ typecast(Symbol*, string) ] - Data-type float should not be down-casted; possible loss of information" << endl ;    // print warning
        }
        Symbol * new_temp = SymbolTable::gentemp(new SymbolType(cast_type)) ;   // compiler-generated temporary
        QuadArray::emit("=", new_temp->_name, "float2" + cast_type + "(" + sym->_name + ")") ;  // emit casting operation
        return new_temp ;
    }

    Symbol * new_temp = SymbolTable::gentemp(new SymbolType(cast_type)) ;   // compiler-generated temporary
    
    if( sym->_type->_type.compare("int") == 0 ) {
        if ( cast_type == "float" ) {   // int->float conversion without any warning
            QuadArray::emit("=", new_temp->_name, "int2float(" + sym->_name + ")") ;  // emit casting operation
            return new_temp ;
        }
        // int cannot be implicitly type-casted to char without any warning
        if ( force == 0 ) {
            cout << "  WARNING [ typecast(Symbol*, string) ] - Data-type int should not be down-casted; possible loss of information" << endl ;    // print warning
        }
        QuadArray::emit("=", new_temp->_name, "int2" + cast_type + "(" + sym->_name + ")") ;  // emit casting operation
        return new_temp ;
    }

    if( sym->_type->_type.compare("char") == 0 ) {
        if ( cast_type == "int" ) {   // char->int conversion without any warning
            QuadArray::emit("=", new_temp->_name, "char2int(" + sym->_name + ")") ;  // emit casting operation
            return new_temp ;
        }
        if ( cast_type == "flt" ) {   // char->float conversion without any warning
            QuadArray::emit("=", new_temp->_name, "char2float(" + sym->_name + ")") ;  // emit casting operation
            return new_temp ;
        }
        if ( force == 0 ) {
            cout << "  WARNING [ typecast(Symbol*, string) ] - Data-type char should not be down-casted, possible loss of information" << endl ;    // print warning
        }
        QuadArray::emit("=", new_temp->_name, "char2" + cast_type + "(" + sym->_name + ")") ;  // emit casting operation
        return new_temp ;
    }
    
    cout << "  WARNING [ typecast(Symbol*, string) ] - Invalid data-type encountered for type-casting" << endl ;    // print warning
    return sym ;    // return symbol (not type-casted)
}


// ////////////////////////////////////////// ++++ Main Function ++++ //////////////////////////////////////////

// int main ( ) {
//     // assign initial values to all the global/external variables
//     __next_temp_id__ = 0 ;  // compiler-generated temporary starts with ID 0
//     __num_tables__ = 0 ;    // inital no. of tables = 0
//     __current_loop__ = "" ; // not inside any loop initially
//     __labels__ = vector<Label> ( ) ;    // no Label's were seen initially
    
//     // All the basic types that are handled by the compiler are inserted into the __basic_type__ global
//     // The sizes are the same as specified in the assignment.
//     __basic_type__.push_back({"float", 8}) ;
//     __basic_type__.push_back({"int", 4}) ;
//     __basic_type__.push_back({"char", 1}) ;
//     __basic_type__.push_back({"ptr", 4}) ;
//     __basic_type__.push_back({"arr", 0}) ;
//     __basic_type__.push_back({"void", 0}) ;
//     __basic_type__.push_back({"func", 0}) ;
//     __basic_type__.push_back({"block", 0}) ;
//     __basic_type__.push_back({"null", 0}) ;

//     __global_ST__ = new SymbolTable("ST.Global") ;  // create global ST
//     __current_ST__ = __global_ST__ ;    // the source-code initally starts with the global scope
//     __current_parent_ST__ = NULL ;      // parent of the global ST is Null

//     cout << endl << endl << "\t\t ++++++ ERRORS & WARNINGS ++++++" << endl << endl ;    // some warnings/errors might be printed while parsing
//     yyparse() ; // start parsing
//     cout << endl << endl ;

//     __global_ST__->updateOffsets() ;    // recursively update the offset of symbols in all 
//                                         // the STs in the hierarchy rooted at the global ST
    
//     cout << endl << endl << "\t\t ++++++ THREE ADDRESS CODE ++++++" ;   // [ PRINT THREE ADDRESS CODE ]
//     __quad_array__.print() ;    // print all the Quad's in the __quad_array__._quads vector

//     cout << endl << endl << "\t\t ++++++ SYMBOL TABLES ++++++" << endl << endl ;    // [ PRINT SYMBOL TABLE(S) ]
//     __global_ST__->print(true) ;    // recursively print all the STs in the hierarhcy rooted at the global ST

//     return 0 ;
// }
