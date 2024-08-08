#include <iostream>
#include <bits/stdc++.h>
#include <stdlib.h>
#include <string.h>
#include "lex.yy.c"

// structure
typedef struct _node
{
    char *token_name;
    int cnt;
    struct _node *next;
} node;
typedef node *symboltable;

// adding to linked list
symboltable addtbl(symboltable T, char *id)
{
    node *p;

    p = T;
    while (p)
    {
        if (!strcmp(p->token_name, id))
        {
            p->cnt++;
            return T;
        }
        p = p->next;
    }
    p = (node *)malloc(sizeof(node));
    p->token_name = (char *)malloc((strlen(id) + 1) * sizeof(char));
    p->cnt = 1;
    strcpy(p->token_name, id);
    p->next = T;
    return p;
}

// printing the table of evironments and commands
void printtable(symboltable T)
{
    node *p;
    p = T;
    if (!(p))
    {
        return;
    }
    printtable(p->next);
    printf("%s", p->token_name);
    std::cout << " (" << p->cnt << ")" << std::endl;
}

// main function
int main()
{
    int nextok;
    symboltable commands = NULL;
    symboltable environment = NULL;

    int maths_equation = 0;
    int displayed_maths_equation = 0;
    int flag = 0;
    int md = 0;
    int display_math_2 = 0;
    while ((nextok = yylex()))
    {
        switch (nextok)
        {
        case DMF:
            displayed_maths_equation++;
            break;
        case MF:
            maths_equation++;
        case CMD:
            if(!strcmp(yytext,"$")){
                continue;
            }
            commands = addtbl(commands, yytext);
            break;
        case BGN:
            flag = 1;
            break;
        case COM:
            break;
        case END:
            break;
        case ALP:
            if (flag)
            {
                environment = addtbl(environment, yytext);
                flag = 0;
            }
            break;
        case MDO:
            md = 1;
            break;
        case MDF:
            if (md == 1)
            {
                display_math_2++;
                md = 0;
            }
            break;
        }
    }
    std::cout << "Commands used:" << std::endl;
    printtable(commands);
    std::cout << std::endl; 
    std::cout << "Environments used:" << std::endl;
    printtable(environment);
    std::cout << (maths_equation / 2) << " math equations found" << std::endl;
    std::cout << (displayed_maths_equation / 2) + display_math_2 << " displayed equations found" << std::endl;
    exit(0);
}