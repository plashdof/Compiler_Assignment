%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#define NUMBER 1
#define OPERATOR 2
#define ERROR 3
#define ERRORINVALID 4
#define SIZE 101
%}
/* regexp definitions */
num [1-9][0-9]*
delim [ \t\n]
ws {delim}+
operator [+\-]

%%
{ws} {}
{num} { return NUMBER; }
{operator} { return OPERATOR;}
0[0-9]*  { return ERROR; }
. { return ERRORINVALID; }
%%


void printError(){
  printf("error\n");
}

int
main(){
 int token;
 
 /* postfix representation 이차원배열  */
 char **answer;
 answer = (char**) malloc(sizeof(char*) * 100);
 int index = 0;
 
 /* operation 출력 순서를 위한, 이차원배열 stack 구조  */
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
      printf("not infix\n");
      status = false;
      break;
  }

  /* 정수일 경우 */
  if(token == NUMBER){
    
    numCount++;
    answer[index] = (char*) malloc(sizeof(char) * yyleng);
    strcpy(answer[index], yytext);
    
    index++;
   
  } else if(token == OPERATOR){
  
  /* 연산자일 경우  */
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


  } else if(token == ERROR){
	
    /* 0으로 시작하는 정수 예외처리  */
    printError();
    printf("remove front 0\n");
    status = false;
    break;
  } else{

    /* 정수나 +,- 연산자가 아닌경우 예외처리 */
    printError();
    printf("invalid value\n");
    status = false;
    break;
  }
 }


 if(status){ 
 
  answer[index] = (char*) malloc(sizeof(char) * strlen(op[opIndex]));

  strcpy(answer[index], op[opIndex]);

  
  for(int i = 0; i <= index; i++){
    printf("%s ", answer[i]);
  }
    printf("\n");
 }


}

