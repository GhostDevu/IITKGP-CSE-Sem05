
%{
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O5 -- Parser for tinyC
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)
    
    // Include the Header Files
	#include <iostream>
	#include <string>
	#include <vector>
	#include <sstream>
	#include "ass5_19CS10044_19CS30053_translator.h"	// Include the header for the Translator File
	
	using namespace std;
	
	extern int yylex ( );		// yylex for Lexer for tinyC
	extern void yyerror ( string );	// yyerror for error recovery
	extern string __variable_type__;	// __variable_type__ for last encountered type (Inherited Attribute)
	extern vector<Label> __labels__;	// __labels__ to store the labels
	int __return_type_is_ptr__ = -1 ;	// indicates if the return-type of the function is a pointer or not
%}

%union {
			// yylval is a union of all these types
			char unary_Operator;               // Unary Operator - Char to store the unary operator such as '-', '!' etc.	
			char* pointer_to_char;           // Char value -  Stores the base address of the string (Character Pointer)
			int instruction_number;           // Instruction Number - Stores the current instruction number (used for backpatching)
			int size_of_type;				// Size Of Type - Size of the current data type
			int integer_value;                 // Integer Value - Used to store integer constants	
			int number_of_parameters;             // Number of Parameters - Used to store the number of parameters of a function
			E* pointer_to_expression;           // Expression - Stores the pointer to an expression being reduced
			S* pointer_to_statement;            // S - Stores the pointer to a Statement being reduced	
			SymbolType* pointer_to_symbol_type;       // Symbol Type - Stores the type of the symbol being stored in the symbol table  
			Symbol* pointer_to_symbol;                  // Symbol - Stores the pointer to the symbol being stored in the symbol table
			A* pointer_to_array;                   // Array - Stores the pointer to the array whose base address is being stored in the symbol table
		} 

// Keywords
%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN 
%token TYPEDEF AUTO REGISTER EXTERN STATIC INLINE SHORT SIGNED UNSIGNED 
%token LONG DOUBLE CONST VOLATILE ENUM _BOOL _COMPLEX _IMAGINARY
%token RESTRICT UNION SIZEOF STRUCT
%token <size_of_type> INT CHAR FLOAT VOID

%token ENUMERATION_CONST

%token OPENING_SQUARE_BRACKET CLOSING_SQUARE_BRACKET
%token OPENING_ROUND_BRACKET CLOSING_ROUND_BRACKET
%token OPENING_CURLY_BRACKET CLOSING_CURLY_BRACKET

// Operators
%token DOT ARROW_OP UNARY_INCREMENT_OP UNARY_DECREMENT_OP 
%token ADDITION_OP SUBTRACTION_OP MULTIPLICATION_OP DIVISION_OP MODULUS_OP
%token RIGHT_SHIFT_OP LEFT_SHIFT_OP 
%token LESS_THAN_OP GREATER_THAN_OP LESS_THAN_EQUAL_OP GREATER_THAN_EQUAL_OP EQUALITY_OP INEQUALITY_OP
%token BITWISE_NOT_OP BITWISE_AND_OP BITWISE_XOR_OP BITWISE_OR_OP 
%token LOGICAL_NOT_OP LOGICAL_OR_OP LOGICAL_AND_OP
%token QUESTION_MARK COLON SEMICOLON ELLIPSIS
%token ASSIGNMENT_OP MULT_ASSIGN_OP DIV_ASSIGN_OP MOD_ASSIGN_OP ADD_ASSIGN_OP SUB_ASSIGN_OP LSHIFT_ASSIGN_OP RSHIFT_ASSIGN_OP
%token BITWISE_AND_ASSIGN_OP BITWISE_XOR_ASSIGN_OP BITWISE_OR_ASSIGN_OP

%token COMMA HASH

%token <pointer_to_symbol> IDENTIFIER			// Identifier is a symbol 		 		
%token <integer_value> INTEGER_CONST		// Integer constant is returned as a integer value
%token <pointer_to_char> FLOAT_CONST		// Float constant is returned as a string
%token <pointer_to_char> CHAR_CONST		// Character constant is returned as a string
%token <pointer_to_char> STRING_LITERAL  // String literal is returned as a string

// Start the parsing with the translation unit
%start translation_unit

// To remove dangling else problem - While parsing an else is right associated with the nearest "then" (i.e. if)
%right "then" ELSE

// Unary operator - The type of the non-terminal unary_operator is unary_Operator which is a char
%type <unary_Operator> unary_operator

// Number of parameters - The type of the following non-terminals is int
%type <number_of_parameters> argument_expression_list argument_expression_list_opt

%type <size_of_type>
	type_specifier
	type_qualifier
	type_qualifier_list
	type_qualifier_list_opt
	specifier_qualifier_list
	specifier_qualifier_list_opt
	type_name

// Expressions - The type of the following non-terminals is expression
%type <pointer_to_expression>
	expression
	expression_opt
	primary_expression 
	multiplicative_expression
	additive_expression
	shift_expression
	relational_expression
	equality_expression
	AND_expression
	exclusive_OR_expression
	inclusive_OR_expression
	logical_AND_expression
	logical_OR_expression
	conditional_expression
	assignment_expression
	expression_statement
	
//Statements - The type of the following non-terminals is a statement
%type <pointer_to_statement>  statement
	compound_statement
	loop_body_statement
	selection_statement
	iteration_statement
	labeled_statement 
	jump_statement
	block_item
	block_item_list
	block_item_list_opt

// Symbol type - The type of the non-terminal pointer is the type of the symbol being stored in the symbol table  
%type <pointer_to_symbol_type> pointer

// Symbol - The type of the following non-terminals is symbol
%type <pointer_to_symbol> initializer
%type <pointer_to_symbol> direct_declarator init_declarator declarator

// Array - The type of the following non-terminals is array
%type <pointer_to_array> postfix_expression
	unary_expression
	cast_expression
	
// Auxillary non-terminals M and N 
%type <instruction_number> M 		// The type of M is instruction_number which is an int (M marks the instr to be used for backpatching)
%type <pointer_to_statement> N				// The type of N is statement (We introduce a new statement N to prevent fall-through)

%%

// Grammar Augmentations and Their Explanations

M:  // Marker --> epsilon
	{
		// Marker Rule used in Backpatching
		// Stores the index of the next quad to be generated
		// Used in various control statements such as loops and if-else blocks

		$$ = nextinstr();
	}   
	;
	
N:  // Fall Through Guard --> epsilon
	{
		// Fall though Guard used for backpatching
		// It inserts a goto and stores the index of the next goto statement to guard against fallthrough
		// N->_nextList = makelist(nextinstr) we have defined nextlist for Statements

		$$ = new S(); // goto S
		$$->_nextList = makelist(nextinstr()); // nextlist of goto statements
		QuadArray::emit("goto","");
	}
	;
	
change_table:  // change_table --> epsilon 
	{    
		__current_parent_ST__ = __current_ST__;    // Used for changing to symbol table for a function
		if(__current_symbol__->_nested == NULL) 
		{
			SymbolTable *newst = new SymbolTable("") ;
			newst->switchCurrentST();	// Function symbol table doesn't already exist	
		}
		else 
		{
			__current_symbol__->_nested->switchCurrentST(); // Function symbol table already exists	
			QuadArray::emit("label", __current_ST__->_name); // Exmaple: label ST.main.for$2
		}
	}
	;
	
F:  // Marker for start of for loop --> epsilon
	{
		// Rule for identifying the start of the for statement
		__current_loop__ = "FOR";
	}   
	;
	
W:  // Marker for start of while loop --> epsilon
	{
		// Rule for identifying the start of a while statement
		__current_loop__ = "WHILE";
	}   
	;
	
D:  // Marker for start of do while loop --> epsilon
	{
		// Rule for identifyiong the start of the do while statement
		__current_loop__ = "DO_WHILE";
	}   
	;
	
CT:  
	{
		// Change the current symbol table pointer
		// This will be used for nested block statements
		string name = __current_ST__->_name + "." + __current_loop__ + "$" + to_string(__num_tables__); 	// Give new name for nested table (Example: ST.main.for$2)
		__num_tables__++; 														// Increment the table count
		Symbol* s = __current_ST__->lookup(name); 											// Lookup the table for new entry
		
		s->_nested = new SymbolTable(name);			// Add the new nested table as an entry
		s->_nested->_parent = __current_ST__;		// Make the current table the parent of the new nested table
		s->_name = name;							// Put the name of the new table in name
		s->_type = new SymbolType("block");			// Type of the table is a block
		s->_size = 0;								// The size of the "block" type symbol is 0
		__current_symbol__ = s;						// The current table is s
	}   
	;
	
// SECTION : EXPRESSIONS

primary_expression:	IDENTIFIER				
					{ 
						$$ = new E(); // create new expression E and store pointer to ST entry in the location			
	    				$$->_loc = $1; // E.loc = id
	    				$$->_type = "not-boolean"; // E.type = "not-boolean"
	    			}
					| INTEGER_CONST	
					{ 
						$$ = new E();	// create new expression E and store the value of the constant in a temporary	
						string p = to_string($1); // The integer constant is to be converted to string for emitting the TAC
						$$->_loc = SymbolTable::gentemp(new SymbolType("int"), p); // Generate a temporary for storing the integer constant (Example: t1)
						QuadArray::emit("=", $$->_loc->_name, p); // Emit the Three Address Code (Example: t1 = 5)
				
					}
					| FLOAT_CONST	
					{ 
						$$ = new E(); // create new expression E and store the value of the constant in a temporary
						$$->_loc = SymbolTable::gentemp(new SymbolType("float"), $1); // Generate a temporary for storing the float constant (Example: t1)
						QuadArray::emit("=", $$->_loc->_name, string($1)); // Emit the Three Address Code (Example: t1 = 5.3)
					}
					| CHAR_CONST	
					{ 
						$$ = new E(); // create new expression E and store the value of the constant in a temporary
						$$->_loc = SymbolTable::gentemp(new SymbolType("char"), $1); // Generate a temporary for storing the char constant (Example: t1)
						QuadArray::emit("=", $$->_loc->_name, string($1)); // Emit the Three Address Code (Example: t1 = c)
					} 
					| STRING_LITERAL		
					{ 
						$$ = new E(); // create new expression E and store the value of the constant in a temporary
						$$->_loc = SymbolTable::gentemp(new SymbolType("ptr"), $1); // Generate a temporary for storing the base address of the string literal (Example: t1)
						// The string literal is stored in memory and only its base address is noted
						$$->_loc->_type->_arrayType = new SymbolType("char");  // Type of the array whose base address is in the temporary is char
					}
					| OPENING_ROUND_BRACKET expression CLOSING_ROUND_BRACKET	
					{ 
						// primary_expression is equal to the expression in the round brackets
						// The round brackets is given for precedence.
						$$ = $2; 
					}
					;

