
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O6 -- Target Translator File
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)

#include "ass6_19CS10044_19CS30053_translator.h"
#include <iostream>
#include <fstream>
#include <map>
#include <vector>
#include <string>
#include <iterator>
#include <algorithm>
using namespace std ;

ofstream __file_out_stream__ ;
int __asm_label_id__ ;
map<int, int> __quad_to_asm_label__ ;


////////////////////////////////////////// ++++ Activation Record Construction ++++ //////////////////////////////////////////

void SymbolTable::constructActivationRecord ( ) {
	cout << " +" << string(72, '-') << "+" << endl ;
	cout << " | [ ACTIVATION RECORD ]     " << _name << string(max<int>(0, 45 - _name.size()), ' ') << "|" << endl ;

	cout << " +" << string(20, '-') << "+" << string(16, '-') << "+" << string(14, '-') <<
		 "+" << string(9, '-') << "+" << string(9, '-') << "+" << endl ;
	cout << " | NAME " << string(14, ' ') ;
	cout << "| TYPE " << string(10, ' ') ;
	cout << "| CATEGORY " << string(4, ' ') ;
	cout << "| SIZE    " ;
	cout << "| OFFSET  |" << endl ;
	cout << " +" << string(20, '-') << "+" << string(16, '-') << "+" << string(14, '-') <<
		 "+" << string(9, '-') << "+" << string(9, '-') << "+" << endl ;

	vector<Symbol*> parameters ;
    int count = _symbols.size() ;
    int local_offset = -24 ;
    int param_offset = -20 ;

    for ( int i = 0 ; i < count ; i ++ ) {
        if ( _symbols[i]->_category == "param" ) {
			parameters.insert(parameters.begin(), _symbols[i]) ;
            _activationRec[_symbols[i]->_name] = param_offset ;
			param_offset += _symbols[i]->_size ;
        }

		else if ( _symbols[i]->_name == "return" )	continue ;
        else {
			if ( parameters.size() > 0 ) {
				int p = param_offset ;
				for ( Symbol * sym : parameters ) {
					p -= sym->_size ;
					cout << " | " << sym->_name << string(max<int>(0, 19 - sym->_name.size()), ' ') ;
					string type_string = sym->_type->print() ;
					cout << "| " << type_string << string(max<int>(0, 15 - type_string.size()), ' ') ;
					cout << "| " << sym->_category << string(max<int>(0, 13 - sym->_category.size()), ' ') ;
					cout << "| " << sym->_size << string(8 - to_string(sym->_size).size(), ' ') ;
					cout << "| " << p << string(8 - to_string(p).size(), ' ') ;
					cout << "|" << endl ;
				}
				parameters.clear() ;
			}

			Symbol * sym = _symbols[i] ;
			cout << " | " << sym->_name << string(max<int>(0, 19 - sym->_name.size()), ' ') ;
			string type_string = sym->_type->print() ;
			cout << "| " << type_string << string(max<int>(0, 15 - type_string.size()), ' ') ;
			cout << "| " << sym->_category << string(max<int>(0, 13 - sym->_category.size()), ' ') ;
			cout << "| " << sym->_size << string(8 - to_string(sym->_size).size(), ' ') ;
			cout << "| " << local_offset << string(8 - to_string(local_offset).size(), ' ') ;
			cout << "|" << endl ;

            _activationRec[_symbols[i]->_name] = local_offset ;
			local_offset -= _symbols[i]->_size ;
        }
    }

	cout << " +" << string(20, '-') << "+" << string(16, '-') << "+" << string(14, '-') <<
		 "+" << string(9, '-') << "+" << string(9, '-') << "+" << endl << endl ;
}


////////////////////////////////////////// ++++ Target Code Generation ++++ //////////////////////////////////////////

