#include "oc8051.h"

__xdata __at (0x0) char f;

char fib(char n);

void main(void){
   char i; 
   for(i=0;i<10;i++){
      f = fib(i);
   }
   PASS_TEST
}

char fib(char n){
   if(0==n)
      return 0;
   if(1==n)
      return 1;
   return fib(n-1) + fib(n-2);
}
