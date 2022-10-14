#ifndef COALIAS_H
#define COALIAS_H

#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/PassManager.h"
#include <llvm/ADT/ArrayRef.h>
#include <llvm/ADT/STLExtras.h>
#include <llvm/ADT/SmallVector.h>
#include <llvm/Analysis/AliasAnalysis.h>
#include <llvm/Analysis/CallGraph.h>
#include <llvm/IR/Argument.h>
#include <llvm/IR/Argument.h>
#include <llvm/IR/Attributes.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/PassManager.h>
#include <llvm/Passes/OptimizationLevel.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/Passes/PassPlugin.h>
#include <llvm/Support/Casting.h>
#include <llvm/Support/Compiler.h>
#include <llvm/Support/raw_os_ostream.h>
#include <llvm/Support/raw_ostream.h>
#include <utility>
using namespace llvm;

namespace coalias {

// This class will store all information computed by analysis pass which is
// required by the transformation. 
// TODO: Do we actually require this? Or can we work fine by using struct Result.
class CoAliasInfo {
  bool Modified;
  SmallVector<Argument *, 0> VArgs;
  SmallVector<SmallVector<Argument *, 0>> NoAliasArgs;
};

// This is the analysis class for coalias analysis. Given a function F, it will
// collect all call instructions in it, and check which all arguments are
// statically not aliasing with each other.
class CoAliasAnalysis : public AnalysisInfoMixin<CoAliasAnalysis> {
  friend AnalysisInfoMixin<CoAliasAnalysis>;
  static AnalysisKey Key;

public:
  // TODO: Move this to class and that will ensure we are not making everything
  // public. Only the APIs which this class will provide.
  struct Result {
    bool Modified;
    SmallVector<Argument *, 0> VArgs;
    SmallVector<SmallVector<Argument *, 0>> NoAliasArgs;
  };

  // using Result = CoAliasInfo;

  Result run(Function &F, FunctionAnalysisManager &AM);
  static StringRef name() { return "CoAliasAnalysis"; }
};

// This class is a printer for coalias analysis.
struct CoAliasPrinterPass : public PassInfoMixin<CoAliasPrinterPass> {
  CoAliasPrinterPass(raw_ostream &OS) : OS(OS) {}

  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM);

  private:
    raw_ostream &OS;
};

// This class transforms the IR, by first cloning the corresponding function,
// and then adding 'nocoalias' attribute to selected parameters.
struct CoAliasPass : public PassInfoMixin<CoAliasPass> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM);
};

};

#endif /* end of COALIAS_H */