void generateTarget_x86_64_AssemblyCode ( string asm_code_file_name ) {
	vector<Quad> quads = __quad_array__._quads ;
	vector <string> __rel_ops__ = {"goto", "<", ">", "<=", ">=", "==", "!="} ;	// relational operators
	vector<string> invalid_ops = {"^", "|", "&", "<<", ">>", "~"} ;
	// [ BITWISE & SHIFT OPERATIONS ]
	// According to the instructions, the compiler should not support these type of instructions

	// mapping from quad number to label number
	// the target jump address of goto instructions must be labelled
	for ( Quad & quad : quads ) {
		if ( find(__rel_ops__.begin(), __rel_ops__.end(), quad._op) != __rel_ops__.end() )
			__quad_to_asm_label__[atoi(quad._result.c_str())] = 1 ;
	}
	
    int counter = 0 ;
    for ( auto & p : __quad_to_asm_label__ )
        p.second = counter ++ ;

	// nested_tables stores all the STs other than the global ST
	// Note that unlike in assignment 5, here ST for each function is
	// flattened out and no separate STs for blocks/local scopes are constructed.
	vector<SymbolTable*> nested_tables ;
	for ( Symbol * sym : __global_ST__->_symbols )
		if ( sym->_nested )
			nested_tables.push_back(sym->_nested) ;
	
	// Construct activation records of the functions
	// (with proper arrangement of parameters and return types)
	for ( SymbolTable * st : nested_tables )
		st->constructActivationRecord() ;
	
	__file_out_stream__.open(asm_code_file_name.c_str()) ;
	__file_out_stream__ << "\t.file\t" << "\"" << asm_code_file_name << "\"" << endl ;
	
	// Handling global static variables
	// Global static variables will be present in the global ST with the other function declarations
	// We will allocate space for these global statics separately using .globl or .comm directive
	for ( Symbol * sym : __current_ST__->_symbols ) {
		if ( sym->_category != "function" && sym->_category != "temp" ) {
			if ( sym->_type->_type == "char" ) { // global char variables
				if ( sym->_initVal != "" ) {
					__file_out_stream__ << "\t.globl\t" << sym->_name << "\n" ;
					__file_out_stream__ << "\t.type\t" << sym->_name << ", @object\n" ;
					__file_out_stream__ << "\t.size\t" << sym->_name << ", 1\n" ;
					__file_out_stream__ << sym->_name <<":\n" ;
					__file_out_stream__ << "\t.byte\t" << atoi(sym->_initVal.c_str()) << "\n" ;
				}
				else
					__file_out_stream__ << "\t.comm\t" << sym->_name << ", 1, 1\n" ;
			}
			if ( sym->_type->_type == "int" ) { // global int variables
				if ( sym->_initVal != "" ) {
					__file_out_stream__ << "\t.globl\t" << sym->_name << "\n" ;
					__file_out_stream__ << "\t.data\n" ;
					__file_out_stream__ << "\t.align 4\n" ;
					__file_out_stream__ << "\t.type\t" << sym->_name << ", @object\n" ;
					__file_out_stream__ << "\t.size\t" << sym->_name << ", 4\n" ;
					__file_out_stream__ << sym->_name <<":\n" ;
					__file_out_stream__ << "\t.long\t" << sym->_initVal << "\n" ;
				}
				else
					__file_out_stream__ << "\t.comm\t" << sym->_name << ", 4, 4\n" ;
			}
			if ( sym->_type->_type == "arr" ) { // global arrays
				__file_out_stream__ << "\t.comm\t" << sym->_name << ", " << sym->_size << ", 32\n" ;
			}
		}
	}

	// Handling string literals
	// All the string literals are declared in the "read-only data section" of the assembly code
	if ( __string_literals__.size() > 0 ) {
		__file_out_stream__ << "\t.section\t.rodata" << endl ;
		for ( auto it = __string_literals__.begin() ; it != __string_literals__.end() ; it++ ) {
			__file_out_stream__ << ".LC" << it - __string_literals__.begin() << ":" << endl ;
			__file_out_stream__ << "\t.string\t" << *it << endl ;
		}
	}

	__file_out_stream__ << "\t.text	\n" ;	// beginning of text segment
	vector<string> collec_parameters ;	// collection of parameters of a function
	map<string, int> op_results ;	
	// stores the integeral values of symbols that might be used particularly for 
	// determining the offset of an array element given the base pointer of the array.

	for ( auto it = quads.begin() ; it != quads.end() ; it ++ ) {
		
		if ( __quad_to_asm_label__.count(it - quads.begin()))
			__file_out_stream__ << ".L" << (2 * __asm_label_id__ + __quad_to_asm_label__.at(it - quads.begin()) + 2) <<  ": " << endl ;

		string result = it->_result ;
		string arg1 = it->_arg1 ;
		string arg2 = it->_arg2 ;
		string arg_proc = arg2 ;

		// add parameters to the "collection of parameters"
		if ( it->_op == "param" ) {
			collec_parameters.push_back(result) ;
			continue ;
		}
		
		if ( it->_op != "funcend" )
			__file_out_stream__ << "\t" ;

		// [ ADDITION OPERATION ]
		if ( it->_op == "+" ) {
			bool flag = true ;
			if ( arg_proc.empty() || ((!isdigit(arg_proc[0])) && (arg_proc[0] != '-') && (arg_proc[0] != '+')) ) flag = false ;
			else {
				char * p ;
				strtol(arg_proc.c_str(), &p, 10) ; // convert string to long integer
				flag = (*p == 0) ;
			}
			if ( flag )	// when adding a constant (immediate) value
				__file_out_stream__ << "addl \t$" << atoi(arg2.c_str()) << ", " << __current_ST__->_activationRec[arg1] << "(%rbp)" ;
			else {	// adding variable values (values stored in registers)
				__file_out_stream__ << "movl \t" << __current_ST__->_activationRec[arg1] << "(%rbp), " << "%eax" << endl ;
				__file_out_stream__ << "\tmovl \t" << __current_ST__->_activationRec[arg2] << "(%rbp), " << "%edx" << endl ;
				__file_out_stream__ << "\taddl \t%edx, %eax\n" ;
				__file_out_stream__ << "\tmovl \t%eax, " << __current_ST__->_activationRec[result] << "(%rbp)" ;
			}
		}

		// [ SUBTRACTION OPERATION ]
		else if ( it->_op == "-" ) {
			__file_out_stream__ << "movl \t" << __current_ST__->_activationRec[arg1] << "(%rbp), " << "%eax" << endl ;
			__file_out_stream__ << "\tmovl \t" << __current_ST__->_activationRec[arg2] << "(%rbp), " << "%edx" << endl ;
			__file_out_stream__ << "\tsubl \t%edx, %eax\n" ;
			__file_out_stream__ << "\tmovl \t%eax, " << __current_ST__->_activationRec[result] << "(%rbp)" ;
		}

		// [ MULTIPLICATION OPERATION ]
		else if ( it->_op == "*" ) {
			__file_out_stream__ << "movl \t" << __current_ST__->_activationRec[arg1] << "(%rbp), " << "%eax" << endl ;
			bool flag = true ;
			if ( arg_proc.empty() || ((!isdigit(arg_proc[0])) && (arg_proc[0] != '-') && (arg_proc[0] != '+')) ) flag = false ;
			else {
				char * p ;
				strtol(arg_proc.c_str(), &p, 10) ; // convert string to long integer
				flag = (*p == 0) ;
			}
			if ( flag ) {	// when multiplying a constant (immediate) value
				__file_out_stream__ << "\timull \t$" << atoi(arg2.c_str()) << ", " << "%eax" << endl ;
				string val = "" ;
				int n = __current_ST__->_symbols.size() ;
				for ( int i = 0 ; i < n ; i ++ ) {
					if ( __current_ST__->_symbols[i]->_name == arg1 )
						val = __current_ST__->_symbols[i]->_initVal ; // initial value of the first arguement
				}
				op_results[result] = atoi(arg2.c_str()) * atoi(val.c_str()) ;	
				// store the numerical value of the product in op_results data-structure
			}
			else	// multiplying variable values (values stored in registers)
				__file_out_stream__ << "\timull \t" << __current_ST__->_activationRec[arg2] << "(%rbp), " << "%eax" << endl ;
			__file_out_stream__ << "\tmovl \t%eax, " << __current_ST__->_activationRec[result] << "(%rbp)" ;			
		}

		// [ DIVISION OPERATION ]
		else if ( it->_op == "/" ) {
			__file_out_stream__ << "movl \t" << __current_ST__->_activationRec[arg1] << "(%rbp), " << "%eax" << endl ;
			__file_out_stream__ << "\tcltd" << endl ;
			__file_out_stream__ << "\tidivl \t" << __current_ST__->_activationRec[arg2] << "(%rbp)" << endl ;
			__file_out_stream__ << "\tmovl \t%eax, " << __current_ST__->_activationRec[result] << "(%rbp)" ;		
		}

		// [ MODULUS OPERATION ]
		else if ( it->_op == "%" ) {
			__file_out_stream__ << "movl \t" << __current_ST__->_activationRec[arg1] << "(%rbp), " << "%eax" << endl ;
			__file_out_stream__ << "\tcltd" << endl ;
			__file_out_stream__ << "\tidivl \t" << __current_ST__->_activationRec[arg2] << "(%rbp)" << endl ;
			__file_out_stream__ << "\tmovl \t%edx, " << __current_ST__->_activationRec[result] << "(%rbp)" ;	
		}

		// [ BITWISE & SHIFT OPERATIONS ]
		// According to the instructions, the compiler should not support these type of instructions
		else if ( find(invalid_ops.begin(), invalid_ops.end(), it->_op) != invalid_ops.end() )
			__file_out_stream__ << "nop" ;

		// [ COPY OPERATION ]
		else if ( it->_op == "=" )	{
			arg_proc = arg1 ;
			bool flag = true ;
			if ( arg_proc.empty() || ((!isdigit(arg_proc[0])) && (arg_proc[0] != '-') && (arg_proc[0] != '+')) ) flag = false ;
			else {
				char * p ;
				strtol(arg_proc.c_str(), &p, 10) ; // convert string to long integer
				flag = (*p == 0) ;
			}
			if (flag)	// when copying a constant (immediate) value
				__file_out_stream__ << "movl\t$" << atoi(arg1.c_str()) << ", " << "%eax" << endl ;
			else	// copying value from a register (or a variable)
				__file_out_stream__ << "movl\t" << __current_ST__->_activationRec[arg1] << "(%rbp), " << "%eax" << endl ;
			__file_out_stream__ << "\tmovl \t%eax, " << __current_ST__->_activationRec[result] << "(%rbp)" ;
		}	

		// [ COPY STRING LITERAL ]
		else if ( it->_op == "=@str" )	{
			__file_out_stream__ << "movq \t$.LC" << arg1 << ", " << __current_ST__->_activationRec[result] << "(%rbp)" ;
		}

		// [ COPY CHARACTER ]
		else if ( it->_op == "=@char" )	{
			__file_out_stream__ << "movb\t$" << atoi(arg1.c_str()) << ", " << __current_ST__->_activationRec[result] << "(%rbp)" ;
		}	

		// [ RELATIONAL OPERATORS / COMPARISON OPERATIONS ]
		else if ( it->_op == "==" ) {
			__file_out_stream__ << "movl\t" << __current_ST__->_activationRec[arg1] << "(%rbp), %eax\n" ;
			__file_out_stream__ << "\tcmpl\t" << __current_ST__->_activationRec[arg2] << "(%rbp), %eax\n" ;
			__file_out_stream__ << "\tje .L" << (2 * __asm_label_id__ + __quad_to_asm_label__.at(atoi(result.c_str())) + 2) ;
		}
		else if ( it->_op == "!=" ) {
			__file_out_stream__ << "movl\t" << __current_ST__->_activationRec[arg1] << "(%rbp), %eax\n" ;
			__file_out_stream__ << "\tcmpl\t" << __current_ST__->_activationRec[arg2] << "(%rbp), %eax\n" ;
			__file_out_stream__ << "\tjne .L" << (2 * __asm_label_id__ + __quad_to_asm_label__.at(atoi(result.c_str())) + 2) ;
		}
		else if ( it->_op == "<" ) {
			__file_out_stream__ << "movl\t" << __current_ST__->_activationRec[arg1] << "(%rbp), %eax\n" ;
			__file_out_stream__ << "\tcmpl\t" << __current_ST__->_activationRec[arg2] << "(%rbp), %eax\n" ;
			__file_out_stream__ << "\tjl .L" << (2 * __asm_label_id__ + __quad_to_asm_label__.at(atoi(result.c_str())) + 2) ;
		}
		else if ( it->_op == ">" ) {
			__file_out_stream__ << "movl\t" << __current_ST__->_activationRec[arg1] << "(%rbp), %eax\n" ;
			__file_out_stream__ << "\tcmpl\t" << __current_ST__->_activationRec[arg2] << "(%rbp), %eax\n" ;
			__file_out_stream__ << "\tjg .L" << (2 * __asm_label_id__ + __quad_to_asm_label__.at(atoi(result.c_str())) + 2 ) ;
		}
		else if ( it->_op == ">=" ) {
			__file_out_stream__ << "movl\t" << __current_ST__->_activationRec[arg1] << "(%rbp), %eax\n" ;
			__file_out_stream__ << "\tcmpl\t" << __current_ST__->_activationRec[arg2] << "(%rbp), %eax\n" ;
			__file_out_stream__ << "\tjge .L" << (2 * __asm_label_id__ + __quad_to_asm_label__.at(atoi(result.c_str())) + 2 ) ;
		}
		else if ( it->_op == "<=" ) {
			__file_out_stream__ << "movl\t" << __current_ST__->_activationRec[arg1] << "(%rbp), %eax\n" ;
			__file_out_stream__ << "\tcmpl\t" << __current_ST__->_activationRec[arg2] << "(%rbp), %eax\n" ;
			__file_out_stream__ << "\tjle .L" << (2 * __asm_label_id__ + __quad_to_asm_label__.at(atoi(result.c_str())) + 2 ) ;
		}
		else if ( it->_op == "goto" ) {
			__file_out_stream__ << "jmp .L" << (2 * __asm_label_id__ + __quad_to_asm_label__.at(atoi(result.c_str())) + 2 ) ;
		}

		// [ UNARY OPERATORS ]
		else if ( it->_op == "=&" ) {
			__file_out_stream__ << "leaq\t" << __current_ST__->_activationRec[arg1] << "(%rbp), %rax\n" ;
			__file_out_stream__ << "\tmovq \t%rax, " <<  __current_ST__->_activationRec[result] << "(%rbp)" ;
		}
		else if ( it->_op == "=*" ) {
			__file_out_stream__ << "movl\t" << __current_ST__->_activationRec[arg1] << "(%rbp), %eax\n" ;
			__file_out_stream__ << "\tmovl\t(%eax),%eax\n" ;
			__file_out_stream__ << "\tmovl \t%eax, " <<  __current_ST__->_activationRec[result] << "(%rbp)" ;	
		}
		else if ( it->_op == "*=" ) {
			__file_out_stream__ << "movl\t" << __current_ST__->_activationRec[result] << "(%rbp), %eax\n" ;
			__file_out_stream__ << "\tmovl\t" << __current_ST__->_activationRec[arg1] << "(%rbp), %edx\n" ;
			__file_out_stream__ << "\tmovl\t%edx, (%eax)" ;
		}
		else if ( it->_op == "uminus" )	__file_out_stream__ << "negl\t" << __current_ST__->_activationRec[arg1] << "(%rbp)" ;
		else if ( it->_op == "!" )		__file_out_stream__ << "nop" ;
		else if ( it->_op == "=[]" ) {
			int off = __current_ST__->_activationRec[arg1] - op_results[arg2] ;
			__file_out_stream__ << "movq\t" << off << "(%rbp), %rax" << endl ;
			__file_out_stream__ << "\tmovq \t%rax, " <<  __current_ST__->_activationRec[result] << "(%rbp)" ;
		}
		else if ( it->_op == "[]=" ) {
			int off = __current_ST__->_activationRec[arg1] ;
			__file_out_stream__ << "movl\t" << off << "(%rbp), %eax" << endl ;
			__file_out_stream__ << "\tcltq" << endl ;
			__file_out_stream__ << "\tmovl\t" << __current_ST__->_activationRec[arg2] << "(%rbp), %edx" << endl ;
			__file_out_stream__ << "\tmovl\t" << "%edx" << ", " << __current_ST__->_activationRec[result] << "(%rbp,%rax,4)" ;
		}	 
		else if ( it->_op == "return" ) {
			if ( result != "" ) __file_out_stream__ << "movl\t" << __current_ST__->_activationRec[result] << "(%rbp), "<<"%eax" << endl ;
			else __file_out_stream__ << "nop" << endl ;
			__file_out_stream__ << "\tjmp	" << __current_ST__->_name << "_RETURN" ;
		}
		else if ( it->_op == "param" ) {
			collec_parameters.push_back(result) ;
		}

		// [ FUNCTION CALL ]
		else if ( it->_op == "call" ) {
			SymbolTable * functionST = __global_ST__->lookup(arg1)->_nested ;
			int param_idx = -1 ;
			int param_counter = 0 ;
			for ( Symbol * sym : functionST->_symbols ) {
				param_idx ++ ;
				if ( sym->_category== "param" ) {
					if ( param_counter == 0 ) {
						// the 1st parameter to the function
						__file_out_stream__ << "movl \t" << __current_ST__->_activationRec[collec_parameters[param_idx]] << "(%rbp), " << "%eax" << endl ;
						__file_out_stream__ << "\tmovq \t" << __current_ST__->_activationRec[collec_parameters[param_idx]] << "(%rbp), " << "%rdi" << endl ;
						param_counter ++ ;
					}
					else if ( param_counter == 1 ) {
						// the 2nd parameter to the function
						__file_out_stream__ << "\tmovl \t" << __current_ST__->_activationRec[collec_parameters[param_idx]] << "(%rbp), " << "%eax" << endl ;
						__file_out_stream__ << "\tmovq \t" << __current_ST__->_activationRec[collec_parameters[param_idx]] << "(%rbp), " << "%rsi" << endl ;
						param_counter ++ ;
					}
					else if ( param_counter == 2 ) {
						// the 3rd parameter to the function
						__file_out_stream__ << "\tmovl \t" << __current_ST__->_activationRec[collec_parameters[param_idx]] << "(%rbp), " << "%eax" << endl ;
						__file_out_stream__ << "\tmovq \t" << __current_ST__->_activationRec[collec_parameters[param_idx]] << "(%rbp), " << "%rdx" << endl ;
						param_counter ++ ;
					}
					else if ( param_counter == 3 ) {
						// the 4th parameter to the function
						__file_out_stream__ << "\tmovl \t" << __current_ST__->_activationRec[collec_parameters[param_idx]] << "(%rbp), " << "%eax" << endl ;
						__file_out_stream__ << "\tmovq \t" << __current_ST__->_activationRec[collec_parameters[param_idx]] << "(%rbp), " << "%rcx" << endl ;
						param_counter ++ ;
					}
					else {	// handling more than 4 parameters to the function
						__file_out_stream__ << "\tmovq \t" << __current_ST__->_activationRec[collec_parameters[param_idx]] << "(%rbp), " << "%rdi" << endl ;							
					}
				}
				else break ;
			}
			collec_parameters.clear() ;
			__file_out_stream__ << "\tcall \t"<< arg1 << endl ;
			__file_out_stream__ << "\tmovl \t%eax, " << __current_ST__->_activationRec[result] << "(%rbp)" ;
		}
		
		// [ FUNCTION PROLOGUE ]
		else if ( it->_op == "func" ) {
			__file_out_stream__ <<".globl\t" << result << endl ;
			__file_out_stream__ << "\t.type\t"	<< result << ", @function" << endl ;
			__file_out_stream__ << result << ":" << endl ;
			__file_out_stream__ << ".LFB" << __asm_label_id__ << ":" << endl ;
			__file_out_stream__ << "\t.cfi_startproc" << endl ;
			__file_out_stream__ << "\tendbr64" << endl ;
			__file_out_stream__ << "\tpushq \t%rbp" << endl ;
			__file_out_stream__ << "\t.cfi_def_cfa_offset 16" << endl ;
			__file_out_stream__ << "\t.cfi_offset 6, -16" << endl ;
			__file_out_stream__ << "\tmovq \t%rsp, %rbp" << endl ;
			__file_out_stream__ << "\t.cfi_def_cfa_register 6" << endl ;

			// change the ST to the ST of the function whose prologue has just been printed
			__current_ST__ = __current_ST__->lookup(result)->_nested ;
			
			int space = (__current_ST__->_symbols).back()->_offset + 24 ;
			__file_out_stream__ << "\tsubq\t$" << space << ", %rsp" << endl ;
			
			// __current_ST__ is now the ST of the function whose prologue has just been printed
			SymbolTable * functionST = __current_ST__ ;
			int param_idx = 0 ;
			for ( Symbol * sym : functionST->_symbols ) {
				if ( sym->_category == "param" ) {
					// Load the first 4 parameters from the registers to the function stack
					if ( param_idx == 0 ) {
						__file_out_stream__ << "\tmovq\t%rdi, " << __current_ST__->_activationRec[sym->_name] << "(%rbp)" ;
						param_idx ++ ;
					}
					else if ( param_idx == 1 ) {
						__file_out_stream__ << "\n\tmovq\t%rsi, " << __current_ST__->_activationRec[sym->_name] << "(%rbp)" ;
						param_idx ++ ;
					}
					else if ( param_idx == 2 ) {
						__file_out_stream__ << "\n\tmovq\t%rdx, " << __current_ST__->_activationRec[sym->_name] << "(%rbp)" ;
						param_idx ++ ;
					}
					else if ( param_idx == 3 ) {
						__file_out_stream__ << "\n\tmovq\t%rcx, " << __current_ST__->_activationRec[sym->_name] << "(%rbp)" ;
						param_idx ++ ;
					}
				}
				else break ;
			}
		}
		
		// [ FUNCTION EPILOGUE ]
		else if ( it->_op == "funcend" ) {
			__file_out_stream__ << __current_ST__->_name << "_RETURN:" << endl ;
			__file_out_stream__ << "\tleave\n" ;
			__file_out_stream__ << "\t.cfi_restore 5\n" ;
			__file_out_stream__ << "\t.cfi_def_cfa 7, 8\n" ;
			__file_out_stream__ << "\tret\n" ;
			__file_out_stream__ << "\t.cfi_endproc" << endl ;
			__file_out_stream__ << ".LFE" << __asm_label_id__++ << ":" << endl ;
			__file_out_stream__ << "\t.size\t" << result << ", .-" << result ;
		}

		else __file_out_stream__ << "nop" ;
		__file_out_stream__ << endl ;
	}
	// footnote
	__file_out_stream__ << 	"\t.ident\t	\"generated by tinyC compiler\"\n" ;
	__file_out_stream__ << 	"\t.ident\t	\">> Hritaban Ghosh (19CS30053)\"\n" ;
	__file_out_stream__ << 	"\t.ident\t	\">> Nakul Aggarwal (19CS10044)\"\n" ;
	__file_out_stream__ << 	"\t.section\t.note.GNU-stack,\"\",@progbits\n" ;
	__file_out_stream__.close() ;
}