postfix_expression:	primary_expression											
					{ 
						// Create new A and store the location of primary expression in it
						$$ = new A();	
						$$->_array = $1->_loc;	
						$$->_type = $1->_loc->_type;	// Type of the postfix expression is same as that of the primary expression
						$$->_loc = $$->_array;
					}
					| postfix_expression OPENING_SQUARE_BRACKET expression CLOSING_SQUARE_BRACKET 						
					{  
						$$ = new A();	
						$$->_type = $1->_type->_arrayType;                 // type = type of element of the array
						$$->_array = $1->_array;                        // Copy the base address
						$$->_loc = SymbolTable::gentemp(new SymbolType("int"));     // Store computed address in a temporary t1
						$$->_arrType = "arr";                            // atype is arr
						
						// if already arr, multiply the size of the sub-type of Array with the expression value and add
						if($1->_arrType == "arr") 
						{			                               
							Symbol* t = SymbolTable::gentemp(new SymbolType("int")); // t2
							int p = $$->_type->size();
							string str = to_string(p);

							QuadArray::emit("*", t->_name, $3->_loc->_name, str); // t2 = i*4 where expression is i and type is int
							QuadArray::emit("+", $$->_loc->_name, $1->_loc->_name, t->_name); // t1 = A + t2 where A is the base address of the array
						}
						else 
						{   
							//if it is a 1- dimensional Array, compute the size of the type
							int p = $$->_type->size();	
							string str = to_string(p);
							QuadArray::emit("*", $$->_loc->_name, $3->_loc->_name, str); // t1 = A + 4 where type is int
						}
					}
					| postfix_expression OPENING_ROUND_BRACKET argument_expression_list_opt CLOSING_ROUND_BRACKET	
					{ 
						// Call the function with number of parameters from argument_expression_list_opt
						$$ = new A();	
						$$->_array = SymbolTable::gentemp($1->_loc->_retType); // Generate a temporary to store the return value of the function
						string str = to_string($3); // Get the number of arguments in the argument_expression_list_opt
						QuadArray::emit("call", $$->_array->_name, $1->_array->_name, str); // t1 = call F, 3
					}
					| postfix_expression DOT IDENTIFIER   						
					{ 
						// printf("   postfix_expression -> postfix_expression . IDENTIFIER\n"); 
					}
					| postfix_expression ARROW_OP IDENTIFIER    				
					{ 
						// printf("   postfix_expression -> postfix_expression -> IDENTIFIER\n"); 
					}
					| postfix_expression UNARY_INCREMENT_OP   					
					{ 
						// Generate a new temporary, equate it to old value of the expression and then add 1
						$$ = new A();	
						$$->_array = SymbolTable::gentemp($1->_array->_type); 	// Generate a temporary to store the old value
						QuadArray::emit("=", $$->_array->_name, $1->_array->_name);	// t1 = i
						QuadArray::emit("+", $1->_array->_name, $1->_array->_name, "1"); // i = i + 1
					}
					| postfix_expression UNARY_DECREMENT_OP   					
					{  
						// Generate a new temporary, equate it to old value of the expression and then subtract 1
						$$ = new A();	
						$$->_array = SymbolTable::gentemp($1->_array->_type);	// Generate a temporary to store the old value
						QuadArray::emit("=", $$->_array->_name, $1->_array->_name);	// t1 = i
						QuadArray::emit("-", $1->_array->_name, $1->_array->_name, "1");	// i = i - 1
					}
					| OPENING_ROUND_BRACKET type_name CLOSING_ROUND_BRACKET OPENING_CURLY_BRACKET initializer_list CLOSING_CURLY_BRACKET
					{ 
						// printf("   postfix_expression -> (type_name){initializer_list}\n"); 
					}
					| OPENING_ROUND_BRACKET type_name CLOSING_ROUND_BRACKET OPENING_CURLY_BRACKET initializer_list COMMA CLOSING_CURLY_BRACKET			
					{ 
						// printf("   postfix_expression -> (type_name){initializer_list,}\n"); 
					}
					;

argument_expression_list:  	assignment_expression  									
							{  
								$$ = 1; // argument list can have one argument
								QuadArray::emit("param", $1->_loc->_name); // Emit the parameter along with the argument name (Example: param a)
							}
							| argument_expression_list COMMA assignment_expression   
							{  
								$$ = $1 + 1; // argument list can have more than one argument
								QuadArray::emit("param", $3->_loc->_name); // Emit the parameter along  with the argument name (Example: param b)
							}
							;

argument_expression_list_opt:	argument_expression_list 
								{
									// If there is a argument list just equate it
									$$ = $1; // Just equate $$ and $1
								}
								| 
								{ 
									$$ = 0; // No arguments in the list
								}
								;

unary_expression:   postfix_expression    					
					{ 
						// Just equate the two expressions
						$$ = $1; 
					}
					| UNARY_INCREMENT_OP unary_expression  	
					{ 
						// Emit the TAC for pre-increment operation (Example: i = i+1)
						QuadArray::emit("+", $2->_array->_name, $2->_array->_name, "1");		
						$$ = $2;
					}
					| UNARY_DECREMENT_OP unary_expression  	
					{
						// Emit the TAC for pre-decrement operation (Example: i = i-1)
						QuadArray::emit("-", $2->_array->_name, $2->_array->_name, "1");		
						$$ = $2;
					}
					| unary_operator cast_expression 		
					{
						// Based on the type of unary operator, emit the correct TAC
						$$ = new A();
						switch($1)
						{	  
							case '&':	// Address Of Operator
								$$->_array = SymbolTable::gentemp(new SymbolType("ptr")); // Generate a temporary to store the pointer
								$$->_array->_type->_arrayType = $2->_array->_type; // Storing type of the element whose address is being obtained
								QuadArray::emit("=&", $$->_array->_name, $2->_array->_name); // Emit the quad (Example: t1 = &a )
								break;
								
							case '*':  // Inference Operator
								$$->_arrType = "ptr";	
								$$->_loc = SymbolTable::gentemp($2->_array->_type->_arrayType); // Generate a temporary to store the value of the corresponding type
								$$->_array = $2->_array;
								QuadArray::emit("=*", $$->_loc->_name, $2->_array->_name); // Emit the quad (Example: t1 = *a )
								break;
								
							case '+':  // Unary plus sign opertor
								$$ = $2; // Just equate the expressions
								break;    
								             
							case '-':	// Unary minus sign operator
								$$->_array = SymbolTable::gentemp(new SymbolType($2->_array->_type->_type)); // Generate a temporary to store the value of the corresponding base type
								QuadArray::emit("uminus", $$->_array->_name, $2->_array->_name); // Emit the quad (Example: t1 = uminus a )
								break;
								
							case '~': // Bitwise Not Operator
								$$->_array = SymbolTable::gentemp(new SymbolType($2->_array->_type->_type)); // Generate a temporary to store the value of the corresponding base type
								QuadArray::emit("~", $$->_array->_name, $2->_array->_name); // Emit the quad (Example: t1 = ~a )
								break;
								
							case '!': //Logical Not Operator
								$$->_array = SymbolTable::gentemp(new SymbolType($2->_array->_type->_type)); // Generate a temporary to store the value of the corresponding base type
								QuadArray::emit("!", $$->_array->_name, $2->_array->_name); // Emit the quad (Example: t1 = !a )
								break;
						} 
					}
					| SIZEOF unary_expression    			
					{ 
						$$ = new A();
						$$->_array = SymbolTable::gentemp(new SymbolType($2->_array->_type->_type)); // Generate a temporary to store the value of the corresponding base type
						QuadArray::emit("sizeof", $$->_array->_name, $2->_array->_name); // Emit the quad (Example: t1 = sizeof(a) )		
						// printf("   unary_expression -> sizeof unary_expression\n"); 
					}
					| SIZEOF OPENING_ROUND_BRACKET type_name CLOSING_ROUND_BRACKET			
					{ 
						$$ = new A();
						string p = to_string($3); // The integer constant is to be converted to string for emitting the TAC
						$$->_array = SymbolTable::gentemp(new SymbolType("int"), p); // Generate a temporary to store the value of the corresponding base type
						QuadArray::emit("=", $$->_array->_name, p); // Emit the quad (Example: t1 = sizeof(t) )
						// printf("   unary_expression -> sizeof(type_name)\n"); 
					}
					;

unary_operator: BITWISE_AND_OP	
				{ 
					// printf("   unary_operator -> &\n"); 
					$$ = '&';
				}
				| MULTIPLICATION_OP	
				{ 
					
					if (__return_type_is_ptr__ == -1)	__return_type_is_ptr__ = 1;	// '*' symbol might be indicative of a pointer return type of a function
					// printf("   unary_operator -> *\n"); 
					$$ = '*';
				}
				| ADDITION_OP 	
				{ 
					// printf("   unary_operator -> +\n"); 
					$$ = '+';
				}
				| SUBTRACTION_OP 	
				{ 
					// printf("   unary_operator -> -\n"); 
					$$ = '-';
				}
				| BITWISE_NOT_OP 	
				{ 
					// printf("   unary_operator -> ~\n"); 
					$$ = '~';
				}
				| LOGICAL_NOT_OP 	
				{ 
					// printf("   unary_operator -> !\n"); 
					$$ = '!';
				}
				;

cast_expression:    unary_expression
					{
						$$ = $1; // Just simply equate the expressions if not type for conversion is given
					}
					| OPENING_ROUND_BRACKET type_name CLOSING_ROUND_BRACKET cast_expression	
					{  
						// Convert the type of the expression to the given type
						$$ = new A();	
						$$->_array = typecast($4->_array, __variable_type__, 1); // "explicitly" convert type to the given type and store the casted value in $$	
					}
					;

