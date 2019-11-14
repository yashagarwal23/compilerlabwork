%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include "node.h"

int tempvarcount = 0;

%}

%union {struct variable* var;}         /* Yacc definitions */
%start line
%token print
%token exit_command
%token <var> number
%token <var> identifier
%type <var> line exp 
%type <var> term 
%type <var> assignment

%%

/* descriptions of expected inputs     corresponding actions (in C) */

line    : assignment ';'		{;}
		| exit_command ';'		{printf("HLT\n"); exit(EXIT_SUCCESS);}
		| print exp ';'			{printf("Print {%c} : ",$2->id); printf("%d\n", $2->num);}
		| line assignment ';'	{;}
		| line print exp ';'	{printf("Print {%c} : ",$3->id); printf("%d\n", $3->num);}
		| line exit_command ';'	{printf("HLT\n"); exit(EXIT_SUCCESS);}
        ;

assignment : identifier '=' exp { 
									assign($1, $3);	
								}
			;
exp    	: term                  {
									$$ = $1;
								}
       	| exp '+' term          {
			   						load($3);
									printf("MOV C,A\n");
									load($1);
									printf("ADD C\n");
									struct variable* tmp = func($1, $3, '+');
									store(tmp);
									$$ = tmp;
		   						}
       	| exp '-' term          {
			   						load($3);
									printf("MOV C,A\n");
									load($1);
									printf("SUB C\n");
									struct variable* tmp = func($1, $3, '-');
									store(tmp);
									$$ = tmp;
		   						}
		| exp '*' term          {
			   						load($3);
									printf("MOV C,A\n");
									load($1);
									printf("MUL C\n");
									struct variable* tmp = func($1, $3, '*');
									store(tmp);
									$$ = tmp;
		   						}
       	| exp '/' term          {
			   						load($3);
									printf("MOV C,A\n");
									load($1);
									printf("DIV C\n");
									struct variable* tmp = func($1, $3, '/');
									store(tmp);
									$$ = tmp;
		   						}
       	;

term   	: number                {	
									$$ = $1;
								}
		| identifier			{
									$$ = $1;
								}
        ;

%%                     /* C code */

void assign(struct variable* var1, struct variable* var2)
{
	load(var2);
	store(var1);
	var1->num = var2->num;
}

struct variable* func(struct variable* var1, struct variable* var2, char op)
{
	struct variable* tmp = malloc(sizeof(struct variable));
	tmp->t = tempvar;
	switch (op)
	{
		case '+' : tmp->num = var1->num + var2->num;
					break;
		case '-' : tmp->num = var1->num - var2->num;
					break;
		case '*' : tmp->num = var1->num * var2->num;
					break;
		case '/' : tmp->num = var1->num / var2->num;
					break;
	}
	tmp->addr = 3000 + 4*(tempvarcount++);
	return tmp;
}

void load(struct variable* var)
{
	if(var->t == num)
		printf("MVI %d\n", var->num);
	else
		printf("LDA %d\n", var->addr);
}

void store(struct variable* var)
{
	if(var->t == num);
	else
		printf("STA %d\n", var->addr);
}

int main (void) 
{
	return yyparse ();
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 