#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <sys/wait.h>
#define SIZE 1000000
int i=0;
// 1. Array vs. Pointer Access Patterns
  void demo_access_bug() {
  int *a = malloc(SIZE * sizeof(int));
  clock_t t1 = clock();
  long sum=0; // BUG: sum is uninitialized
  for(int i=0; i<sizeof(a); i++) a[i]=0;
  for (int i= 0; i< SIZE; i++)
  sum += a[i]; // BUG: a is uninitialized
  clock_t t2 = clock();
  printf("Access time: %f sec\n", (double)(t2 -t1) / CLOCKS_PER_SEC);
  free(a);
  }
// 2. Memory Leak
  void demo_leak_bug() {
  int *var = malloc(1024); // BUG: returned pointer is never saved or freed
  printf("Leaked 1 KB\n");
  free(var);
  }
// 3. Stack Overflow
  void recurse_bug(int n) {
  //int buf[100];
   i++;
  if(i==10)return; 
  recurse_bug(i); // BUG: infinite recursion
  
  }
// 4. Paging & Wrong malloc size
  void demo_paging_bug() {
  int *p = malloc(SIZE * sizeof(int)); // BUG: wrong size —should be SIZE * sizeof(int)
  p[0] = 1;
  printf("First element = %d\n", p[0]);
  free(p);
  }
int main() {
    demo_access_bug();
    demo_leak_bug();
    recurse_bug(i);
    demo_paging_bug();
  return 0;
}

