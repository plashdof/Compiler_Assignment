%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#define NUMBER 1
#define OPERATOR 2
#define ERROR 3
#define SIZE 101
%}
/* regexp definitions */
num [0-9]+
delim [ \t\n]
ws {delim}+
operator [+\-]

%%
{ws} {}
{num} { return NUMBER; }
{operator} { return OPERATOR;}
.  { return ERROR; }
%%


void printError(){
  printf("error\n");
}

int
main(){
 int token;
 
 char **answer;
 answer = (char**) malloc(sizeof(char*) * 100);
 int index = 0;

 char **op;
 op = (char**) malloc(sizeof(char*) * 100);
 int opIndex = 0;
 int opStatus = -1;
 bool opSubStatus = false;

 bool status = true; 
 int numCount = 0;


 while(token = yylex()){
  
  /* infix 아닌경우 예외처리  */
  if(numCount != 0 && numCount != 1){
      printError();
      status = false;
      break;
  }


  if(token == NUMBER){
    
    numCount++;
    answer[index] = (char*) malloc(sizeof(char) * yyleng);
    strcpy(answer[index], yytext);
    
    index++;
   
  } else if(token == OPERATOR){
    
    numCount--;

    if(opStatus == 0) {
        answer[index] = (char*) malloc(sizeof(char) * strlen(op[opIndex]));
        strcpy(answer[index], op[opIndex]);
	
     	opSubStatus = false;  
        index++;  
        opIndex++;

        op[opIndex] = (char*) malloc(sizeof(char) * yyleng);
        strcpy(op[opIndex], yytext);

	
    } else if(opStatus  == -1) { 
	op[opIndex] = (char*) malloc(sizeof(char) * yyleng);
        strcpy(op[opIndex], yytext);
	
	opSubStatus = true;

    } else { 
	printError(); 
	status = false; 
	break;  
    }

    if(opSubStatus){
	opStatus++;
    }else{
	opStatus--;
    }


  } else{
    printf("else : %s",yytext);
    printError();
    status = false;
    break;
  }
 }

 
 answer[index] = (char*) malloc(sizeof(char) * strlen(op[opIndex]));

 strcpy(answer[index], op[opIndex]);


 if(status){ 
  for(int i = 0; i <= index; i++){
    printf("%s ", answer[i]);
  }
    printf("\n");
 }


}

