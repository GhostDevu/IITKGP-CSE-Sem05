%{
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O4 -- Parser for tinyC
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)
    
	#include "stdio.h"
    extern int yylex ( ) ;
    void yyerror ( char * s ) ;
%}

%token IDENTIFIER STRING_LITERAL INTEGER_CONST FLOAT_CONST CHAR_CONST ENUMERATION_CONST
%token ARROW_OP UNARY_INCREMENT_OP UNARY_DECREMENT_OP RIGHT_SHIFT_OP LEFT_SHIFT_OP 
%token LESS_THAN_EQUAL_OP GREATER_THAN_EQUAL_OP EQUALITY_OP INEQUALITY_OP LOGICAL_OR_OP LOGICAL_AND_OP ELLIPSIS
%token MULT_ASSIGN_OP DIV_ASSIGN_OP MOD_ASSIGN_OP ADD_ASSIGN_OP SUB_ASSIGN_OP LSHIFT_ASSIGN_OP
%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN 
%token TYPEDEF AUTO REGISTER EXTERN STATIC INLINE CHAR SHORT INT SIGNED UNSIGNED 
%token LONG DOUBLE CONST VOLATILE VOID FLOAT ENUM _BOOL _COMPLEX _IMAGINARY
%token RESTRICT UNION SIZEOF STRUCT
%token RSHIFT_ASSIGN_OP BITW_AND_ASSIGN_OP BITW_XOR_ASSIGN_OP BITW_OR_ASSIGN_OP

%nonassoc ')'
%nonassoc ELSE
%start translation_unit
%%

// SECTION : EXPRESSIONS

primary_expression:	IDENTIFIER				{ printf("   primary_expression -> IDENTIFIER\n"); }
					| constant				{ printf("   primary_expression -> constant\n"); }
					| STRING_LITERAL		{ printf("   primary_expression -> STRING_LITERAL\n"); }
					| '(' expression ')'	{ printf("   primary_expression -> ( expression )\n"); }
					;

constant:   INTEGER_CONST	{ printf("   constant -> INTEGER_CONST\n"); }
			| FLOAT_CONST	{ printf("   constant -> FLOAT_CONST\n"); }
			| CHAR_CONST	{ printf("   constant -> CHAR_CONST\n"); } 
			;

postfix_expression:	primary_expression											{ printf("   postfix_expression -> primary_expression\n"); }
					| postfix_expression '['expression']'  						{ printf("   postfix_expression -> postfix_expression [ expression ]\n"); }
					| postfix_expression '(' arguement_expression_list_opt ')' 	{ printf("   postfix_expression -> ( arguement_expression_list )\n"); }
					| postfix_expression '.' IDENTIFIER   						{ printf("   postfix_expression -> postfix_expression . IDENTIFIER\n"); }
					| postfix_expression ARROW_OP IDENTIFIER    				{ printf("   postfix_expression -> postfix_expression -> IDENTIFIER\n"); }
					| postfix_expression UNARY_INCREMENT_OP   					{ printf("   postfix_expression -> postfix_expression ++\n"); }
					| postfix_expression UNARY_DECREMENT_OP   					{ printf("   postfix_expression -> postfix_expression --\n"); }
					| '(' type_name ')''{' initializer_list '}' 				{ printf("   postfix_expression -> ( type_name ) { initializer_list }\n"); }
					| '(' type_name ')''{' initializer_list ',''}'  			{ printf("   postfix_expression -> ( type_name ) { initializer_list , }\n"); }
					;

arguement_expression_list:  assignment_expression  									{ printf("   arguement_expression_list -> assignment_expression\n"); }
							| arguement_expression_list ',' assignment_expression   { printf("   arguement_expression_list -> arguement_expression_list , assignment_expression\n"); }
							;

arguement_expression_list_opt:	arguement_expression_list	{ printf("   arguement_expression_list_opt -> arguement_expression_list\n"); }
								| /* epsilon */
								;