////////////////////////////////////////// ++++ Printing Global/Static Data Elements ++++ //////////////////////////////////////////

void printStaticDataTable ( ) {
	cout << " +" << string(24, '-') << "+" << string(20, '-') << "+" << string(12, '-') << "+" << string(9, '-') << "+" << endl ;
	cout << " | NAME " << string(18, ' ') ;
	cout << "| TYPE " << string(14, ' ') ;
	cout << "| INIT-VALUE " ;
	cout << "| SIZE    |" << endl ;
	cout << " +" << string(24, '-') << "+" << string(20, '-') << "+" << string(12, '-') << "+" << string(9, '-') << "+" << endl ;
	for ( Symbol * sym : __global_ST__->_symbols ) {
		if ( sym->_category == "global" ) {
			cout << " | " << sym->_name << string(max<int>(0, 23 - sym->_name.size()), ' ') ;
			string type_string = sym->_type->print() ;
			cout << "| " << type_string << string(max<int>(0, 19 - type_string.size()), ' ') ;
			cout << "|  " << sym->_initVal << string(max<int>(0, 10 - sym->_initVal.size()), ' ') ;
			cout << "| " << sym->_size << string(8 - to_string(sym->_size).size(), ' ') ;
			cout << "|" << endl ;
		}
	}
	cout << " +" << string(24, '-') << "+" << string(20, '-') << "+" << string(12, '-') << "+" << string(9, '-') << "+" << endl << endl ;
}


