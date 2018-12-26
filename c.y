%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *fp;

%}

%token INT FLOAT CHAR DOUBLE VOID
%token FOR WHILE 
%token IF ELSE PRINTF 
%token STRUCT 
%token NUM ID
%token INCLUDE
%token DOT

%right '='
%left AND OR
%left '<' '>' LE GE EQ NE LT GT
%%

start:	Function 
	| Declaration
	;

/* Declaration block */
Declaration: Type Assignment ';' 
	| Assignment ';'  	
	| FunctionCall ';' 	
	| ArrayUsage ';'	
	| Type ArrayUsage ';'   
	| StructStmt ';'	
	| error	
	;

/* Assignment block */
Assignment: ID '=' Assignment	/* a = c or a = 10 */
	| ID '=' FunctionCall	/* x=afficher(x,y) */
	| ID '=' ArrayUsage	/* var=tab[45,a,b] */
	| ArrayUsage '=' Assignment	/*  */
	| ID ',' Assignment	/* a,b,c,10 */
	| NUM ',' Assignment	
	| ID '+' Assignment
	| ID '-' Assignment
	| ID '*' Assignment	/* a*b or a*8 */
	| ID '/' Assignment	
	| NUM '+' Assignment	/* 10+a or 10+8 */
	| NUM '-' Assignment
	| NUM '*' Assignment
	| NUM '/' Assignment
	| '(' Assignment ')'	/* (a+b)*c */
	| '-' '(' Assignment ')'  /* -(var) or -(10) or -(var=function(x)) */
	| '-' NUM	/* -8080 */
	| '-' ID	/* -var */
	|   NUM		/* 8080 */
	|   ID		/* var */
	;

/* Function Call Block */
FunctionCall : ID'('')'		/* afficher() */
	| ID'('Assignment')'	/* afficher(x,y) */
	;

/* Array Usage */
ArrayUsage : ID'['Assignment']' /* tab[45,a,b] */
	;

/* Function block */
Function: Type ID '(' ArgListOpt ')' CompoundStmt	 /* int afficher(x,y){ printf(x+y); } */
	;
ArgListOpt: ArgList	/* int a,int b,float c */
	|
	;
ArgList:  ArgList ',' Arg	/* int a,int b,float c */
	| Arg			/* char c */
	;
Arg:	Type ID		/* int a */
	;
CompoundStmt:	'{' StmtList '}'	/* {if(a==b) a=b+10;} */ 
	;
StmtList:	StmtList Stmt
	|
	;
Stmt:	WhileStmt
	| Declaration
	| ForStmt
	| IfStmt
	| PrintFunc
	| ';'
	;

/* Type Identifier block */
Type:	INT 
	| FLOAT
	| CHAR
	| DOUBLE
	| VOID 
	;

/* Loop Blocks */ 
WhileStmt: WHILE '(' Expr ')' Stmt	/* while(i==1) a=b; */
	| WHILE '(' Expr ')' CompoundStmt /* while(i==1) {a=b; c=a;} */
	;

/* For Block */
ForStmt: FOR '(' Expr ';' Expr ';' Expr ')' Stmt  /* for(int a=1 ;a<n;a++) c=b; */
       | FOR '(' Expr ';' Expr ';' Expr ')' CompoundStmt  /* for(int a=1 ;a<n;a++) {c=b; d=c; } */
	;

/* IfStmt Block */
IfStmt : IF '(' Expr ')' /* if(i==1) printf(c); */
	 	Stmt 
	;

/* Struct Statement */
StructStmt : STRUCT ID '{' Type Assignment '}'   /* struct valeur { int a ; }  */
	;

/* Print Function */
PrintFunc : PRINTF '(' Expr ')' ';'  /* printf(a);  */
	;

/*Expression Block*/
Expr:	
	| Expr LE Expr 
	| Expr GE Expr
	| Expr NE Expr
	| Expr EQ Expr
	| Expr GT Expr
	| Expr LT Expr
	| Assignment
	| ArrayUsage
	;
%%
#include"lex.yy.c"
#include<ctype.h>
int count=0;

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	
   if(!yyparse())
		printf("\nParsing complete\n");
	else
		printf("\nParsing failed\n");
	
	fclose(yyin);
    return 0;
}
         
yyerror(char *s) {
	FILE *fich = fopen("erreur.txt","w");
	fprintf(fich , "%d : %s %s\n", yylineno, s, yytext );
	printf("%d : %s %s\n", yylineno, s, yytext );
	fclose(fich);
	exit(1);
}         