unary_expression:   postfix_expression    					{ printf("   unary_expression -> postfix_expression\n"); }
					| UNARY_INCREMENT_OP unary_expression  	{ printf("   unary_expression -> ++ unary_expression\n"); }
					| UNARY_DECREMENT_OP unary_expression  	{ printf("   unary_expression -> -- unary_expression\n"); }
					| unary_operator cast_expression 		{ printf("   unary_expression -> unary_operator cast_expression\n"); }
					| SIZEOF unary_expression    			{ printf("   unary_expression -> sizeof unary_expression\n"); }
					| SIZEOF '(' type_name ')'  			{ printf("   unary_expression -> sizeof ( type_name )\n"); }
					;

unary_operator: '&'		{ printf("   unary_operator -> &\n"); }
				| '*' 	{ printf("   unary_operator -> *\n"); }
				| '+' 	{ printf("   unary_operator -> +\n"); }
				| '-' 	{ printf("   unary_operator -> -\n"); }
				| '~' 	{ printf("   unary_operator -> ~\n"); }
				| '!' 	{ printf("   unary_operator -> !\n"); }
				;

cast_expression:    unary_expression   					{ printf("   cast_expression -> unary_expression\n"); }
					| '(' type_name ')' cast_expression	{ printf("   cast_expression -> ( type_name ) cast_expression\n"); }
					;

multiplicative_expression:  cast_expression		{ printf("   multiplicative_expression -> cast_expression\n"); }
							| multiplicative_expression '*' cast_expression { printf("   multiplicative_expression -> multiplicative_expression * cast_expression\n"); }
							| multiplicative_expression '/' cast_expression { printf("   multiplicative_expression -> multiplicative_expression / cast_expression\n"); }
							| multiplicative_expression '%' cast_expression { printf("   multiplicative_expression -> multiplicative_expression %c cast_expression\n", '%'); }
							;

additive_expression:	multiplicative_expression							{ printf("   additive_expression -> multiplicative_expression\n"); }
						| additive_expression '+' multiplicative_expression { printf("   additive_expression -> additive_expression + multiplicative_expression\n"); }
						| additive_expression '-' multiplicative_expression { printf("   additive_expression -> additive_expression - multiplicative_expression\n"); }
						;

shift_expression:   additive_expression     									{ printf("   shift_expression -> additive_expression\n"); }
					| shift_expression LEFT_SHIFT_OP additive_expression    	{ printf("   shift_expression -> shift_expression << additive_expression\n"); }
					| shift_expression RIGHT_SHIFT_OP additive_expression 	{ printf("   shift_expression -> shift_expression >> additive_expression\n"); }
					;

relational_expression:	shift_expression	{ printf("   relational_expression -> shift_expression\n"); }
						| relational_expression '<' shift_expression	{ printf("   relational_expression -> relational_expression < shift_expression\n"); }
						| relational_expression '>' shift_expression	{ printf("   relational_expression -> relational_expression > shift_expression\n"); }
						| relational_expression LESS_THAN_EQUAL_OP shift_expression		{ printf("   relational_expression -> relational_expression <= shift_expression\n"); }
						| relational_expression GREATER_THAN_EQUAL_OP shift_expression  { printf("   relational_expression -> relational_expression >= shift_expression\n"); }
						; 

equality_expression:	relational_expression	{ printf("   equality_expression -> relational_expression\n"); }
						| equality_expression EQUALITY_OP relational_expression		{ printf("   equality_expression -> equality_expression == relational_expression\n"); }
						| equality_expression INEQUALITY_OP relational_expression	{ printf("   equality_expression -> equality_expression != relational_expression\n"); }
						;

AND_expression:	equality_expression		{ printf("   AND_expression -> equality_expression\n"); }
                | AND_expression '&' equality_expression	{ printf("   AND_expression -> AND_expression & equality_expression\n"); }
                ;

exclusive_OR_expression:	AND_expression		{ printf("   exclusive_OR_expression -> AND_expression\n"); } 
							| exclusive_OR_expression '^' AND_expression	{ printf("   exclusive_OR_expression -> exclusive_OR_expression ^ AND_expression\n"); }
							;

inclusive_OR_expression:	exclusive_OR_expression		{ printf("   inclusive_OR_expression -> exclusive_OR_expression\n"); }
							| inclusive_OR_expression '|' exclusive_OR_expression	{ printf("   inclusive_OR_expression -> inclusive_OR_expression | exclusive_OR_expression\n"); } 
							;

