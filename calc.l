%{
#include "y.tab.h"
#include "node.h"
void yyerror (char *s);
int yylex();

struct variable** vars[52] = {NULL};

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 

struct variable* make_variable_from_num(int n)
{
	struct variable* var = malloc(sizeof(struct variable));
	var->t = num;
	var->num = n;
	return var;
}

struct variable* make_variable_from_id(char id)
{
    int index = computeSymbolIndex(id);
    if(vars[index])
        return vars[index];
	struct variable* var = malloc(sizeof(struct variable));
    var->addr = 2000 + 4*computeSymbolIndex(id);
	var->t = vari;
	var->id = id;
    vars[index] = var;
	return var;
}

%}
%%
"print"				   {return print;}
"exit"				   {return exit_command;}
[a-zA-Z]			   {yylval.var = make_variable_from_id(yytext[0]); return identifier;}
[0-9]+                 {yylval.var = make_variable_from_num(atoi(yytext)); return number;}
[ \t\n]                ;
[-+*/=;]           	   {return yytext[0];}
.                      {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}

