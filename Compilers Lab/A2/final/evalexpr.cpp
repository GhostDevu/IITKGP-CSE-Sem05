#include <iostream>
#include <bits/stdc++.h>
#include "lex.yy.c"
using namespace std;

// Defining all structures

// For symbol table - Implemeted as a linked list stores Type, Symbol name, AttributeValue, pointer to the next entry in symbol table   
typedef struct snode{
    string type;
    string symbol_name;
    int attributevalue;
    struct snode* next;
} snode;
typedef snode* symboltable;

// Union of nodeinfo- Store the info for each node in parsetree
typedef union nodeinfo{
    string op;
    symboltable reft;
    symboltable refc;

    // Constructor - Destructor
    nodeinfo() : op("") {;} 
    ~nodeinfo() {}
} nodeinfo;

// Structure for Tree node for Parse tree 
typedef struct treenode{
    string type;
    nodeinfo info;
    struct treenode* LC;
    struct treenode* RC;
    struct treenode* P;

    // Constructore
    treenode() : type(""), LC(nullptr), RC(nullptr), P(nullptr) {}
    ~treenode() {}
} treenode;
typedef treenode* parsetree;


// Global Variable 
symboltable T = NULL; // Symbol table for ID types
symboltable C = NULL; // Symbol table for NUM types
stack<string> CFG; // Stack to maintain the grammar rules
parsetree PT=NULL; // Parsetree
int line_number = 1; // Stores line number for error recovery


// Functions for teh Compiler

//Functions related to the symboltable
//function to add to a symbol table
symboltable addtotbl(symboltable T, string type,string id){
    symboltable tail;
    tail = T;
    while(tail)
    {
        if (tail->symbol_name==id)
        {
            return T;
        }
        tail = tail->next;
    }
    tail = new snode;

    if(type == "NUM"){
        tail->type = "NUM";
        tail->symbol_name = id;
        tail->attributevalue = stoi(id);
        tail->next = T;
    }
    else{
        tail->type = "ID";
        tail->symbol_name = id;
        tail->attributevalue = -1; // garbage
        tail->next = T;
    }
    return tail;
}

// function to find in the symbol table using the token and symbol name entries
symboltable findintable(symboltable table,string id){
    symboltable tail;
    tail = table;
    while(tail)
    {
        if (tail->symbol_name==id)
        {
            return tail;
        }
        tail = tail->next;
    }
    return NULL;
}

// function to attribute value (input value) for variables in the table for ID types
int take_input_for_ids(symboltable T){
    symboltable tail = T;
    if(tail == NULL){
        return 1;
    }
    int forward = take_input_for_ids(tail->next);
    if(forward == 0){
        cout << "***ERROR(line:"<< line_number <<"): "<<" expected input for " << tail->next->symbol_name << endl;
        exit(0);
    }
    int nexttok;
    while ((nexttok = yylex()))
    {
        string token = yytext;
        switch (nexttok)
        {
        case NUM:{
            tail->attributevalue = stoi(token);
            cout << tail->symbol_name << " = " << tail->attributevalue << endl;
            return 1;    
            break;
        }
        case NL:{
            line_number++;
            break;
        }
        default:{
            cout << "Expected Input for " << tail->symbol_name << endl;
            exit(0);
        }
        }

    }
    return 0;
}

// Function for Parsetree
// function to print it
void print_parse_tree(parsetree p,int level){
    int temp=level;
    if(p==NULL) {
        return;
    }
    while(temp--){
        cout<<"    "; 
    }
    if(p->P != NULL){
        cout << "----->";
    }
    if(p->type=="OP"){
        cout << "OP(" << p->info.op << ")" << endl;
    }
    else if(p->type == "NUM"){
        cout << "NUM(" << p->info.refc->symbol_name << ")" << endl;
    }
    else if(p->type == "ID"){
        cout << "ID(" << p->info.reft->symbol_name << ")" << endl;
    }
    if(p->P!=NULL){
        print_parse_tree(p->LC,level+1);
        print_parse_tree(p->RC,level+1);
    }
    else{
        print_parse_tree(p->LC,level);
        print_parse_tree(p->RC,level);
    }
    return;
}

// function to evaluate the parse tree
int evaluate(parsetree PT){
    if(PT->type == "NUM"){
        return PT->info.refc->attributevalue;
    }
    if(PT->type == "ID"){
        return PT->info.reft->attributevalue;
    }
    char op = PT->info.op[0];
    switch(op){
        case '+': return evaluate(PT->LC) + evaluate(PT->RC);
        case '-': return evaluate(PT->LC) - evaluate(PT->RC);
        case '*': return evaluate(PT->LC) * evaluate(PT->RC);
        case '/':{
            if(evaluate(PT->RC) == 0){
                cout << "***ERROR:"<<"Arithmetic Error- Divison by zero" << endl;
                exit(0);
            }
            else{
                return evaluate(PT->LC) / evaluate(PT->RC);
            }
        }
        case '%': return evaluate(PT->LC) % evaluate(PT->RC);
    }
    return 0;
}

