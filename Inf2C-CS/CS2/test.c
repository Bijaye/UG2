#include <stdio.h>
int** cache;
int n;
void init(int*** c){
  int i;
  *c=malloc (n*sizeof(int *));
  for(i=0;i<n;i++){
    *c[i]= malloc(2*sizeof(int));
    c[i][0]=0; //store valid bit
    c[i][1]=0; //store tag
  }
}
void main(){
n=5;
init(&cache);
int i;

}