logical_AND_expression:		inclusive_OR_expression		{ printf("   logical_AND_expression -> inclusive_OR_expression\n"); } 
							| logical_AND_expression LOGICAL_AND_OP inclusive_OR_expression		{ printf("   logical_AND_expression -> logical_AND_expression && inclusive_OR_expression\n"); } 
							;

logical_OR_expression:     	logical_AND_expression		{ printf("   logical_OR_expression -> logical_AND_expression\n"); }
							| logical_OR_expression LOGICAL_OR_OP logical_AND_expression	{ printf("   logical_OR_expression -> logical_OR_expression || logical_AND_expression\n"); } 
							;

conditional_expression:		logical_OR_expression		{ printf("   conditional_expression -> logical_OR_expression\n"); }
							| logical_OR_expression '?' expression ':' conditional_expression	{ printf("   conditional_expression -> logical_OR_expression ? expression : conditional_expression\n"); }
							;

assignment_expression:		conditional_expression		{ printf("   assignment_expression -> conditional_expression\n"); }
							| unary_expression assignment_operator assignment_expression	{ printf("   assignment_expression -> unary_expression assignment_operator assignment_expression\n"); }
							;

assignment_operator:	'=' 						{ printf("   assignment_operator -> =\n"); }
						| MULT_ASSIGN_OP 			{ printf("   assignment_operator -> *=\n"); }
						| DIV_ASSIGN_OP 			{ printf("   assignment_operator -> /=\n"); }
						| MOD_ASSIGN_OP 			{ printf("   assignment_operator -> %c=\n", '%'); }
						| ADD_ASSIGN_OP				{ printf("   assignment_operator -> +=\n"); } 
						| SUB_ASSIGN_OP 			{ printf("   assignment_operator -> -=\n"); }
				        | LSHIFT_ASSIGN_OP 			{ printf("   assignment_operator -> <<=\n"); }
						| RSHIFT_ASSIGN_OP 			{ printf("   assignment_operator -> >>=\n"); }
						| BITW_AND_ASSIGN_OP 		{ printf("   assignment_operator -> &=\n"); }
						| BITW_XOR_ASSIGN_OP 		{ printf("   assignment_operator -> ^=\n"); }
						| BITW_OR_ASSIGN_OP 		{ printf("   assignment_operator -> |=\n"); }
				        ;

expression:	assignment_expression	{ printf("   expression -> assignment_expression\n"); }
			| expression ',' assignment_expression    { printf("   expression -> expression , assignment_expression\n"); }
			;

constant_expression:	conditional_expression	{ printf("   constant_expression -> conditional_expression\n"); } 
						;

// SECTION : DECLARATIONS

declaration:	declaration_specifiers init_declarator_list_opt ';'	{ printf("   declaration -> declaration_specifiers init_declarator_list_opt ;\n"); }
		   	 	;

init_declarator_list_opt: 	init_declarator_list	{ printf("   init_declarator_list_opt -> init_declarator_list\n"); }
							| /* epsilon */
							;

declaration_specifiers:		storage_class_specifier declaration_specifiers_opt	{ printf("   declaration_specifiers -> storage_class_specifier declaration_specifiers_opt\n"); }
						  	| type_specifier declaration_specifiers_opt			{ printf("   declaration_specifiers -> type_specifier declaration_specifiers_opt\n"); }
						  	| type_qualifier declaration_specifiers_opt			{ printf("   declaration_specifiers -> type_qualifier declaration_specifiers_opt\n"); }
						  	| function_specifier declaration_specifiers_opt		{ printf("   declaration_specifiers -> function_specifier declaration_specifiers_opt\n"); }
						  	;

declaration_specifiers_opt:	declaration_specifiers	{ printf("   declaration_specifiers_opt -> declaration_specifiers\n"); }
							| /* epsilon */
							;

init_declarator_list: 	init_declarator								{ printf("   init_declarator_list -> init_declarator\n"); }
						| init_declarator_list ',' init_declarator	{ printf("   init_declarator_list -> init_declarator_list , init_declarator\n"); }
						;

init_declarator: 	declarator						{ printf("   init_declarator -> declarator\n"); }
			   		| declarator '=' initializer    { printf("   init_declarator -> declarator = initializer\n"); }
			   		;

