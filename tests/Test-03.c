#include <stdlib.h>

int foo(int *x, int *y) {
  return *x > *y ? *x : *y;
}

int main() {
  int a = 1, b = 2;
  int *x, *y = (int*)malloc(sizeof(int));

  if (1) {
    x = &a;
    y = &b;
  }
  y = &a;
  return foo(x, y);
}