multiplicative_expression:  cast_expression		
							{
								$$ = new E();	// Generate a new expression	
								
								// If the type of the expression is array then emit the value of A[loc]						    
								if($1->_arrType == "arr") 
								{
									$$->_loc = SymbolTable::gentemp($1->_loc->_type);	// Generate a temporary to store the array value
									QuadArray::emit("=[]", $$->_loc->_name, $1->_array->_name, $1->_loc->_name);	// Emit the quad (Example: t1 = A[loc])
								}
								else if($1->_arrType == "ptr")	// Else if the type of the expression is pointer then equate the locs
								{ 
									$$->_loc = $1->_loc;  // E.loc = p.loc
								}
								else
								{
									$$->_loc = $1->_array;
								} 
							}
							| multiplicative_expression MULTIPLICATION_OP cast_expression 
							{
								SymbolType * t1 = $1->_loc->_type ;
								SymbolType * t2 = $3->_loc->_type ;

								if ( t1->_type == t2->_type ) {	// simple case when the types are equal
									$$ = new E();	// Generate a new expression
									$$->_loc = SymbolTable::gentemp(new SymbolType($1->_loc->_type->_type)); // Generate a new temporary to store the product
									QuadArray::emit("*", $$->_loc->_name, $1->_loc->_name, $3->_loc->_name); // Emit the quad (Example: t1 = a * b)
								}

								else if ( t1->_type == "int" ) {
									if ( t2->_type == "char" ) {
										$$ = new E();	// Generate a new expression
										$$->_loc = SymbolTable::gentemp(new SymbolType("int")); // Generate a new temporary to store the product (type: int)
										QuadArray::emit("*", $$->_loc->_name, $1->_loc->_name, typecast($3->_loc, t1->_type)->_name); // Emit the quad (Example: t1 = a * char2int(b))
									}
									else if ( t2->_type == "float" ) {
										$$ = new E();	// Generate a new expression
										$$->_loc = SymbolTable::gentemp(new SymbolType("float")); // Generate a new temporary to store the product (type: float)
										QuadArray::emit("*", $$->_loc->_name, typecast($1->_loc, t2->_type)->_name, $3->_loc->_name); // Emit the quad (Example: t1 = int2float(a) * b)
									}
									else
										yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
								}

								else if ( t1->_type == "float" ) {
									if ( t2->_type == "char" || t2->_type == "int" ) {
										$$ = new E();	// Generate a new expression
										$$->_loc = SymbolTable::gentemp(new SymbolType("float")); // Generate a new temporary to store the product (type: float)
										QuadArray::emit("*", $$->_loc->_name, $1->_loc->_name, typecast($3->_loc, t1->_type)->_name); // Emit the quad (Example: t1 = a * char2float(b) or t1 = a * int2float(b))
									}
									else
										yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
								}

								else if ( t1->_type == "char" ) {
									if ( t2->_type == "int" || t2->_type == "float" )  {
										$$ = new E();	// Generate a new expression
										$$->_loc = SymbolTable::gentemp(new SymbolType(t2->_type)); // Generate a new temporary to store the product (type: int or float)
										QuadArray::emit("*", $$->_loc->_name, typecast($1->_loc, t2->_type)->_name, $3->_loc->_name); // Emit the quad (Example: t1 = char2float(a) * b or t1 = char2int(a) * b)
									}
									else
										yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
								}

								else
									yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
							}
							| multiplicative_expression DIVISION_OP cast_expression 
							{
								SymbolType * t1 = $1->_loc->_type ;
								SymbolType * t2 = $3->_loc->_type ;

								if ( t1->_type == t2->_type ) {	// simple case when the types are equal
									$$ = new E();	// Generate a new expression
									$$->_loc = SymbolTable::gentemp(new SymbolType($1->_loc->_type->_type)); // Generate a new temporary to store the quotient
									QuadArray::emit("/", $$->_loc->_name, $1->_loc->_name, $3->_loc->_name); // Emit the quad (Example: t1 = a / b)
								}

								else if ( t1->_type == "int" ) {
									if ( t2->_type == "char" ) {
										$$ = new E();	// Generate a new expression
										$$->_loc = SymbolTable::gentemp(new SymbolType("int")); // Generate a new temporary to store the quotient (type: int)
										QuadArray::emit("/", $$->_loc->_name, $1->_loc->_name, typecast($3->_loc, t1->_type)->_name); // Emit the quad (Example: t1 = a / char2int(b))
									}
									else if ( t2->_type == "float" ) {
										$$ = new E();	// Generate a new expression
										$$->_loc = SymbolTable::gentemp(new SymbolType("float")); // Generate a new temporary to store the quotient (type: float)
										QuadArray::emit("/", $$->_loc->_name, typecast($1->_loc, t2->_type)->_name, $3->_loc->_name); // Emit the quad (Example: t1 = int2float(a) * b)
									}
									else
										yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
								}

								else if ( t1->_type == "float" ) {
									if ( t2->_type == "char" || t2->_type == "int" ) {
										$$ = new E();	// Generate a new expression
										$$->_loc = SymbolTable::gentemp(new SymbolType("float")); // Generate a new temporary to store the quotient (type: float)
										QuadArray::emit("/", $$->_loc->_name, $1->_loc->_name, typecast($3->_loc, t1->_type)->_name); // Emit the quad (Example: t1 = a / char2float(b) or t1 = a / int2float(b))
									}
									else
										yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
								}

								else if ( t1->_type == "char" ) {
									if ( t2->_type == "int" || t2->_type == "float" )  {
										$$ = new E();	// Generate a new expression
										$$->_loc = SymbolTable::gentemp(new SymbolType(t2->_type)); // Generate a new temporary to store the quotient (type: int/float)
										QuadArray::emit("/", $$->_loc->_name, typecast($1->_loc, t2->_type)->_name, $3->_loc->_name); // Emit the quad (Example: t1 = char2float(a) / b or t1 = char2int(a) / b)
									}
									else
										yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
								}

								else
									yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
							}
							| multiplicative_expression MODULUS_OP cast_expression 
							{ 
								SymbolType * t1 = $1->_loc->_type ;
								SymbolType * t2 = $3->_loc->_type ;

								if ( t1->_type == "float" || t2->_type == "float" )	// modulus operator does not work if either of the operands is floating point
									yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Invalid floating-point operands for modulus (%) operation");

								if ( t1->_type == t2->_type ) {	// case when the types are equal
									if ( t1->_type == "char" ) {
										$$ = new E();	// Generate a new expression
										$$->_loc = SymbolTable::gentemp(new SymbolType("int")); // Generate a new temporary to store the remainder
										QuadArray::emit("%", $$->_loc->_name, typecast($1->_loc, "int")->_name, typecast($3->_loc, "int")->_name); // Emit the quad (Example: t1 = char2int(a) % char2int(b))
									}
									else {
										$$ = new E();	// Generate a new expression
										$$->_loc = SymbolTable::gentemp(new SymbolType($1->_loc->_type->_type)); // Generate a new temporary to store the remainder
										QuadArray::emit("%", $$->_loc->_name, $1->_loc->_name, $3->_loc->_name); // Emit the quad (Example: t1 = a % b)
									}
								}

								else if ( t1->_type == "int" ) {
									if ( t2->_type == "char" ) {
										$$ = new E();	// Generate a new expression
										$$->_loc = SymbolTable::gentemp(new SymbolType("int")); // Generate a new temporary to store the remainder
										QuadArray::emit("%", $$->_loc->_name, $1->_loc->_name, typecast($3->_loc, t1->_type)->_name); // Emit the quad (Example: t1 = a % char2int(b))
									}
									else
										yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
								}

								else if ( t1->_type == "char" ) {
									if ( t2->_type == "int" )  {
										$$ = new E();	// Generate a new expression
										$$->_loc = SymbolTable::gentemp(new SymbolType("int")); // Generate a new temporary to store the remainder
										QuadArray::emit("%", $$->_loc->_name, typecast($1->_loc, t2->_type)->_name, $3->_loc->_name); // Emit the quad (Example: t1 = char2int(a) % b)
									}
									else
										yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
								}

								else
									yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
							}
							;

additive_expression:	multiplicative_expression							
						{ 
							$$ = $1; // Just simply equate the expressions
						}
						| additive_expression ADDITION_OP multiplicative_expression 
						{
							SymbolType * t1 = $1->_loc->_type ;
    						SymbolType * t2 = $3->_loc->_type ;

							if ( t1->_type == t2->_type ) {
								$$ = new E();	// Generate a new expression
								$$->_loc = SymbolTable::gentemp(new SymbolType($1->_loc->_type->_type)); // Generate a new temporary to store the sum
								QuadArray::emit("+", $$->_loc->_name, $1->_loc->_name, $3->_loc->_name); // Emit the quad (Example: t1 = a + b)
							}

							else if ( t1->_type == "int" ) {
								if ( t2->_type == "char" ) {
									$$ = new E();	// Generate a new expression
									$$->_loc = SymbolTable::gentemp(new SymbolType("int")); // Generate a new temporary to store the sum (type: int)
									QuadArray::emit("+", $$->_loc->_name, $1->_loc->_name, typecast($3->_loc, t1->_type)->_name); // Emit the quad (Example: t1 = a + char2int(b))
								}
								else if ( t2->_type == "float" ) {
									$$ = new E();	// Generate a new expression
									$$->_loc = SymbolTable::gentemp(new SymbolType("float")); // Generate a new temporary to store the sum (type: float)
									QuadArray::emit("+", $$->_loc->_name, typecast($1->_loc, t2->_type)->_name, $3->_loc->_name); // Emit the quad (Example: t1 = int2float(a) + b)
								}
								else
									yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
							}

							else if ( t1->_type == "float" ) {
								if ( t2->_type == "char" || t2->_type == "int" ) {
									$$ = new E();	// Generate a new expression
									$$->_loc = SymbolTable::gentemp(new SymbolType("float")); // Generate a new temporary to store the sum (type: float)
									QuadArray::emit("+", $$->_loc->_name, $1->_loc->_name, typecast($3->_loc, t1->_type)->_name); // Emit the quad (Example: t1 = a + char2float(b) or t1 = t1 = a + int2float(b))
								}
								else
									yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
							}

							else if ( t1->_type == "char" ) {
								if ( t2->_type == "int" || t2->_type == "float" )  {
									$$ = new E();	// Generate a new expression
									$$->_loc = SymbolTable::gentemp(new SymbolType(t2->_type)); // Generate a new temporary to store the sum (type: int/float)
									QuadArray::emit("+", $$->_loc->_name, typecast($1->_loc, t2->_type)->_name, $3->_loc->_name); // Emit the quad (Example: t1 = char2int(a) + b or t1 = char2float(a) + b)
								}
								else
									yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
							}

							else
								yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
							
						}
						| additive_expression SUBTRACTION_OP multiplicative_expression 
						{
							SymbolType * t1 = $1->_loc->_type ;
    						SymbolType * t2 = $3->_loc->_type ;

							if ( t1->_type == t2->_type ) {
								$$ = new E();	// Generate a new expression
								$$->_loc = SymbolTable::gentemp(new SymbolType($1->_loc->_type->_type)); // Generate a new temporary to store the difference
								QuadArray::emit("-", $$->_loc->_name, $1->_loc->_name, $3->_loc->_name); // Emit the quad (Example: t1 = a - b)
							}

							else if ( t1->_type == "int" ) {
								if ( t2->_type == "char" ) {
									$$ = new E();	// Generate a new expression
									$$->_loc = SymbolTable::gentemp(new SymbolType("int")); // Generate a new temporary to store the difference (type: int)
									QuadArray::emit("-", $$->_loc->_name, $1->_loc->_name, typecast($3->_loc, t1->_type)->_name); // Emit the quad (Example: t1 = a - char2int(b))
								}
								else if ( t2->_type == "float" ) {
									$$ = new E();	// Generate a new expression
									$$->_loc = SymbolTable::gentemp(new SymbolType("float")); // Generate a new temporary to store the difference (type: float)
									QuadArray::emit("-", $$->_loc->_name, typecast($1->_loc, t2->_type)->_name, $3->_loc->_name); // Emit the quad (Example: t1 = int2float(a) - b)
								}
								else
									yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
							}

							else if ( t1->_type == "float" ) {
								if ( t2->_type == "char" || t2->_type == "int" ) {
									$$ = new E();	// Generate a new expression
									$$->_loc = SymbolTable::gentemp(new SymbolType("float")); // Generate a new temporary to store the difference (type: float)
									QuadArray::emit("-", $$->_loc->_name, $1->_loc->_name, typecast($3->_loc, t1->_type)->_name); // Emit the quad (Example: t1 = a - char2float(b) or t1 = t1 = a - int2float(b))
								}
								else
									yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
							}

							else if ( t1->_type == "char" ) {
								if ( t2->_type == "int" || t2->_type == "float" )  {
									$$ = new E();	// Generate a new expression
									$$->_loc = SymbolTable::gentemp(new SymbolType(t2->_type)); // Generate a new temporary to store the difference (type: int/float)
									QuadArray::emit("-", $$->_loc->_name, typecast($1->_loc, t2->_type)->_name, $3->_loc->_name); // Emit the quad (Example: t1 = char2int(a) - b or t1 = char2float(a) - b)
								}
								else
									yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
							}

							else
								yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
						}
						;