////////////////////////////////////////// ++++ Printing String Constants Table ++++ //////////////////////////////////////////

void printStringLiteralsTable ( ) {
	vector<string> unique_strings ;
	for ( auto & str : __string_literals__ ) {
		if ( find(unique_strings.begin(), unique_strings.end(), str) == unique_strings.end() )
			unique_strings.push_back(str) ;
	}
	cout << " +" << string(81, '-') << "+" << string(16, '-') << "+" << string(7, '-') << "+" << endl ;
	cout << " | VALUE " << string(74, ' ') ;
	cout << "| TYPE " << string(11, ' ') ;
	cout << "| SIZE |" << endl ;
	cout << " +" << string(81, '-') << "+" << string(16, '-') << "+" << string(7, '-') << "+" << endl ;
	for ( auto & str : unique_strings ) {
		string val = str.substr(1, str.size() - 2) ;
		cout << " | " << val << string(max<int>(0, 80 - val.size()), ' ') ;
		string type = "arr(" + to_string(str.size()) + ", char)" ;
		cout << "| " << type << string(max<int>(0, 16 - type.size()), ' ') ;
		string size = to_string(str.size()) ;
		cout << "| " << size << string(max<int>(0, 5 - size.size()), ' ') ;
		cout << "|" << endl ;
	}
	cout << " +" << string(81, '-') << "+" << string(16, '-') << "+" << string(7, '-') << "+" << endl << endl ;
}


