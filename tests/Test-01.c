// RUN: %clang -Xclang -disable-O0-optnone -S -emit-llvm %s

// %clang_cc1 -analyze -analyzer-checker=core,debug.ExprInspection %s

int foo(int *x, int *y) {
  *x = *y + 1;
  return *y;
}

int bar(int *x) {
  int *y;
  *x += *y;
  return *x;
}

int baz(int *x) {
  return bar(x);
}

int main() {
  int a = 23;
  int *x = &a;
  return baz(x);
}
