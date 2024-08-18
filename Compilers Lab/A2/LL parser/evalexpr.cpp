#include <iostream>
#include <bits/stdc++.h>
#include "lex.yy.c"
using namespace std;
#define COUNT 10

typedef struct _node
{
    char* token_name;
    int value;
    struct _node *next;
} node;
typedef node *symboltable;

symboltable addtbl(symboltable T, char *id)
{
    node *p;

    p = T;
    while (p)
    {
        if (!strcmp(p->token_name, id))
        {
            return T;
        }
        p = p->next;
    }
    p = (node *)malloc(sizeof(node));
    p->token_name = (char *)malloc((strlen(id) + 1) * sizeof(char));
    p->value = 0;
    strcpy(p->token_name, id);
    p->next = T;
    return p;
}
void printtable(symboltable T)
{
    node *p;

    p = T;
    while (p)
    {
        printf("%s", p->token_name);
        std::cout << std::endl;
        p = p->next;
    }
    std::cout << std::endl;
}
symboltable find_node(symboltable T, char *id)
{
    node *p;
    p = T;
    while (p)
    {
        if (!strcmp(p->token_name, id))
        {
            return p;
        }
        p = p->next;
    }
    return NULL;
}

symboltable ids = NULL;
symboltable nums = NULL;

typedef struct treenode
{
    int type;
    symboltable attribute;
    treenode *LC;
    treenode *RC;
    treenode *P;
} treenode;

typedef treenode *parsetree;

// typedef struct stack{
//     parsetree p;
//     int top;
// }

// parsetree
// top(stack s)

void PrintStack(stack<parsetree> s)
{

    if (s.empty())
        return;

    parsetree x = s.top();
    s.pop();
    PrintStack(s);
    cout << x->type << " " << x->attribute->token_name << endl;
    s.push(x);
}

std::stack<parsetree> reduce(std::stack<parsetree> s)
{
    if (s.size() >= 3)
    {
        cout << "Tried printing Stack" << endl;
        PrintStack(s);

        parsetree temp1 = s.top();
        cout << "Value of Temp1 type: " << temp1->type << endl;
        s.pop();
        parsetree temp2 = s.top();
        cout << "Value of Temp2 type: " << temp2->type << endl;
        s.pop();
        if ((temp1->type != 3) && (temp2->type != 3))
        {
            parsetree temp3 = s.top();
            s.pop();
            if (temp3->type != 3)
            {
                cout << "Value of temp3 type: " << temp3->type << endl;
                std::cout << "ERROR more than three arguments to an operation" << std::endl;
                std::exit(0);
            }
            temp2->P = temp3;
            temp1->P = temp3;

            temp3->LC = temp2;
            temp3->RC = temp1;
            temp3->type = 6;
            s.push(temp3);
            s = reduce(s);
            return s;
        }
    }
    return s;
}

// Printing a parsed tree;
void print2DUtil(parsetree root, int space)
{

    if (root == NULL)
        return;

    space += COUNT;

    print2DUtil(root->RC, space);

    printf("\n");
    for (int i = COUNT; i < space; i++)
        printf(" ");
    printf("%d\n", root->type);
    printf("%s\n", root->attribute->token_name);

    print2DUtil(root->LC, space);
}

// Wrapper over print2DUtil()
void print2D(parsetree root)
{
    print2DUtil(root, 0);
}

string get_token_name(char *y)
{
    char *token_name;
    token_name= (char *)malloc((strlen(y) + 1) * sizeof(char));
    
}

int main()
{
    int nextok;
    std::stack<parsetree> s;
    while ((nextok = yylex()))
    {
        s = reduce(s);
        parsetree temp = (treenode *)malloc(sizeof(treenode));
        symboltable tp = (node *)malloc(sizeof(node));
        cout << "Next Token Intake" << endl;
        switch (nextok)
        {
        case ID:
            ids = addtbl(ids, yytext);
            temp->type = 1;
            temp->attribute = find_node(ids, yytext);
            if (temp->attribute == NULL)
            {
                std::cout << "ERROR in finding the attribute of " << yytext << " in the symboltable" << std::endl;
            }
            temp->P = NULL;
            temp->LC = NULL;
            temp->RC = NULL;
            cout << temp->type << endl;
            cout << temp->attribute->token_name << endl;

            s.push(temp);
            break;
        case OP:
            ids = addtbl(ids, yytext);
            temp->type = 3;

            tp->token_name = get_token_name(yytext);
            tp->value = 0;
            tp->next = NULL;

            temp->attribute = tp;
            temp->P = NULL;
            temp->LC = NULL;
            temp->RC = NULL;
            cout << temp->type << endl;
            cout << temp->attribute->token_name << endl;
            s.push(temp);
            cout << "Try Try but don't cry" << endl;
            PrintStack(s);
            break;
        case NUM:
            nums = addtbl(nums, yytext);
            temp->type = 2;
            temp->attribute = find_node(nums, yytext);
            if (temp->attribute == NULL)
            {
                std::cout << "ERROR in finding the attribute of " << yytext << " in the symboltable" << std::endl;
            }
            temp->P = NULL;
            temp->LC = NULL;
            temp->RC = NULL;
            cout << temp->type << endl;
            cout << temp->attribute->token_name << endl;
            s.push(temp);
            break;
        case LP:
            break;
        case RP:
            break;
        }
    }
    printtable(ids);
    printtable(nums);
}