shift_expression:   additive_expression     									
					{
						$$ = $1; // Just simply equate the expressions
					}
					| shift_expression LEFT_SHIFT_OP additive_expression    	
					{ 
						// If the type of the additive expression is not int then produce an error
						if(!($3->_loc->_type->_type == "int"))
						{
							yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types"); 		
						}
						else // Shifting can be done only by an integer amount
						{		
							$$ = new E(); // Generate a new expression
							$$->_loc = SymbolTable::gentemp(new SymbolType("int")); // Generate a new temporary to store the shifted value
							QuadArray::emit("<<", $$->_loc->_name, $1->_loc->_name, $3->_loc->_name); // Emit the quad (Example: t1 = a << b)
						}
					}
					| shift_expression RIGHT_SHIFT_OP additive_expression 	
					{ 
						// If the type of the additive expression is not int then produce an error
						if(!($3->_loc->_type->_type == "int"))
						{
							yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types"); 	
						}	
						else // Shifting can be done only by an integer amount
						{		
							$$ = new E(); // Generate a new expression
							$$->_loc = SymbolTable::gentemp(new SymbolType("int")); // Generate a new temporary to store the shifted value
							QuadArray::emit(">>", $$->_loc->_name, $1->_loc->_name, $3->_loc->_name); // Emit the quad (Example: t1 = a >> b)
						}
					}
					;

relational_expression:	shift_expression	
						{
							$$ = $1; // Just simply equate the expressions
						}
						| relational_expression LESS_THAN_OP shift_expression	
						{
							// Compare the symbol types of both sides of the boolean operation
							if(!comparetype($1->_loc, $3->_loc)) 
							{
								// If types of the operands are not compatible then produce an error
								yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
							}
							else // If types are compatible, then emit the quads
							{  								
								$$ = new E();	// Generate a new expression
								$$->_type = "bool";	// The type of the expression is bool
								$$->_trueList = makelist(nextinstr());// Make the truelist of the expression containing next instruction
								$$->_falseList = makelist(nextinstr()+1);// Make the falselist of expression containing next instruction+1
								QuadArray::emit("<", "", $1->_loc->_name, $3->_loc->_name);	// Emit statement if a<b goto ... 
								QuadArray::emit("goto", "");	// Emit statement goto ...
							}
						}
						| relational_expression GREATER_THAN_OP shift_expression	
						{
							// Compare the symbol types of both sides of the boolean operation
							if(!comparetype($1->_loc, $3->_loc)) 
							{
								// If types of the operands are not compatible then produce an error
								yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
							}
							else // If types are compatible, then emit the quads
							{  								
								$$ = new E();	// Generate a new expression
								$$->_type = "bool";	// The type of the expression is bool
								$$->_trueList = makelist(nextinstr());// Make the truelist of the expression containing next instruction
								$$->_falseList = makelist(nextinstr()+1);// Make the falselist of expression containing next instruction+1
								QuadArray::emit(">", "", $1->_loc->_name, $3->_loc->_name);	// Emit statement if a>b goto ... 
								QuadArray::emit("goto", "");	// Emit statement goto ...
							}
						}
						| relational_expression LESS_THAN_EQUAL_OP shift_expression		
						{
							// Compare the symbol types of both sides of the boolean operation
							if(!comparetype($1->_loc, $3->_loc)) 
							{
								// If types of the operands are not compatible then produce an error
								yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
							}
							else // If types are compatible, then emit the quads
							{  								
								$$ = new E();	// Generate a new expression
								$$->_type = "bool";	// The type of the expression is bool
								$$->_trueList = makelist(nextinstr());// Make the truelist of the expression containing next instruction
								$$->_falseList = makelist(nextinstr()+1);// Make the falselist of expression containing next instruction+1
								QuadArray::emit("<=", "", $1->_loc->_name, $3->_loc->_name);	// Emit statement if a<=b goto ... 
								QuadArray::emit("goto", "");	// Emit statement goto ...
							} 
						}
						| relational_expression GREATER_THAN_EQUAL_OP shift_expression  
						{
							// Compare the symbol types of both sides of the boolean operation
							if(!comparetype($1->_loc, $3->_loc)) 
							{
								// If types of the operands are not compatible then produce an error
								yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
							}
							else // If types are compatible, then emit the quads
							{  								
								$$ = new E();	// Generate a new expression
								$$->_type = "bool";	// The type of the expression is bool
								$$->_trueList = makelist(nextinstr());// Make the truelist of the expression containing next instruction
								$$->_falseList = makelist(nextinstr()+1);// Make the falselist of expression containing next instruction+1
								QuadArray::emit(">=", "", $1->_loc->_name, $3->_loc->_name);	// Emit statement if a>=b goto ... 
								QuadArray::emit("goto", "");	// Emit statement goto ...
							} 
						}
						; 

equality_expression:	relational_expression	
						{ 
							$$ = $1; // Just simply equate the expressions
						}
						| equality_expression EQUALITY_OP relational_expression		
						{
							// Compare the symbol types of both sides of the boolean operation
							if(!comparetype($1->_loc, $3->_loc))
							{
								// If types of the operands are not compatible then produce an error
								yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
							}
							else 
							{
								convBool2Int($1);   // Convert bool to int for comparsion		
								convBool2Int($3);	// Convert bool to int for comparsion
								$$ = new E();	// Generate the new expression
								$$->_type = "bool";		// The type of the expression is bool
								$$->_trueList = makelist(nextinstr());// Make the truelist of the expression containing next instruction
								$$->_falseList = makelist(nextinstr()+1);// Make the falselist of expression containing next instruction+1
								QuadArray::emit("==", "", $1->_loc->_name, $3->_loc->_name);	// Emit statement if a==b goto ... 
								QuadArray::emit("goto", "");	// Emit statement goto ...
							}
						}
						| equality_expression INEQUALITY_OP relational_expression	
						{
							// Compare the symbol types of both sides of the boolean operation
							if(!comparetype($1->_loc, $3->_loc))
							{
								// If types of the operands are not compatible then produce an error
								yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
							}
							else 
							{
								convBool2Int($1);   // Convert bool to int for comparsion		
								convBool2Int($3);	// Convert bool to int for comparsion
								$$ = new E();	// Generate the new expression
								$$->_type = "bool";		// The type of the expression is bool
								$$->_trueList = makelist(nextinstr());// Make the truelist of the expression containing next instruction
								$$->_falseList = makelist(nextinstr()+1);// Make the falselist of expression containing next instruction+1
								QuadArray::emit("!=", "", $1->_loc->_name, $3->_loc->_name);	// Emit statement if a!=b goto ... 
								QuadArray::emit("goto", "");	// Emit statement goto ...
							}
						}
						;

AND_expression:	equality_expression		
				{
					$$ = $1; // Just simply equate the expressions
				}
                | AND_expression BITWISE_AND_OP equality_expression	
                {
                	// Compare the symbol types of both sides of the bitwise and operation
					if(!comparetype($1->_loc, $3->_loc))
					{
						// If types of the operands are not compatible then produce an error
						yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
					}
					else 
					{
						convBool2Int($1);   // Convert bool to int for bitwise operation
						convBool2Int($3);	// Convert bool to int for bitwise operation
						$$ = new E();	// Generate the new expression
						$$->_type = "not-boolean";	// The type of the expression is not boolean
						$$->_loc = SymbolTable::gentemp(new SymbolType("int")); // Set the type of the expression
						QuadArray::emit("&", $$->_loc->_name, $1->_loc->_name, $3->_loc->_name);	// Emit statement t1 = a&b 
					}
                }
                ;

exclusive_OR_expression:	AND_expression		
							{ 
								$$ = $1; // Just simply equate the expressions
							} 
							| exclusive_OR_expression BITWISE_XOR_OP AND_expression	
							{
								// Compare the symbol types of both sides of the bitwise xor operation
								if(!comparetype($1->_loc, $3->_loc))
								{
									// If types of the operands are not compatible then produce an error
									yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
								}
								else 
								{
									convBool2Int($1);   // Convert bool to int for bitwise operation
									convBool2Int($3);	// Convert bool to int for bitwise operation
									$$ = new E();	// Generate the new expression
									$$->_type = "not-boolean";	// The type of the expression is not boolean
									$$->_loc = SymbolTable::gentemp(new SymbolType("int")); // Set the type of the expression
									QuadArray::emit("^", $$->_loc->_name, $1->_loc->_name, $3->_loc->_name);	// Emit statement t1 = a^b 
								}
							}
							;

