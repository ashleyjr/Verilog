#include "oc8051.h"

void func(char i);

void main(void){
   func(10);
   PASS_TEST
}

void func(char i){
   if(0==i)
      return;
   else
      func(i-1);
}


