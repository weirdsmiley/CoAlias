; ModuleID = 'objects/Test-02.ll'
source_filename = "tests/Test-02.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: argmemonly nofree noinline norecurse nosync nounwind uwtable
define dso_local i32 @foo(ptr nocapture noundef %x, ptr nocapture noundef readonly %y, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp5 = icmp sgt i32 %n, 0
  br i1 %cmp5, label %for.body.preheader, label %for.end

for.body.preheader:                               ; preds = %entry
  %wide.trip.count = zext i32 %n to i64
  %min.iters.check = icmp ult i32 %n, 8
  br i1 %min.iters.check, label %for.body.preheader12, label %vector.memcheck

vector.memcheck:                                  ; preds = %for.body.preheader
  %0 = shl nuw nsw i64 %wide.trip.count, 2
  %uglygep = getelementptr i8, ptr %x, i64 %0
  %uglygep8 = getelementptr i8, ptr %y, i64 %0
  %bound0 = icmp ugt ptr %uglygep8, %x
  %bound1 = icmp ugt ptr %uglygep, %y
  %found.conflict = and i1 %bound0, %bound1
  br i1 %found.conflict, label %for.body.preheader12, label %vector.ph

vector.ph:                                        ; preds = %vector.memcheck
  %n.vec = and i64 %wide.trip.count, 4294967288
  %1 = add nsw i64 %wide.trip.count, -8
  %2 = lshr i64 %1, 3
  %3 = add nuw nsw i64 %2, 1
  %xtraiter = and i64 %3, 1
  %4 = icmp ult i64 %1, 8
  br i1 %4, label %middle.block.unr-lcssa, label %vector.ph.new

vector.ph.new:                                    ; preds = %vector.ph
  %unroll_iter = and i64 %3, -2
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph.new
  %index = phi i64 [ 0, %vector.ph.new ], [ %index.next.1, %vector.body ]
  %niter = phi i64 [ 0, %vector.ph.new ], [ %niter.next.1, %vector.body ]
  %5 = getelementptr inbounds i32, ptr %y, i64 %index
  %wide.load = load <4 x i32>, ptr %5, align 4, !alias.scope !6
  %6 = getelementptr inbounds i32, ptr %5, i64 4
  %wide.load9 = load <4 x i32>, ptr %6, align 4, !alias.scope !6
  %7 = getelementptr inbounds i32, ptr %x, i64 %index
  %wide.load10 = load <4 x i32>, ptr %7, align 4, !alias.scope !9, !noalias !6
  %8 = getelementptr inbounds i32, ptr %7, i64 4
  %wide.load11 = load <4 x i32>, ptr %8, align 4, !alias.scope !9, !noalias !6
  %9 = add nsw <4 x i32> %wide.load10, %wide.load
  %10 = add nsw <4 x i32> %wide.load11, %wide.load9
  store <4 x i32> %9, ptr %7, align 4, !alias.scope !9, !noalias !6
  store <4 x i32> %10, ptr %8, align 4, !alias.scope !9, !noalias !6
  %index.next = or i64 %index, 8
  %11 = getelementptr inbounds i32, ptr %y, i64 %index.next
  %wide.load.1 = load <4 x i32>, ptr %11, align 4, !alias.scope !6
  %12 = getelementptr inbounds i32, ptr %11, i64 4
  %wide.load9.1 = load <4 x i32>, ptr %12, align 4, !alias.scope !6
  %13 = getelementptr inbounds i32, ptr %x, i64 %index.next
  %wide.load10.1 = load <4 x i32>, ptr %13, align 4, !alias.scope !9, !noalias !6
  %14 = getelementptr inbounds i32, ptr %13, i64 4
  %wide.load11.1 = load <4 x i32>, ptr %14, align 4, !alias.scope !9, !noalias !6
  %15 = add nsw <4 x i32> %wide.load10.1, %wide.load.1
  %16 = add nsw <4 x i32> %wide.load11.1, %wide.load9.1
  store <4 x i32> %15, ptr %13, align 4, !alias.scope !9, !noalias !6
  store <4 x i32> %16, ptr %14, align 4, !alias.scope !9, !noalias !6
  %index.next.1 = add nuw i64 %index, 16
  %niter.next.1 = add i64 %niter, 2
  %niter.ncmp.1 = icmp eq i64 %niter.next.1, %unroll_iter
  br i1 %niter.ncmp.1, label %middle.block.unr-lcssa, label %vector.body, !llvm.loop !11

middle.block.unr-lcssa:                           ; preds = %vector.body, %vector.ph
  %index.unr = phi i64 [ 0, %vector.ph ], [ %index.next.1, %vector.body ]
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  br i1 %lcmp.mod.not, label %middle.block, label %vector.body.epil

vector.body.epil:                                 ; preds = %middle.block.unr-lcssa
  %17 = getelementptr inbounds i32, ptr %y, i64 %index.unr
  %wide.load.epil = load <4 x i32>, ptr %17, align 4, !alias.scope !6
  %18 = getelementptr inbounds i32, ptr %17, i64 4
  %wide.load9.epil = load <4 x i32>, ptr %18, align 4, !alias.scope !6
  %19 = getelementptr inbounds i32, ptr %x, i64 %index.unr
  %wide.load10.epil = load <4 x i32>, ptr %19, align 4, !alias.scope !9, !noalias !6
  %20 = getelementptr inbounds i32, ptr %19, i64 4
  %wide.load11.epil = load <4 x i32>, ptr %20, align 4, !alias.scope !9, !noalias !6
  %21 = add nsw <4 x i32> %wide.load10.epil, %wide.load.epil
  %22 = add nsw <4 x i32> %wide.load11.epil, %wide.load9.epil
  store <4 x i32> %21, ptr %19, align 4, !alias.scope !9, !noalias !6
  store <4 x i32> %22, ptr %20, align 4, !alias.scope !9, !noalias !6
  br label %middle.block

middle.block:                                     ; preds = %middle.block.unr-lcssa, %vector.body.epil
  %cmp.n = icmp eq i64 %n.vec, %wide.trip.count
  br i1 %cmp.n, label %for.end, label %for.body.preheader12

for.body.preheader12:                             ; preds = %vector.memcheck, %for.body.preheader, %middle.block
  %indvars.iv.ph = phi i64 [ 0, %vector.memcheck ], [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  %23 = xor i64 %indvars.iv.ph, -1
  %24 = add nsw i64 %23, %wide.trip.count
  %xtraiter13 = and i64 %wide.trip.count, 3
  %lcmp.mod14.not = icmp eq i64 %xtraiter13, 0
  br i1 %lcmp.mod14.not, label %for.body.prol.loopexit, label %for.body.prol

for.body.prol:                                    ; preds = %for.body.preheader12, %for.body.prol
  %indvars.iv.prol = phi i64 [ %indvars.iv.next.prol, %for.body.prol ], [ %indvars.iv.ph, %for.body.preheader12 ]
  %prol.iter = phi i64 [ %prol.iter.next, %for.body.prol ], [ 0, %for.body.preheader12 ]
  %arrayidx.prol = getelementptr inbounds i32, ptr %y, i64 %indvars.iv.prol
  %25 = load i32, ptr %arrayidx.prol, align 4
  %arrayidx2.prol = getelementptr inbounds i32, ptr %x, i64 %indvars.iv.prol
  %26 = load i32, ptr %arrayidx2.prol, align 4
  %add.prol = add nsw i32 %26, %25
  store i32 %add.prol, ptr %arrayidx2.prol, align 4
  %indvars.iv.next.prol = add nuw nsw i64 %indvars.iv.prol, 1
  %prol.iter.next = add i64 %prol.iter, 1
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter13
  br i1 %prol.iter.cmp.not, label %for.body.prol.loopexit, label %for.body.prol, !llvm.loop !14

for.body.prol.loopexit:                           ; preds = %for.body.prol, %for.body.preheader12
  %indvars.iv.unr = phi i64 [ %indvars.iv.ph, %for.body.preheader12 ], [ %indvars.iv.next.prol, %for.body.prol ]
  %27 = icmp ult i64 %24, 3
  br i1 %27, label %for.end, label %for.body

for.body:                                         ; preds = %for.body.prol.loopexit, %for.body
  %indvars.iv = phi i64 [ %indvars.iv.next.3, %for.body ], [ %indvars.iv.unr, %for.body.prol.loopexit ]
  %arrayidx = getelementptr inbounds i32, ptr %y, i64 %indvars.iv
  %28 = load i32, ptr %arrayidx, align 4
  %arrayidx2 = getelementptr inbounds i32, ptr %x, i64 %indvars.iv
  %29 = load i32, ptr %arrayidx2, align 4
  %add = add nsw i32 %29, %28
  store i32 %add, ptr %arrayidx2, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %arrayidx.1 = getelementptr inbounds i32, ptr %y, i64 %indvars.iv.next
  %30 = load i32, ptr %arrayidx.1, align 4
  %arrayidx2.1 = getelementptr inbounds i32, ptr %x, i64 %indvars.iv.next
  %31 = load i32, ptr %arrayidx2.1, align 4
  %add.1 = add nsw i32 %31, %30
  store i32 %add.1, ptr %arrayidx2.1, align 4
  %indvars.iv.next.1 = add nuw nsw i64 %indvars.iv, 2
  %arrayidx.2 = getelementptr inbounds i32, ptr %y, i64 %indvars.iv.next.1
  %32 = load i32, ptr %arrayidx.2, align 4
  %arrayidx2.2 = getelementptr inbounds i32, ptr %x, i64 %indvars.iv.next.1
  %33 = load i32, ptr %arrayidx2.2, align 4
  %add.2 = add nsw i32 %33, %32
  store i32 %add.2, ptr %arrayidx2.2, align 4
  %indvars.iv.next.2 = add nuw nsw i64 %indvars.iv, 3
  %arrayidx.3 = getelementptr inbounds i32, ptr %y, i64 %indvars.iv.next.2
  %34 = load i32, ptr %arrayidx.3, align 4
  %arrayidx2.3 = getelementptr inbounds i32, ptr %x, i64 %indvars.iv.next.2
  %35 = load i32, ptr %arrayidx2.3, align 4
  %add.3 = add nsw i32 %35, %34
  store i32 %add.3, ptr %arrayidx2.3, align 4
  %indvars.iv.next.3 = add nuw nsw i64 %indvars.iv, 4
  %exitcond.not.3 = icmp eq i64 %indvars.iv.next.3, %wide.trip.count
  br i1 %exitcond.not.3, label %for.end, label %for.body, !llvm.loop !16

for.end:                                          ; preds = %for.body.prol.loopexit, %for.body, %middle.block, %entry
  %36 = load i32, ptr %y, align 4
  ret i32 %36
}

attributes #0 = { argmemonly nofree noinline norecurse nosync nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 16.0.0 (https://github.com/llvm/llvm-project.git 8b38a2c0a55a9140115a91959326918d99bea435)"}
!6 = !{!7}
!7 = distinct !{!7, !8}
!8 = distinct !{!8, !"LVerDomain"}
!9 = !{!10}
!10 = distinct !{!10, !8}
!11 = distinct !{!11, !12, !13}
!12 = !{!"llvm.loop.mustprogress"}
!13 = !{!"llvm.loop.isvectorized", i32 1}
!14 = distinct !{!14, !15}
!15 = !{!"llvm.loop.unroll.disable"}
!16 = distinct !{!16, !12, !13}