storage_class_specifier:	EXTERN		{ printf("   storage_class_specifier -> EXTERN\n"); }
							| STATIC	{ printf("   storage_class_specifier -> STATIC\n"); }
							| AUTO		{ printf("   storage_class_specifier -> AUTO\n"); }
							| REGISTER	{ printf("   storage_class_specifier -> REGISTER\n"); }
					   		;

type_specifier:		VOID				{ printf("   type_specifier -> VOID\n"); }
					| CHAR				{ printf("   type_specifier -> CHAR\n"); }
					| SHORT				{ printf("   type_specifier -> SHORT\n"); }
					| INT				{ printf("   type_specifier -> INT\n"); }
					| LONG				{ printf("   type_specifier -> LONG\n"); }
					| FLOAT				{ printf("   type_specifier -> FLOAT\n"); }
					| DOUBLE			{ printf("   type_specifier -> DOUBLE\n"); }
					| SIGNED			{ printf("   type_specifier -> SIGNED\n"); }
					| UNSIGNED			{ printf("   type_specifier -> UNSIGNED\n"); }
					| _BOOL				{ printf("   type_specifier -> _BOOL\n"); }
					| _COMPLEX			{ printf("   type_specifier -> _COMPLEX\n"); }
					| _IMAGINARY		{ printf("   type_specifier -> _IMAGINARY\n"); }
			  		| enum_specifier	{ printf("   type_specifier -> enum_specifier\n"); }
			  		;

enum_specifier: 	ENUM identifier_opt '{' enumerator_list '}'			{ printf("   enum_specifier -> ENUM identifier_opt { enumerator_list }\n"); }
			  		| ENUM identifier_opt '{' enumerator_list ',' '}'	{ printf("   enum_specifier -> ENUM identifier_opt { enumerator_list , }\n"); }
			  		| ENUM IDENTIFIER									{ printf("   enum_specifier -> ENUM IDENTIFIER\n"); }
			  		;

identifier_opt: 	IDENTIFIER	{ printf("   identifier_opt -> IDENTIFIER\n"); }
					| /* epsilon */;

enumerator_list: 	enumerator							{ printf("   enumerator_list -> enumerator\n"); }
			   		| enumerator_list ',' enumerator	{ printf("   enumerator_list -> enumerator_list , enumerator\n"); }
			   		;

enumerator: 	IDENTIFIER		{ printf("   enumerator -> ENUMERATION_CONST\n"); }
		  		| IDENTIFIER '=' constant_expression	{ printf("   enumerator -> ENUMERATION_CONST = constant_expression\n"); }
		  		;

specifier_qualifier_list: 	type_specifier specifier_qualifier_list_opt		{ printf("   specifier_qualifier_list -> type_specifier specifier_qualifier_list_opt\n"); }
							| type_qualifier specifier_qualifier_list_opt	{ printf("   specifier_qualifier_list -> type_qualifier specifier_qualifier_list_opt\n"); }
							;

specifier_qualifier_list_opt: 	specifier_qualifier_list	{ printf("   specifier_qualifier_list_opt -> specifier_qualifier_list\n"); }
								| /* epsilon */
								;

type_qualifier:	CONST		{ printf("   type_qualifier -> CONST\n"); }
				| RESTRICT	{ printf("   type_qualifier -> RESTRICT\n"); }
				| VOLATILE	{ printf("   type_qualifier -> VOLATILE\n"); }
				;

function_specifier:	INLINE	{ printf("   function_specifier -> INLINE\n"); } 
					;

declarator:	pointer_opt direct_declarator	{ printf("   declarator -> pointer_opt direct_declarator\n"); }
			;

pointer_opt:	pointer		{ printf("   pointer_opt -> pointer\n"); }
		   		| /* epsilon */
		   		;	   