inclusive_OR_expression:	exclusive_OR_expression		
							{
								$$ = $1; // Just simply equate the expressions
							}
							| inclusive_OR_expression BITWISE_OR_OP exclusive_OR_expression	
							{
								// Compare the symbol types of both sides of the bitwise or operation
								if(!comparetype($1->_loc, $3->_loc))
								{
									// If types of the operands are not compatible then produce an error
									yyerror(" TYPE ERROR [ ass5_19CS10044_19CS30053.y ] - Incompatibility/invalidity of types");
								}
								else 
								{
									convBool2Int($1);   // Convert bool to int for bitwise operation
									convBool2Int($3);	// Convert bool to int for bitwise operation
									$$ = new E();	// Generate the new expression
									$$->_type = "not-boolean";	// The type of the expression is not boolean
									$$->_loc = SymbolTable::gentemp(new SymbolType("int")); // Set the type of the expression
									QuadArray::emit("|", $$->_loc->_name, $1->_loc->_name, $3->_loc->_name);	// Emit statement t1 = a|b 
								}
							} 
							;

logical_AND_expression:		inclusive_OR_expression		
							{
								$$ = $1; // Just simply equate the expressions
							} 
							| logical_AND_expression LOGICAL_AND_OP M inclusive_OR_expression		
							{ 
								convInt2Bool($4);	// Convert inclusive_or_expression from int to bool	
								convInt2Bool($1);	// Convert logical_and_expression to bool
								$$ = new E();  // Generate the new expression
								$$->_type = "bool";	// The type of the expression is bool
								backpatch($1->_trueList, $3);	// if $1 is true, we move to $3
								$$->_trueList = $4->_trueList;	// Truelist of the whole expression is truelist of $4
								$$->_falseList = merge($1->_falseList, $4->_falseList);   // Falselist of the whole expression is combination of falselists of $1 and $4
							} 
							;

logical_OR_expression:     	logical_AND_expression		
							{
								$$ = $1; // Just simply equate the expressions 
							}
							| logical_OR_expression LOGICAL_OR_OP M logical_AND_expression	
							{ 
								convInt2Bool($4);	// Convert inclusive_or_expression from int to bool	
								convInt2Bool($1);	// Convert logical_and_expression to bool
								$$ = new E();  // Generate the new expression
								$$->_type = "bool";	// The type of the expression is bool
								backpatch($1->_falseList, $3);	// if $1 is false, we move to $3
								$$->_trueList = merge($1->_trueList, $4->_trueList);	// Truelist of the whole expression is combination of truelists of $1 and $4
								$$->_falseList = $4->_falseList;	// Falselist of the whole expression is falselist of $4
							} 
							;

conditional_expression:		logical_OR_expression		
							{ 
								$$ = $1; // Just simply equate the expressions 
							}
							| logical_OR_expression N QUESTION_MARK M expression N COLON M conditional_expression	
							{ 
								// Normal conversion method to get conditional expressions
								$$->_loc = SymbolTable::gentemp($5->_loc->_type);		// Generate temporary for expression
								$$->_loc->updateType($5->_loc->_type);	
								QuadArray::emit("=", $$->_loc->_name, $9->_loc->_name);// Intially let the $$ be equal to conditional expression (Example: t1 = b)
								vector<int> l = makelist(nextinstr());	// Make a new list containing the next instruction
								QuadArray::emit("goto", "");              			// Prevent fallthrough
								backpatch($6->_nextList, nextinstr());  	// After N, go to next instruction
								QuadArray::emit("=", $$->_loc->_name, $5->_loc->_name);// If logical_OR_expression is true then $$ is equal to expression (Example: t1 = a)
								vector<int> m = makelist(nextinstr());    // Make a new list containing the next instruction
								l = merge(l, m);						// Merge the two lists
								QuadArray::emit("goto", "");						// Prevent fallthrough
								backpatch($2->_nextList, nextinstr());   // Back-patching
								convInt2Bool($1);                   // Convert logical_OR_expression to bool
								backpatch($1->_trueList, $4);            // If $1 is true go to expression
								backpatch($1->_falseList, $8);           // If $1 is false go to conditional_expression
								backpatch(l, nextinstr());
							}
							;

assignment_expression:		conditional_expression		
							{
								$$ = $1; // Just simply equate the expressions  
							}
							| unary_expression assignment_operator assignment_expression	
							{
								// If the type of the unary_expression is an array then convert the type of assignment_expression to make it compatible
								if($1->_arrType == "arr")
								{
									$3->_loc = typecast($3->_loc, $1->_type->_type); // Convert the type to make it compatible
									QuadArray::emit("[]=", $1->_array->_name, $1->_loc->_name, $3->_loc->_name); // Emit the quad (Example: A[loc] = a)
								}
								else if($1->_arrType == "ptr")	// If type of unary_expression is pointer
								{
									QuadArray::emit("*=", $1->_array->_name, $3->_loc->_name);	// Emit the quad (Example: *A = a)
								}
								else // If it is simply an assignment statement
								{
									$3->_loc = typecast($3->_loc, $1->_array->_type->_type); // Convert the type to make it compatible
									QuadArray::emit("=", $1->_array->_name, $3->_loc->_name); // Emit the quad (Example: a = b)
								}
								$$ = $3;
							}
							;

assignment_operator:	ASSIGNMENT_OP 				{ /* printf("   assignment_operator -> =\n"); */ }
						| MULT_ASSIGN_OP 			{ /* printf("   assignment_operator -> *=\n"); */ }
						| DIV_ASSIGN_OP 			{ /* printf("   assignment_operator -> /=\n"); */ }
						| MOD_ASSIGN_OP 			{ /* printf("   assignment_operator -> %c=\n", '%'); */ }
						| ADD_ASSIGN_OP				{ /* printf("   assignment_operator -> +=\n"); */ } 
						| SUB_ASSIGN_OP 			{ /* printf("   assignment_operator -> -=\n"); */ }
				        | LSHIFT_ASSIGN_OP 			{ /* printf("   assignment_operator -> <<=\n"); */ }
						| RSHIFT_ASSIGN_OP 			{ /* printf("   assignment_operator -> >>=\n"); */ }
						| BITWISE_AND_ASSIGN_OP 	{ /* printf("   assignment_operator -> &=\n"); */ }
						| BITWISE_XOR_ASSIGN_OP 	{ /* printf("   assignment_operator -> ^=\n"); */ }
						| BITWISE_OR_ASSIGN_OP 		{ /* printf("   assignment_operator -> |=\n"); */ }
				        ;

expression:	assignment_expression	
			{
				$$ = $1; // Just simply equate the expressions  
			}
			| expression COMMA assignment_expression    
			{ 
				// printf("   expression -> expression, assignment_expression\n"); 
			}
			;

constant_expression:	conditional_expression	
						{ 
							// printf("   constant_expression -> conditional_expression\n"); 
						} 
						;

// SECTION : DECLARATIONS

declaration:	declaration_specifiers init_declarator_list_opt SEMICOLON	
				{ 
					// printf("   declaration -> declaration_specifiers init_declarator_list_opt ;\n"); 
				}
		   	 	;

init_declarator_list_opt: 	init_declarator_list	
							{ 
								// printf("   init_declarator_list_opt -> init_declarator_list\n"); 
							}
							|  /* epsilon */
							;

declaration_specifiers:		storage_class_specifier declaration_specifiers_opt	
							{ 
								// printf("   declaration_specifiers -> storage_class_specifier declaration_specifiers_opt\n"); 
							}
						  	| type_specifier declaration_specifiers_opt			
						  	{ 
						  		// printf("   declaration_specifiers -> type_specifier declaration_specifiers_opt\n"); 
						  	}
						  	| type_qualifier declaration_specifiers_opt			
						  	{ 
						  		// printf("   declaration_specifiers -> type_qualifier declaration_specifiers_opt\n"); 
						  	}
						  	| function_specifier declaration_specifiers_opt		
						  	{ 
						  		// printf("   declaration_specifiers -> function_specifier declaration_specifiers_opt\n"); 
						  	}
						  	;

declaration_specifiers_opt:	declaration_specifiers	
							{ 
								// printf("   declaration_specifiers_opt -> declaration_specifiers\n"); 
							}
							|  /* epsilon */
							;

init_declarator_list: 	init_declarator								
						{ 
							// printf("   init_declarator_list -> init_declarator\n"); 
						}
						| init_declarator_list COMMA init_declarator	
						{ 
							// printf("   init_declarator_list -> init_declarator_list, init_declarator\n"); 
						}
						;

init_declarator: 	declarator						
					{
						$$ = $1; // Just simply equate the expressions  
					}
			   		| declarator ASSIGNMENT_OP initializer    
			   		{
			   			// If the initializer is not empty then get the initial value and store it in $1
			   			if($3->_initVal != "") 
			   				$1->_initVal = $3->_initVal;  
						QuadArray::emit("=", $1->_name, $3->_name);	// Emit the quad (Example: a = b)
			   		}
			   		;

storage_class_specifier:	EXTERN		{ /* printf("   storage_class_specifier -> EXTERN\n"); */ }
							| STATIC	{ /* printf("   storage_class_specifier -> STATIC\n"); */ }
							| AUTO		{ /* printf("   storage_class_specifier -> AUTO\n"); */ }
							| REGISTER	{ /* printf("   storage_class_specifier -> REGISTER\n"); */ }
					   		;

// Store the latest type in __variable_type__
type_specifier:		VOID				{ /* printf("   type_specifier -> VOID\n"); */ $$ = $1; __variable_type__ = "void"; __return_type_is_ptr__ = -1; } // reset __return_type_is_ptr__ to -1
					| CHAR				{ /* printf("   type_specifier -> CHAR\n"); */ $$ = $1; __variable_type__ = "char"; __return_type_is_ptr__ = -1; } // reset __return_type_is_ptr__ to -1
					| SHORT				{ /* printf("   type_specifier -> SHORT\n"); */ }
					| INT				{ /* printf("   type_specifier -> INT\n"); */ $$ = $1; __variable_type__ = "int"; __return_type_is_ptr__ = -1; } // reset __return_type_is_ptr__ to -1
					| LONG				{ /* printf("   type_specifier -> LONG\n"); */ }
					| FLOAT				{ /* printf("   type_specifier -> FLOAT\n"); */ $$ = $1; __variable_type__ = "float"; __return_type_is_ptr__ = -1; } // reset __return_type_is_ptr__ to -1
					| DOUBLE			{ /* printf("   type_specifier -> DOUBLE\n"); */ }
					| SIGNED			{ /* printf("   type_specifier -> SIGNED\n"); */ }
					| UNSIGNED			{ /* printf("   type_specifier -> UNSIGNED\n"); */ }
					| _BOOL				{ /* printf("   type_specifier -> _BOOL\n"); */ }
					| _COMPLEX			{ /* printf("   type_specifier -> _COMPLEX\n"); */ }
					| _IMAGINARY		{ /* printf("   type_specifier -> _IMAGINARY\n"); */ }
			  		| enum_specifier	{ /* printf("   type_specifier -> enum_specifier\n"); */ }
			  		;

