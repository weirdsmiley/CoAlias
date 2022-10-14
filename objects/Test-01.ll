; ModuleID = 'tests/Test-01.c'
source_filename = "tests/Test-01.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @foo(ptr noundef %x, ptr noundef %y) #0 {
entry:
  %x.addr = alloca ptr, align 8
  %y.addr = alloca ptr, align 8
  store ptr %x, ptr %x.addr, align 8
  store ptr %y, ptr %y.addr, align 8
  %0 = load ptr, ptr %y.addr, align 8
  %1 = load i32, ptr %0, align 4
  %add = add nsw i32 %1, 1
  %2 = load ptr, ptr %x.addr, align 8
  store i32 %add, ptr %2, align 4
  %3 = load ptr, ptr %y.addr, align 8
  %4 = load i32, ptr %3, align 4
  ret i32 %4
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @bar(ptr noundef %x) #0 {
entry:
  %x.addr = alloca ptr, align 8
  %y = alloca ptr, align 8
  store ptr %x, ptr %x.addr, align 8
  %0 = load ptr, ptr %y, align 8
  %1 = load i32, ptr %0, align 4
  %2 = load ptr, ptr %x.addr, align 8
  %3 = load i32, ptr %2, align 4
  %add = add nsw i32 %3, %1
  store i32 %add, ptr %2, align 4
  %4 = load ptr, ptr %x.addr, align 8
  %5 = load i32, ptr %4, align 4
  ret i32 %5
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @baz(ptr noundef %x) #0 {
entry:
  %x.addr = alloca ptr, align 8
  store ptr %x, ptr %x.addr, align 8
  %0 = load ptr, ptr %x.addr, align 8
  %call = call i32 @bar(ptr noundef %0)
  ret i32 %call
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %a = alloca i32, align 4
  %x = alloca ptr, align 8
  store i32 0, ptr %retval, align 4
  store i32 23, ptr %a, align 4
  store ptr %a, ptr %x, align 8
  %0 = load ptr, ptr %x, align 8
  %call = call i32 @baz(ptr noundef %0)
  ret i32 %call
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 16.0.0 (https://github.com/llvm/llvm-project.git 8b38a2c0a55a9140115a91959326918d99bea435)"}
