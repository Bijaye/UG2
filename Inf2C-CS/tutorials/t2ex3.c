#include <stdio.h>

int main(void){
int b=10;
int *a=new int*;
*a=100;
printf("%p",a);

return 0;
}