enum_specifier: 	ENUM identifier_opt OPENING_CURLY_BRACKET enumerator_list CLOSING_CURLY_BRACKET			
					{ 
						// printf("   enum_specifier -> ENUM identifier_opt { enumerator_list }\n"); 
					}
			  		| ENUM identifier_opt OPENING_CURLY_BRACKET enumerator_list COMMA CLOSING_CURLY_BRACKET	
			  		{ 
			  			// printf("   enum_specifier -> ENUM identifier_opt { enumerator_list , }\n"); 
			  		}
			  		| ENUM IDENTIFIER									
			  		{ 
			  			// printf("   enum_specifier -> ENUM IDENTIFIER\n"); 
			  		}
			  		;

identifier_opt: 	IDENTIFIER	
					|  /* epsilon */;

enumerator_list: 	enumerator							
					{ 
						// printf("   enumerator_list -> enumerator\n"); 
					}
			   		| enumerator_list COMMA enumerator	
			   		{ 
			   			// printf("   enumerator_list -> enumerator_list , enumerator\n"); 
			   		}
			   		;

enumerator: 	IDENTIFIER		
				{ 
					// printf("   enumerator -> IDENTIFIER\n"); 
				}
		  		| IDENTIFIER ASSIGNMENT_OP constant_expression	
		  		{ 
		  			// printf("   enumerator -> IDENTIFIER = constant_expression\n"); 
		  		}
		  		;

specifier_qualifier_list: 	type_specifier specifier_qualifier_list_opt		
							{ 
								$$ = $1;
								// printf("   specifier_qualifier_list -> type_specifier specifier_qualifier_list_opt\n"); 
							}
							| type_qualifier specifier_qualifier_list_opt	
							{ 
								$$ = $2;
								// printf("   specifier_qualifier_list -> type_qualifier specifier_qualifier_list_opt\n"); 
							}
							;

specifier_qualifier_list_opt: 	specifier_qualifier_list	
								{
									$$ = $1;
									// printf("   specifier_qualifier_list_opt -> specifier_qualifier_list\n"); 
								}
								|  { $$ = 0; } /* epsilon */
								;

type_qualifier:	CONST		{ /* printf("   type_qualifier -> CONST\n"); */ }
				| RESTRICT	{ /* printf("   type_qualifier -> RESTRICT\n"); */ }
				| VOLATILE	{ /* printf("   type_qualifier -> VOLATILE\n"); */ }
				;

function_specifier:	INLINE	{ /* printf("   function_specifier -> INLINE\n"); */ } 
					;

declarator:	pointer direct_declarator	
			{
				$$ = $2;
				if ($2->_isFunction == 0) {	// if direct_declarator is a function then no modifications are needed
					SymbolType *t = $1;	// Note the type of pointer
					while(t->_arrayType != NULL)
					{
						t = t->_arrayType;           // For multi-dimensional arrays, move till the base type of the array
					}
					t->_arrayType = $2->_type;        // Add the base type 
					$$ = $2->updateType($1);	// Update the Symbol table with type information
				}
			}
			| direct_declarator 
			{ 
				/* printf("   declarator -> direct_declarator\n"); */ 
			}
			;

direct_declarator:	IDENTIFIER				
					{ 
						$$ = $1->updateType(new SymbolType(__variable_type__)); // Update the type of the identifier with the latest encountered type
						__current_symbol__ = $$;	
					}
					| OPENING_ROUND_BRACKET declarator CLOSING_ROUND_BRACKET	
					{ 
						$$ = $2; // Just simply equate the expressions  
					}
					| direct_declarator OPENING_SQUARE_BRACKET type_qualifier_list assignment_expression CLOSING_SQUARE_BRACKET		
					{ 
						// printf("   direct_declarator -> direct_declarator [ type_qualifier_list assignment_expression ]\n"); 
					}
					| direct_declarator OPENING_SQUARE_BRACKET type_qualifier_list CLOSING_SQUARE_BRACKET		
					{ 
						// printf("   direct_declarator -> direct_declarator [ type_qualifier_list ]\n"); 
					}
					| direct_declarator OPENING_SQUARE_BRACKET assignment_expression CLOSING_SQUARE_BRACKET		
					{ 
						SymbolType *t = $1->_type; // Note the type of symbol
						SymbolType *prev = NULL;
						while(t->_type == "arr") 
						{
							prev = t;	
							t = t->_arrayType;	// For multi-dimensional arrays, go down till the base type
						}
						
						// If prev is NULL
						int temp = atoi($3->_loc->_initVal.c_str());	// Get initial value
						if(prev == NULL) 
						{
							
							SymbolType* s = new SymbolType("arr", $1->_type, temp);	// Create new symbol with that initial value
							$$ = $1->updateType(s);   // Update the symbol table with type information
						}
						else 
						{
							prev->_arrayType =  new SymbolType("arr", t, temp); // Create new symbol with that initial value
							$$ = $1->updateType($1->_type); // Update the symbol table with type information
						}
					}
					| direct_declarator OPENING_SQUARE_BRACKET CLOSING_SQUARE_BRACKET		
					{ 
						SymbolType *t = $1->_type;
						SymbolType *prev = NULL;
						while(t->_type == "arr") 
						{
							prev = t;	
							t = t->_arrayType;         // For multi-dimensional arrays, go down till the base type
						}
						
						if(prev == NULL) 
						{
							SymbolType* s = new SymbolType("arr", $1->_type, 0);    // No initial values, simply keep 0
							$$ = $1->updateType(s);	// Update the symbol table with type information
						}
						else 
						{
							prev->_arrayType =  new SymbolType("arr", t, 0); // No initial values, simply keep 0
							$$ = $1->updateType($1->_type);	// Update the symbol table with type information
						}
					}
					| direct_declarator OPENING_SQUARE_BRACKET STATIC type_qualifier_list assignment_expression CLOSING_SQUARE_BRACKET	
					{ 
						// printf("   direct_declarator -> direct_declarator [ STATIC type_qualifier_list_opt assignment_expression ]\n"); 
					}
					| direct_declarator OPENING_SQUARE_BRACKET STATIC assignment_expression CLOSING_SQUARE_BRACKET	
					{ 
						// printf("   direct_declarator -> direct_declarator [ STATIC type_qualifier_list_opt assignment_expression ]\n"); 
					}
					| direct_declarator OPENING_SQUARE_BRACKET type_qualifier_list MULTIPLICATION_OP CLOSING_SQUARE_BRACKET					
					{ 
						// printf("   direct_declarator -> direct_declarator [ type_qualifier_list * ]\n"); 
					}
					| direct_declarator OPENING_SQUARE_BRACKET MULTIPLICATION_OP CLOSING_SQUARE_BRACKET					
					{ 
						// printf("   direct_declarator -> direct_declarator [ * ]\n"); 
					}
					| direct_declarator OPENING_ROUND_BRACKET change_table parameter_type_list CLOSING_ROUND_BRACKET							
					{ 
						__current_ST__->_name = $1->_name;					// The name of the symbol table is the name of the direct_declarator

						if($1->_type->_type != "void") 			// If the return type of the direct_declarator is void
						{
							Symbol *s = __current_ST__->lookup("return"); 		// Lookup the symbol table for return value
							if (__return_type_is_ptr__ == 1) {
								s->updateType(new SymbolType("ptr", $1->_type->copy(), 4));	// pointer to a variable of type '$1->_type->_type'
																					// update with the pointer type, all pointers have size 4
							}
							else
								s->updateType($1->_type->copy()); 				// Update the type of the return value in the symbol table
							s->_isFunction = s->_type->_isFunction = 0;
							$1->_retType = s->_type;	// set the return-type of direct_declarator
						}

						else if (__return_type_is_ptr__ == 1) {
							Symbol *s = __current_ST__->lookup("return"); 		// Lookup the symbol table for return value
							s->updateType(new SymbolType("ptr", $1->_type->copy(), 4));	// Update the type "void*" of the return value in the symbol table
							s->_isFunction = s->_type->_isFunction = 0;
							$1->_retType = s->_type;	// set the return-type of direct_declarator
						}

						else
							$1->_retType = new SymbolType("void", NULL, 0);	// set the return-type of direct_declarator
							
						
						__return_type_is_ptr__ = -1 ;	// reset __return_type_is_ptr__ to -1

						$1->_isFunction = 1;		// direct_declarator symbol is a function
						$1->_type->_isFunction = 1;	// direct_declarator is of type function
						$1->_type->_type = "func";
						$1->_size = 0;	// function definitions are of 0 width
						$1->_nested = __current_ST__;

						__current_ST__->_parent = __global_ST__;		// Set the parent of the symbol table as the global symbol table
						__global_ST__->switchCurrentST();
						__current_symbol__ = $$;
					}
					| direct_declarator OPENING_ROUND_BRACKET identifier_list CLOSING_ROUND_BRACKET							
					{ 
						// printf("   direct_declarator -> direct_declarator ( identifier_list )\n"); 
					}
					| direct_declarator OPENING_ROUND_BRACKET change_table CLOSING_ROUND_BRACKET							
					{ 
						__current_ST__->_name = $1->_name;					// The name of the symbol table is the name of the direct_declarator

						if($1->_type->_type != "void") 			// If the return type of the direct_declarator is void
						{
							Symbol *s = __current_ST__->lookup("return"); 		// Lookup the symbol table for return value
							if (__return_type_is_ptr__ == 1) {
								s->updateType(new SymbolType("ptr", $1->_type->copy(), 4));	// pointer to a variable of type '$1->_type->_type'
																					// update with the pointer type, all pointers have size 4
							}
							else
								s->updateType($1->_type->copy()); 				// Update the type of the return value in the symbol table
							s->_isFunction = s->_type->_isFunction = 0 ;
							$1->_retType = s->_type;	// set the return-type of direct_declarator
						}

						else if (__return_type_is_ptr__ == 1) {
							Symbol *s = __current_ST__->lookup("return"); 		// Lookup the symbol table for return value
							s->updateType(new SymbolType("ptr", $1->_type->copy(), 4));	// Update the type "void*" of the return value in the symbol table
							s->_isFunction = s->_type->_isFunction = 0 ;
							$1->_retType = s->_type;	// set the return-type of direct_declarator
						}

						else
							$1->_retType = new SymbolType("void", NULL, 0);	// set the return-type of direct_declarator

						$1->_isFunction = 1;		// direct_declarator symbol is a function
						$1->_type->_isFunction = 1;	// direct_declarator is of type function
						$1->_type->_type = "func";
						$1->_size = 0;	// function definitions are of 0 width
						$1->_nested = __current_ST__;

						__current_ST__->_parent = __global_ST__;		// Set the parent of the symbol table as the global symbol table
						__global_ST__->switchCurrentST();
						__current_symbol__ = $$;				
					}
					;