// FUNCTION TO PRINT ERROR 
void print_error(string invalid){
    string s = CFG.top();
    if(s=="(") cout << "***ERROR (line:" << line_number << "): " <<  "Expected Left Parenthesis in place of " << invalid << endl;
    else if(s=="OP") cout << "***ERROR (line:" << line_number << "): " << "Expected Operator in place of " << invalid << endl;
    else if(s=="ARG") cout << "***ERROR (line:" << line_number << "): " << "Expected ID/NUM/( in place of " << invalid << endl;
    else if(s=="EXPR") cout << "***ERROR (line:" << line_number << "): " << "Expected Left Parenthesis in place of " << invalid << endl;
    else if(s==")") cout << "***ERROR (line:" << line_number << "): " << "Expected Right Parenthesis in place of " << invalid << endl;
    else if(s=="ID") cout << "***ERROR (line:" << line_number << "): " << "Expected ID in place of " << invalid << endl;
    else if(s=="NUM") cout << "***ERROR (line:" << line_number << "): " << "Expected NUM in place of " << invalid << endl;
    exit(0);
}

int main(){
    // starting an instance of the CFG
    CFG.push("EXPR");
    int nexttok;
    int break_inner_loop_flag=0;
    while((nexttok = yylex())){             
        string token = yytext;
        break_inner_loop_flag = 0;
        while(1){                           
            string top = CFG.top();
            switch(nexttok){                
                case ID:{                       // Handle ID type token        
                    if(top!="ARG"){
                        print_error(token);
                    }
                    T = addtotbl(T,"ID",token);
                    if((PT->LC!=NULL) && (PT->RC!=NULL)){
                            cout << "***ERROR (line:" << line_number << "): Too many arguments for the operator-" << yytext << endl;
                            exit(0);
                        }
                        if(PT->LC==NULL){
                            PT->LC = new treenode;
                            PT->LC->P = PT;
                            PT = PT->LC;
                            PT->LC = NULL;
                            PT->RC = NULL;
                            CFG.pop();
                            PT->type = "ID";
                            PT->info.reft = findintable(T,token);
                            if(PT->info.reft == NULL) {
                                cout << "***ERROR (line:" << line_number << "): Error in fetching the reference in the symbol table"<< endl;
                                exit(0);
                            }
                            PT = PT->P;
                            break_inner_loop_flag = 1;
                            break;
                        }
                        if(PT->RC==NULL){
                            PT->RC = new treenode;
                            PT->RC->P = PT;
                            PT = PT->RC;
                            PT->LC = NULL;
                            PT->RC = NULL;
                            CFG.pop();
                            PT->type = "ID";
                            PT->info.reft = findintable(T,token);
                            if(PT->info.reft == NULL) {
                                cout << "***ERROR (line:" << line_number << "): error in fetching the reference in the symbol table"<< endl;
                                exit(0);
                            }
                            PT = PT->P;
                            break_inner_loop_flag = 1;
                            break;
                        }
                    break;
                }
                case NUM:{                      // Handle NUM type token 
                    if(top!="ARG"){
                        print_error(token);
                    }
                    C = addtotbl(C,"NUM",token);
                    if((PT->LC!=NULL) && (PT->RC!=NULL)){
                            cout << "***ERROR (line:" << line_number << "): Too many arguments for the operator-" << yytext << endl;
                            exit(0);
                    }
                    if(PT->LC==NULL){
                        PT->LC = new treenode;
                        PT->LC->P = PT;
                        PT = PT->LC;
                        PT->LC = NULL;
                        PT->RC = NULL;
                        CFG.pop();
                        PT->type = "NUM";
                        PT->info.refc = findintable(C,token); 
                        if(PT->info.refc == NULL) {
                            cout << "***ERROR (line:" << line_number << "): Error in fetching the reference in the symbol table"<< endl;
                            exit(0);
                        }
                        PT = PT->P;
                        break_inner_loop_flag = 1;
                        break;
                    }
                    if(PT->RC==NULL){
                        PT->RC = new treenode;
                        PT->RC->P = PT;
                        PT = PT->RC;
                        PT->LC = NULL;
                        PT->RC = NULL;
                        CFG.pop();
                        PT->type = "NUM";
                        PT->info.refc = findintable(C,token);
                        if(PT->info.refc == NULL) {
                            cout << "***ERROR (line:" << line_number << "): Error in fetching the reference in the symbol table"<< endl;
                            exit(0);
                        }
                        PT = PT->P;
                        break_inner_loop_flag = 1;
                        break;
                    }
                    break;
                }
                case OP:{                       // Handle OP type token 
                    if(top!="OP"){
                        print_error(token);
                    }
                    PT->type = "OP";
                    PT->info.op = token;
                    CFG.pop();
                    break_inner_loop_flag = 1;
                    break;
                }
                case LP:{                       // Handle left Parenthesis type token
                    if((top!="EXPR")&&(top!="ARG")&&(top!="(")){
                        print_error(token);
                    }
                    if(top == "EXPR"){
                        CFG.pop();
                        CFG.push(")");
                        CFG.push("ARG");
                        CFG.push("ARG");
                        CFG.push("OP");
                        CFG.push("(");
                        break;
                    }
                    if(top == "ARG"){           
                        if((PT->LC!=NULL) && (PT->RC!=NULL)){
                            cout << "***ERROR (line:" << line_number << "): Too many arguments for the operator-" << yytext << endl;
                            exit(0);
                        }
                        if(PT->LC==NULL){
                            PT->LC = new treenode;
                            PT->LC->P = PT;
                            PT = PT->LC;
                            PT->LC = NULL;
                            PT->RC = NULL;
                            CFG.pop();
                            CFG.push(")");
                            CFG.push("ARG");
                            CFG.push("ARG");
                            CFG.push("OP");
                            CFG.push("(");
                            break;
                        }
                        if(PT->RC==NULL){
                            PT->RC = new treenode;
                            PT->RC->P = PT;
                            PT = PT->RC;
                            PT->LC = NULL;
                            PT->RC = NULL;
                            CFG.pop();
                            CFG.push(")");
                            CFG.push("ARG");
                            CFG.push("ARG");
                            CFG.push("OP");
                            CFG.push("(");
                            break;
                        }
                    }
                    if(top=="("){
                        if(PT==NULL){
                            PT = new treenode;
                            PT->P = NULL;
                            PT->LC = NULL;
                            PT->RC = NULL;
                        }
                        CFG.pop();
                        break_inner_loop_flag=1;
                        break;
                    }
                    break;
                }
                case RP:{                   // Handle Right Parenthesis type token
                    if(top!=")"){
                        print_error(token);
                    }
                    if(PT->P!=NULL){
                        PT = PT->P;
                        CFG.pop();
                        break_inner_loop_flag = 1;
                        break;
                    }
                    CFG.pop();
                    break_inner_loop_flag=1;
                    break;
                }
                case ERROR:{                // Handle unexpected character type token
                    cout << "***ERROR (line:" << line_number << "): An unexpected character -" << yytext << endl;
                    exit(0);
                    break;
                }
                case NL:{                   // Handle newline
                    line_number++;
                    break_inner_loop_flag=1;
                    break;
                }   
                case INV:                   // Handle a invalid operator
                    {   
                        if(top=="OP"){
                            cout << "***ERROR (line:" << line_number << "): " << "Invalid Operator "<< token <<" found" <<endl;
                            exit(0);
                        }
                        else{
                            print_error(token);
                        }
                        break;
                    }
            }
            if(break_inner_loop_flag){
                break;
            }
        }
        if(CFG.empty()){
            break;
        }
    }
    if(CFG.empty()==0){
        cout << "***ERROR (line:" << line_number << "): Expected" << CFG.top() << endl;
    }

    // Printing Generated Parse Tree
    cout << "Parsing Successful" << endl;
    print_parse_tree(PT,0);

    // Reading Inputs into the ID symbol table
    if(T!=NULL){
        cout << "Reading variable values from the Input:\n";
    }
    
    int flag = take_input_for_ids(T);
    if(flag == 0){
        cout << "***ERROR (line:" << line_number << "): Expected input for " << T->symbol_name << endl;
        exit(0);
    }

    // Verifying end of code
    while((nexttok=yylex())){
        string token = yytext;
        if(nexttok==NUM){
            cout << "***IGNORED(line:" << line_number << "): Ignored Interger:" << token <<" as all variable values have been read" << endl;
            continue;
        }
        else if(nexttok!=NL){
            cout << "***ERROR(line:" << line_number << "): Unexpected Characters at the end of the Program: "<<nexttok<< "\n";
            exit(0);
        }
        else{
            line_number++;
        }
    }

    // Evaluating and Outputing Expression
    int expression_value = evaluate(PT);
    cout << "The expression evaluates to " << expression_value << endl;
    return 0;
}