direct_declarator:	IDENTIFIER				{ printf("   direct_declarator -> IDENTIFIER\n"); }
					| '(' declarator ')'	{ printf("   direct_declarator -> ( declarator )\n"); }
					| direct_declarator '[' type_qualifier_list_opt assignment_expression_opt ']'		{ printf("   direct_declarator -> direct_declarator [ type_qualifier_list_opt assignment_expression_opt ]\n"); }
					| direct_declarator '[' STATIC type_qualifier_list_opt assignment_expression ']'	{ printf("   direct_declarator -> direct_declarator [ STATIC type_qualifier_list_opt assignment_expression ]\n"); }
					| direct_declarator '[' type_qualifier_list STATIC assignment_expression ']'		{ printf("   direct_declarator -> direct_declarator [ type_qualifier_list STATIC assignment_expression ]\n"); }
					| direct_declarator '[' type_qualifier_list_opt '*' ']'					{ printf("   direct_declarator -> direct_declarator [ type_qualifier_list_opt * ]\n"); }
					| direct_declarator '(' parameter_type_list ')'							{ printf("   direct_declarator -> direct_declarator ( parameter_type_list )\n"); }
					| direct_declarator '(' identifier_list_opt ')'							{ printf("   direct_declarator -> direct_declarator ( identifier_list_opt )\n"); }
					;

type_qualifier_list_opt: 	type_qualifier_list		{ printf("   type_qualifier_list_opt -> type_qualifier_list\n"); }
					   		| /* epsilon */
					   		;

assignment_expression_opt:	assignment_expression	{ printf("   assignment_expression_opt -> assignment_expression\n"); }
							| /* epsilon */
							;

identifier_list_opt:	identifier_list		{ printf("   identifier_list_opt -> identifier_list\n"); }
				   		| /* epsilon */
				   		;	

pointer:	'*' type_qualifier_list_opt				{ printf("   pointer -> * type_qualifier_list_opt\n"); }
	   		| '*' type_qualifier_list_opt pointer	{ printf("   pointer -> * type_qualifier_list_opt pointer\n"); }
	   		;

type_qualifier_list:	type_qualifier							{ printf("   type_qualifier_list -> type_qualifier\n"); }
				   		| type_qualifier_list type_qualifier	{ printf("   type_qualifier_list -> type_qualifier_list type_qualifier\n"); }
				   		;

parameter_type_list: 	parameter_list					{ printf("   parameter_type_list -> parameter_list\n"); }
				   		| parameter_list ',' ELLIPSIS	{ printf("   parameter_type_list -> parameter_list , ...\n"); }
				   		;

parameter_list: 	parameter_declaration						{ printf("   parameter_list -> parameter_declaration\n"); }
			  		| parameter_list ',' parameter_declaration	{ printf("   parameter_list -> parameter_list , parameter_declaration\n"); }
			  		;

parameter_declaration: 		declaration_specifiers declarator	{ printf("   parameter_declaration -> declaration_specifiers declarator\n"); }
					 		| declaration_specifiers			{ printf("   parameter_declaration -> declaration_specifiers\n"); }
					 		;

identifier_list: 	IDENTIFIER							{ printf("   identifier_list -> IDENTIFIER\n"); }
			   		| identifier_list ',' IDENTIFIER	{ printf("   identifier_list -> identifier_list , IDENTIFIER\n"); }
			   		;

type_name: 	specifier_qualifier_list	{ printf("   type_name -> specifier_qualifier_list\n"); }
		 	;

initializer: 	assignment_expression			{ printf("   initializer -> assignment_expression\n"); }
		   		| '{' initializer_list '}'		{ printf("   initializer -> { initializer_list }\n"); }
		   		| '{' initializer_list ',' '}'	{ printf("   initializer -> { initializer_list , }\n"); }
		   		;

initializer_list: 	designation_opt initializer							{ printf("   initializer_list -> designation_opt initializer\n"); }
					| initializer_list ',' designation_opt initializer	{ printf("   initializer_list -> initializer_list , designation_opt initializer\n"); }
					;

designation_opt:    designation 	{ printf("   designation_opt -> designation\n"); }
					| /* epsilon */
					;

designation: 	designator_list '='		{ printf("   designation -> designator_list =\n"); }
		   		;

designator_list: 	designator						{ printf("   designator_list -> designator\n"); }
			   		| designator_list designator	{ printf("   designator_list -> designator_list designator\n"); }
			   		;

designator: 	'[' constant_expression ']'	{ printf("   designator -> [ constant_expression ]\n"); }
		  		| '.' IDENTIFIER	{ printf("   designator -> . IDENTIFIER\n"); }
		  		;

// SECTION : STATEMENTS

