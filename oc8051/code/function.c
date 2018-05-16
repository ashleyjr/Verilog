void func(char i);
void main(void){
   func(10);
   while(1);
}

void func(char i){
   if(0==i)
      return;
   else
      func(i-1);
}