////////////////////////////////////////// ++++ Main Function ++++ //////////////////////////////////////////

int main ( int argc , char ** argv ) {
    // assign initial values to all the global/external variables
    __next_temp_id__ = 0 ;  // compiler-generated temporary starts with ID 0
    __num_tables__ = 0 ;    // inital no. of tables = 0
    __current_loop__ = "" ; // not inside any loop initially
    __labels__ = vector<Label> ( ) ;    // no Label's were seen initially
    
    // All the basic types that are handled by the compiler are inserted into the __basic_type__ global
    // The sizes are the same as specified in the assignment.
    __basic_type__.push_back({"float", 8}) ;
    __basic_type__.push_back({"int", 4}) ;
    __basic_type__.push_back({"char", 1}) ;
    __basic_type__.push_back({"ptr", 4}) ;
    __basic_type__.push_back({"arr", 0}) ;
    __basic_type__.push_back({"void", 0}) ;
    __basic_type__.push_back({"func", 0}) ;
    __basic_type__.push_back({"block", 0}) ;
    __basic_type__.push_back({"null", 0}) ;

    __global_ST__ = new SymbolTable("ST.Global" ) ;  // create global ST
    __current_ST__ = __global_ST__ ;    // the source-code initally starts with the global scope
    __current_parent_ST__ = NULL ;      // parent of the global ST is Null

    cout << endl << endl << "\t\t ++++++ ERRORS & WARNINGS ++++++" << endl << endl ;    // some warnings/errors might be printed while parsing
    yyparse() ; // start parsing
    cout << endl << endl ;
	
    __global_ST__->updateOffsets() ;    // recursively update the offset of symbols in all 
                                        // the STs in the hierarchy rooted at the global ST

	cout << endl << endl << "\t\t ++++++ THREE ADDRESS CODE ++++++" ;   // [ PRINT THREE ADDRESS CODE ]
    __quad_array__.print() ;    // print all the Quad's in the __quad_array__._quads vector

	cout << endl << endl << "\t\t ++++++ SYMBOL TABLES (FLATTENED) ++++++" << endl << endl ;    // [ PRINT SYMBOL TABLE(S) ]
    __global_ST__->print(true) ;    // recursively print all the STs in the hierarhcy rooted at the global ST

	cout << endl << endl << "\t\t ++++++ TABLE OF GLOBAL DATA ++++++" << endl << endl ;    // print table of static/global variables
	printStaticDataTable() ;

	cout << endl << endl << "\t\t ++++++ TABLE OF STRING CONSTANTS ++++++" << endl << endl ;    		// print table of string constants
	printStringLiteralsTable() ;

	cout << endl << endl << "\t\t ++++++ ACTIVATION RECORDS ++++++" << endl << endl ;   	 // print activation records of the functions

	string asm_code_file_name = "ass6_19CS10044_19CS30053_asm_CUSTOM.s" ;
	if ( argc >= 2 )
		asm_code_file_name = "ass6_19CS10044_19CS30053_asm" + string(argv[1]) + ".s" ;
	generateTarget_x86_64_AssemblyCode(asm_code_file_name) ;

    return 0 ;
}