type_qualifier_list_opt: 	type_qualifier_list		
							{ /* printf("   type_qualifier_list_opt -> type_qualifier_list\n"); */ }
					   		|  /* epsilon */ {	}
					   		;

pointer:	MULTIPLICATION_OP type_qualifier_list_opt				
			{
				if (__return_type_is_ptr__ == -1)	__return_type_is_ptr__ = 1;	// '*' symbol might be indicative of a pointer return type of a function
				$$ = new SymbolType("ptr");   // Create new symbol of type pointer
			}
	   		| MULTIPLICATION_OP type_qualifier_list_opt pointer	
	   		{
				if (__return_type_is_ptr__ == -1)	__return_type_is_ptr__ = 1;	// '*' symbol might be indicative of a pointer return type of a function
	   			$$ = new SymbolType("ptr", $3); // Create new symbol of type pointer 
	   		}
	   		;

type_qualifier_list:	type_qualifier							
						{ /* printf("   type_qualifier_list -> type_qualifier\n"); */ }
				   		| type_qualifier_list type_qualifier	
				   		{ /* printf("   type_qualifier_list -> type_qualifier_list type_qualifier\n"); */ }
				   		;

parameter_type_list: 	parameter_list					
						{ /* printf("   parameter_type_list -> parameter_list\n"); */ }
				   		| parameter_list COMMA ELLIPSIS	
				   		{ /* printf("   parameter_type_list -> parameter_list , ELLIPSIS\n"); */ }
				   		;

parameter_list: 	parameter_declaration						
					{ /* printf("   parameter_list -> parameter_declaration\n"); */ }
			  		| parameter_list COMMA parameter_declaration	
			  		{ /* printf("   parameter_list -> parameter_list , parameter_declaration\n"); */ }
			  		;

parameter_declaration: 		declaration_specifiers declarator	
							{ /* printf("   parameter_declaration -> declaration_specifiers declarator\n"); */ }
					 		| declaration_specifiers			
					 		{ /* printf("   parameter_declaration -> declaration_specifiers\n"); */ }
					 		;

identifier_list: 	IDENTIFIER							
					{ /* printf("   identifier_list -> IDENTIFIER\n"); */ }
			   		| identifier_list COMMA IDENTIFIER	
			   		{ /* printf("   identifier_list -> identifier_list , IDENTIFIER\n"); */ }
			   		;

type_name: 	specifier_qualifier_list	
			{ $$ = $1;
			 /* printf("   type_name -> specifier_qualifier_list\n"); */ }
		 	;

initializer: 	assignment_expression			
				{ 
					// printf("   initializer -> assignment_expression\n"); 
					$$ = $1->_loc; // Assignment operation 
				}
		   		| OPENING_CURLY_BRACKET initializer_list CLOSING_CURLY_BRACKET 
		   		{ /* printf("   initializer -> { initializer_list }\n"); */ }
		   		| OPENING_CURLY_BRACKET initializer_list COMMA CLOSING_CURLY_BRACKET	
		   		{ /* printf("   initializer -> { initializer_list , }\n"); */ }
		   		;

initializer_list: 	designation_opt initializer							
					{ /* printf("   initializer_list -> designation_opt initializer\n"); */ }
					| initializer_list COMMA designation_opt initializer	
					{ /* printf("   initializer_list -> initializer_list , designation_opt initializer\n"); */ }
					;

designation_opt:    designation 	
					{ /* printf("   designation_opt -> designation\n"); */ }
					|  /* epsilon */
					;

designation: 	designator_list ASSIGNMENT_OP		
				{ /* printf("   designation -> designator_list =\n"); */ }
		   		;

designator_list: 	designator						
					{ /* printf("   designator_list -> designator\n"); */ }
			   		| designator_list designator	
			   		{ /* printf("   designator_list -> designator_list designator\n"); */ }
			   		;

designator: 	OPENING_SQUARE_BRACKET constant_expression CLOSING_SQUARE_BRACKET	
				{ /* printf("   designator -> [ constant_expression ]\n"); */ }
		  		| DOT IDENTIFIER	
		  		{ /* printf("   designator -> . IDENTIFIER\n"); */ }
		  		;

// SECTION : STATEMENTS

statement: 	labeled_statement		
			{ /* printf("   statement -> labeled_statement\n"); */ }
		 	| compound_statement	
		 	{ 
		 		$$ = $1; // Just simply equate the statements  
		 	}
		 	| expression_statement	
		 	{ 
		 		$$ = new S();			// Create new statement
				$$->_nextList = $1->_nextList; 	// nextlist of the statement is the same as the nextlist of the expression_statement
		 	}
		 	| selection_statement	
		 	{ 
		 		$$ = $1; // Just simply equate the statements  
		 	}
		 	| iteration_statement	
		 	{ 
		 		$$ = $1; // Just simply equate the statements  
		 	}
		 	| jump_statement		
		 	{ 
		 		$$ = $1; // Just simply equate the statements  
		 	}
		 	;
		 	
// loop_body_statement - Statements inside the looping blocks
loop_body_statement: labeled_statement   {  }
				| expression_statement   
				{ 
					$$ = new S();			// Create new statement
					$$->_nextList = $1->_nextList; 	// nextlist of the statement is the same as the nextlist of the expression_statement
				}
				| selection_statement   
				{ 
					$$ = $1; // Just simply equate the statements 
				}
				| iteration_statement   
				{ 
					$$ = $1; // Just simply equate the statements 
				}
				| jump_statement   
				{ 
					$$ = $1; // Just simply equate the statements
				}
				;

labeled_statement: 	IDENTIFIER COLON M statement					
					{ 
						$$ = $4;	// Equate the labeled_statement to statement 
						Label *s = Label::lookup($1->_name); // The name of the label is the identifier
						if(s != nullptr)						// If the label is found in the label table
						{
							s->_quadArrIndex = $3; 						// The address referred to by the label is referred to by the marker
							backpatch(s->_nextList, s->_quadArrIndex); 	// Backpatch the nextlist of the label with the address
						}	
						else									// If the label is not found in the label table
						{
							s = new Label($1->_name);			// Create a new Label with the identifier as its name
							s->_quadArrIndex = nextinstr();				// The address referred to by the label is the next instruction
							s->_nextList = makelist($3);			// The nextlist of the label contains the statement referred by the marker
							__labels__.push_back(*s);			// Update the label table
						}
					}
				 	| CASE constant_expression COLON statement	
				 	{ /*printf("   labeled_statement -> CASE constant_expression : statement\n"); */ }
				 	| DEFAULT COLON statement	
				 	{ /*printf("   labeled_statement -> DEFAULT : statement\n"); */ }
				 	;

compound_statement:	OPENING_CURLY_BRACKET CT change_table block_item_list_opt CLOSING_CURLY_BRACKET	
					{ 
						$$ = $4; 					// Equate the compound_statement to the block_item_list_opt 
						__current_ST__->_parent->switchCurrentST(); 	// Change table as we are entering a new block
					}
					;

block_item_list: 	block_item						
					{ 
						$$ = $1;	// The block contains only one item, so simply equate them
					}
			   		| block_item_list M block_item	
			   		{ 
			   			$$ = $3;						// Block_Item_List is referred to by the block item
						backpatch($1->_nextList, $2);    // After $1, we move to block_item via $2
			   		}
			   		;

block_item_list_opt: 	block_item_list 
						{ 
							$$ = $1; // Simply equate them 
						}
						|   
						{ 
							$$ = new S(); // Create new statement
						}
						;
			
block_item: 	declaration		
				{
					$$ = new S();	// Create new statement
				}
		  		| statement		
		  		{ 
		  			$$ = $1;	// Simply equate them 
		  		}
		  		;

expression_statement: 	expression SEMICOLON	
						{ 
							$$ = $1;	// Simply equate them 
						}
						| SEMICOLON	
						{ 
							$$ = new E(); 	// Create new expression
						}
						;

selection_statement: 	IF OPENING_ROUND_BRACKET expression N CLOSING_ROUND_BRACKET M statement	N %prec "then"				
						{ 
							// if statement without else
							backpatch($4->_nextList, nextinstr()); 	// Nextlist of N is backpatched to nextinstr
							convInt2Bool($3);    // Convert expression to boolean which has additional attributes truelist and falselist
							$$ = new S();        			// Create new statement
							backpatch($3->_trueList, $6);        	// If expression is true, goto M (just before statement body)
							
							// Merge falselist of expression, nextlist of statement and second N
							vector<int> temp = merge($3->_falseList, $7->_nextList);	
							$$->_nextList = merge($8->_nextList, temp);
						}
				   		| IF OPENING_ROUND_BRACKET expression N CLOSING_ROUND_BRACKET M statement N ELSE M statement	
				   		{
				   			//if statement with else
							backpatch($4->_nextList, nextinstr());		// Nextlist of N backpatched to nextinstr
							convInt2Bool($3);	// Convert expression to boolean which has additional attributes truelist and falselist
							$$ = new S();						// Create new statement
							backpatch($3->_trueList, $6);    // If expression is true, goto M1 (just before statement body of if block)
							backpatch($3->_falseList, $10);	// If expression is false, goto M2 (just before statement body of else block)
							
							// Merge falselist of statement body of if block, else block and second N
							vector<int> temp = merge($7->_nextList, $8->_nextList);	
							$$->_nextList = merge($11->_nextList, temp);	
				   		}
				   		| SWITCH OPENING_ROUND_BRACKET expression CLOSING_ROUND_BRACKET statement				
				   		{ 
				   			// printf("   selection_statement -> SWITCH (expression) statement\n"); 
				   		}
				   		;