statement: 	labeled_statement		{ printf("   statement -> labeled_statement\n"); }
		 	| compound_statement	{ printf("   statement -> compound_statement\n"); }
		 	| expression_statement	{ printf("   statement -> expression_statement\n"); }
		 	| selection_statement	{ printf("   statement -> selection_statement\n"); }
		 	| iteration_statement	{ printf("   statement -> iteration_statement\n"); }
		 	| jump_statement		{ printf("   statement -> jump_statement\n"); }
		 	;

labeled_statement: 	IDENTIFIER ':' statement					{ printf("   labeled_statement -> IDENTIFIER : statement\n"); }
				 	| CASE constant_expression ':' statement	{ printf("   labeled_statement -> CASE constant_expression : statement\n"); }
				 	| DEFAULT ':' statement						{ printf("   labeled_statement -> DEFAULT : statement\n"); }
				 	;

compound_statement:	'{' block_item_list_opt '}'	{ printf("   compound_statement -> { block_item_list_opt }\n"); }
					;

block_item_list: 	block_item						{ printf("   block_item_list -> block_item\n"); }
			   		| block_item_list block_item	{ printf("   block_item_list -> block_item_list block_item\n"); }
			   		;

block_item_list_opt: 	block_item_list		{ printf("   block_item_list_opt -> block_item_list\n"); }
						| /* epsilon */ 
						;
			
block_item: 	declaration		{ printf("   block_item -> declaration\n"); }
		  		| statement		{ printf("   block_item -> statement\n"); }
		  		;

expression_statement: 	expression_opt ';'	{ printf("   expression_statement -> expression_opt ;\n"); }
						;

selection_statement: 	IF '(' expression ')' statement					{ printf("   selection_statement -> IF ( expression ) statement\n"); }
				   		| IF '(' expression ')' statement ELSE statement	{ printf("   selection_statement -> IF ( expression ) statement ELSE statement\n"); }
				   		| SWITCH '(' expression ')' statement				{ printf("   selection_statement -> SWITCH ( expression ) statement\n"); }
				   		;

iteration_statement: 	WHILE '(' expression ')' statement			{ printf("   iteration_statement -> WHILE ( expression ) statement\n"); }
				   		| DO statement WHILE '('expression')' ';'	{ printf("   iteration_statement -> DO statement WHILE ( expression ) ;\n"); }
				   		| FOR '(' expression_opt ';' expression_opt ';' expression_opt ')' statement	{ printf("   iteration_statement -> FOR ( expression_opt ; expression_opt ; expression_opt ) statement\n"); }
				   		| FOR '(' declaration expression_opt ';' expression_opt ')' statement			{ printf("   iteration_statement -> FOR ( declaration expression_opt ; expression_opt ) statement\n"); }
				   		;

expression_opt:	expression		{ printf("   expression_opt -> expression\n"); } 
				| /* epsilon */
				;

jump_statement: 	GOTO IDENTIFIER ';'			{ printf("   jump_statement -> GOTO IDENTIFIER ;\n"); }
			  		| CONTINUE ';'				{ printf("   jump_statement -> CONTINUE ;\n"); }
			  		| BREAK ';'					{ printf("   jump_statement -> BREAK ;\n"); }
			  		| RETURN expression_opt ';'	{ printf("   jump_statement -> RETURN expression_opt ;\n"); }
			  		;

// SECTION : EXTERNAL DEFINITIONS

translation_unit:	external_declaration   			 			{ printf("   translation_unit -> external_declaration\n"); }
                	| translation_unit external_declaration   	{ printf("   translation_unit -> translation_unit external_declaration\n"); }
                	;

external_declaration:   function_definition    	{ printf("   external_declaration -> function_definition\n"); }
						| declaration  	 		{ printf("   external_declaration -> declaration\n"); }
						;

function_definition:	declaration_specifiers declarator declaration_list_opt compound_statement    { printf("   function_definition -> declaration_specifiers declarator declaration_list_opt compound_statement\n"); }
						;

declaration_list_opt:   declaration_list	{ printf("   declaration_list_opt -> declaration_list\n"); }
						| /* epsilon */
						;

declaration_list:       declaration		{ printf("   declaration_list -> declaration\n"); }
						| declaration_list declaration  { printf("   declaration_list -> declaration_list declaration\n"); }
						;

%%

void yyerror ( char * s ) {
    printf(" [ ERROR : %s ]\n", s) ;
    return ;
}
