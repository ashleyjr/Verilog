#include "oc8051.h"

__xdata __at (0x0) unsigned int f;

unsigned int fib(unsigned int n);

void main(void){
   unsigned int i; 
   for(i=0;i<10;i++){
      f = fib(i);
   }
   PASS_TEST
}

unsigned int fib(unsigned int  n){
   if(0==n)
      return 0;
   if(1==n)
      return 1;
   return fib(n-1) + fib(n-2);
}