iteration_statement: 	WHILE W OPENING_ROUND_BRACKET CT change_table M expression CLOSING_ROUND_BRACKET M loop_body_statement			
						{ 
						
							// Single statement while loop
							
							$$ = new S();	// Create new statement
							convInt2Bool($7);	// Convert expression to boolean which has additional attributes truelist and falselist
							backpatch($10->_nextList, $6);	// After loop_body_statements, go back to expression again
							backpatch($7->_trueList, $9);	// If expression is true, goto M2 (just before statement body of while loop)
							$$->_nextList = $7->_falseList;   // When expression is false, move out of loop
							
							// Emit to prevent fallthrough
							string str = to_string($6);// Mark the start of evaluation of expression and put it in str	
							QuadArray::emit("goto", str);					// Emit the quad
							__current_loop__ = "";
							__current_ST__->_parent->switchCurrentST();
						}
						| WHILE W OPENING_ROUND_BRACKET CT change_table M expression CLOSING_ROUND_BRACKET OPENING_CURLY_BRACKET M block_item_list_opt CLOSING_CURLY_BRACKET   
						{	
							// Multiple statement while loop

							$$ = new S();	// Create new statement
							convInt2Bool($7);	// Convert expression to boolean which has additional attributes truelist and falselist
							backpatch($11->_nextList, $6);	// After loop_body_statements, go back to expression again
							backpatch($7->_trueList, $10);	// If expression is true, goto M2 (just before statement body of while loop)
							$$->_nextList = $7->_falseList;   // When expression is false, move out of loop
							
							// Emit to prevent fallthrough
							string str= to_string($6);	// Mark the start of evaluation of expression and put it in str			
							QuadArray::emit("goto", str);					// Emit the quad
							__current_loop__ = "";
							__current_ST__->_parent->switchCurrentST();
						}
				   		| DO D M loop_body_statement M WHILE OPENING_ROUND_BRACKET expression CLOSING_ROUND_BRACKET SEMICOLON	
				   		{ 
				   			// Single Statement Do While Loop
				   			
				   			$$ = new S();// Create new statement	
							convInt2Bool($8);// Convert expression to boolean which has additional attributes truelist and falselist    
							backpatch($8->_trueList, $3);	// If expression is true, goto M1 (just before statement body of do-while loop)
							backpatch($4->_nextList, $5);	// After loop_body_statements, go back to expression again
							$$->_nextList = $8->_falseList;   // When expression is false, move out of loop
							__current_loop__ = "";
				   		}
				   		| DO D OPENING_CURLY_BRACKET M block_item_list_opt CLOSING_CURLY_BRACKET M WHILE OPENING_ROUND_BRACKET expression CLOSING_ROUND_BRACKET SEMICOLON      
						{
							// Multiple Statement Do While Loop
							
							$$ = new S();			// Create new statement
							convInt2Bool($10);// Convert expression to boolean which has additional attributes truelist and falselist
							backpatch($10->_trueList, $4);	// If expression is true, goto M1 (just before statement body of do-while loop)
							backpatch($5->_nextList, $7);	// After loop_body_statements, go back to expression again
							$$->_nextList = $10->_falseList;	// When expression is false, move out of loop
							__current_loop__ = "";
						}
				   		| FOR F OPENING_ROUND_BRACKET CT change_table declaration M expression_statement M expression_opt N CLOSING_ROUND_BRACKET M loop_body_statement	
				   		{
				   			// Single Statement For Loop
				   		
				   			$$ = new S();		 	// Create new statement
							convInt2Bool($8);  // Convert expression to boolean which has additional attributes truelist and falselist
							backpatch($8->_trueList, $13);	// If expression is true, goto M3 (just before statement body of for loop)
							backpatch($11->_nextList, $7);	// After N (incrementing iterator), go back to M1 (the conditional expression)
							backpatch($14->_nextList, $9);	// After loop_body_statements, go back to expression again
							
							// Emit to prevent fallthrough
							string str = to_string($9);	// Mark the start of evaluation of expression and put it in str
							QuadArray::emit("goto", str);				// Emit the quad
							$$->_nextList = $8->_falseList;	// When expression is false, move out of loop
							__current_loop__ = "";
							__current_ST__->_parent->switchCurrentST(); 
				   		}
				   		| FOR F OPENING_ROUND_BRACKET CT change_table expression_statement M expression_statement M expression_opt N CLOSING_ROUND_BRACKET M loop_body_statement			
				   		{ 
				   			// Single Statement For Loop
				   		
				   			$$ = new S();		 	// Create new statement
							convInt2Bool($8);  // Convert expression to boolean which has additional attributes truelist and falselist
							backpatch($8->_trueList, $13);	// If expression is true, goto M3 (just before statement body of for loop)
							backpatch($11->_nextList, $7);	// After N (incrementing iterator), go back to M1 (the conditional expression)
							backpatch($14->_nextList, $9);	// After loop_body_statements, go back to expression again
							
							// Emit to prevent fallthrough
							string str=to_string($9);	// Mark the start of evaluation of expression and put it in str
							QuadArray::emit("goto", str);				// Emit the quad
							$$->_nextList = $8->_falseList;	// When expression is false, move out of loop
							__current_loop__ = "";
							__current_ST__->_parent->switchCurrentST();
				   		}
				   		| FOR F OPENING_ROUND_BRACKET CT change_table declaration M expression_statement M expression_opt N CLOSING_ROUND_BRACKET M OPENING_CURLY_BRACKET block_item_list_opt CLOSING_CURLY_BRACKET     
						{
							// Multiple Statement For Loop
						
							$$ = new S();		 	// Create new statement
							convInt2Bool($8);  // Convert expression to boolean which has additional attributes truelist and falselist
							backpatch($8->_trueList, $13);	// If expression is true, goto M3 (just before statement body of for loop)
							backpatch($11->_nextList, $7);	// After N (incrementing iterator), go back to M1 (the conditional expression)
							backpatch($15->_nextList, $9);	// After loop_body_statements, go back to expression again
							
							// Emit to prevent fallthrough
							string str=to_string($9);	// Mark the start of evaluation of expression and put it in str
							QuadArray::emit("goto", str);				// Emit the quad
							$$->_nextList = $8->_falseList;	// When expression is false, move out of loop
							__current_loop__ = "";
							__current_ST__->_parent->switchCurrentST();
						}
						| FOR F OPENING_ROUND_BRACKET CT change_table expression_statement M expression_statement M expression_opt N CLOSING_ROUND_BRACKET M OPENING_CURLY_BRACKET block_item_list_opt CLOSING_CURLY_BRACKET
						{	
							// Multiple Statement For Loop
						
							$$ = new S();	   // Create new statement
							convInt2Bool($8);  // Convert expression to boolean which has additional attributes truelist and falselist
							backpatch($8->_trueList, $13);	// If expression is true, goto M3 (just before statement body of for loop)
							backpatch($11->_nextList, $7);	// After N (incrementing iterator), go back to M1 (the conditional expression)
							backpatch($15->_nextList, $9);	// After loop_body_statements, go back to expression again
							
							// Emit to prevent fallthrough
							string str=to_string($9);	// Mark the start of evaluation of expression and put it in str
							QuadArray::emit("goto", str);				// Emit the quad
							$$->_nextList = $8->_falseList;	// When expression is false, move out of loop
							__current_loop__ = "";
							__current_ST__->_parent->switchCurrentST();
						}
				   		;
				   		
expression_opt:		expression
					{
						$$ = $1 ; // Simply equate them 
					}
					| // epsilon
					{ 
						$$ = new E(); // Create new expression
					}
					;

jump_statement: 	GOTO IDENTIFIER SEMICOLON			
					{
						$$ = new S();						// Create new statement
						Label *l = Label::lookup($2->_name);			// The name of the label is the identifier
						if(l != NULL)								// If the label is found in the label table
						{
							QuadArray::emit("goto", "");						// Emit the quad
							vector<int> lst = makelist(nextinstr());	// Make a list containing the next instruction
							l->_nextList = merge(l->_nextList, lst);	// Merge nextlist of the label with this list
							if(l->_quadArrIndex != -1)						// If address referred to by the label is not -1
								backpatch(l->_nextList, l->_quadArrIndex);	// Backpatch the nextlist of label with this address
						} 
						else 										// If the label is not found in the label table
						{
							l = new Label($2->_name);				// Create a new Label with the identifier as its name
							l->_nextList = makelist(nextinstr());	// Nextlist of the label is a list containing the next instruction
							QuadArray::emit("goto", "");						// Emit the quad
							__labels__.push_back(*l);				// Update the label table
						}
						
					}
			  		| CONTINUE SEMICOLON				
			  		{ 
			  			// printf("   jump_statement -> CONTINUE ;\n"); 
			  			$$ = new S();	// Create new statement
			  		}
			  		| BREAK SEMICOLON					
			  		{ 
			  			// printf("   jump_statement -> BREAK ;\n"); 
			  			$$ = new S();	// Create new statement
			  		}
			  		| RETURN expression SEMICOLON	
			  		{  
			  			$$ = new S();	// Create new statement
						QuadArray::emit("return", $2->_loc->_name);	// Emit return with the name of the return value
			  		}
			  		| RETURN SEMICOLON	
			  		{ 
			  			$$ = new S();	// Create new statement
						QuadArray::emit("return", "");	// Emit return (used to return void)
			  		}
			  		;

// SECTION : EXTERNAL DEFINITIONS

translation_unit:	external_declaration   			 			
					{ /* printf("   translation_unit -> external_declaration\n"); */ }
                	| translation_unit external_declaration   	
                	{ /* printf("   translation_unit -> translation_unit external_declaration\n"); */ }
                	;

external_declaration:   function_definition    	
						{ /* printf("   external_declaration -> function_definition\n"); */ }
						| declaration  	 		
						{ /* printf("   external_declaration -> declaration\n"); */ }
						;

function_definition:	declaration_specifiers declarator declaration_list_opt change_table OPENING_CURLY_BRACKET block_item_list_opt CLOSING_CURLY_BRACKET      
						{ 
							int next_instr = 0;	 	// Start the index of the instructions in the function with 0
							__current_ST__->_parent = __global_ST__;	// Parent of the symbol table of the function is the global symbol table
							__num_tables__ = 0;		// Set the table count to 0
							__labels__.clear();	// Clear the label table
							__global_ST__->switchCurrentST();
						}
						;

declaration_list_opt:   declaration_list	
						{ /* printf("   declaration_list_opt -> declaration_list\n"); */ }
						| /* epsilon */
						;

declaration_list:       declaration		
						{ /* printf("   declaration_list -> declaration\n"); */ }
						| declaration_list declaration  
						{ /* printf("   declaration_list -> declaration_list declaration\n"); */ }
						;

%%
