// RUN: %clang_cc1 -analyze -analyzer-checker=core,debug.ExprInspection %s

// %clang_cc1 -analyze -analyzer-checker=core,debug.ExprInspection %s

int foo(int *x, int *y, int n) {
  for (int i=0; i < n; ++i) {
    x[i] += y[i];
  }
  return *y;
}
