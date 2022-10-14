#include <stdlib.h>

int foo(int *x, int *y) {
  return *x > *y ? *x : *y;
}

int main(int argc, char **argv) {
  int a = 1;
  int *x, *y = (int*)malloc(sizeof(int));
  x = &a;
  y = &a;
  return foo(x, y);
}

