#include "CoAliasPass.h"

namespace coalias {

// Collect all access paths in a module
class AccessPaths {
  Function &F;
  SmallVector<Argument *, 4> *AccP;

public:
  SmallVector<Argument*, 4> findAccessPaths(Function &F) {
    for (auto &B: F) {
      for (auto &I: B) {
        // If I in CallInst, then first collect all arguments of call-site
        if (auto *CI = dyn_cast<CallInst>(&I)) {
          // Collect all function arguments
          Function *CalledFunc = I.getFunction();
          SmallVector<Argument *, 4> CIArgs;
          for (auto &ArgIter : CalledFunc->args()) {
            CIArgs.push_back(&ArgIter);
            errs() << ArgIter << "\t";
          }
        }
      }
    }
  }


  AccessPaths(Function &F) : F(F), AccP(nullptr) { }
};

// // This class with store 
// class CoAliasInfo {
//   bool Modified;
//   SmallVector<Argument *, 0> VArgs;
//   SmallVector<SmallVector<Argument *, 0>> NoAliasArgs;
// };

// This method implements what the pass does
void visitor(Module &M, ModuleAnalysisManager &MAM) {
    errs() << "(llvm-tutor) Hello from: "<< M.getName() << "\n";
    for (auto &F: M) {
      AccessPaths *AP = new AccessPaths(F);
      auto CIArgs = AP->findAccessPaths(F);
      auto &AA = MAM.getResult<AAManager>(M);

      // check for aliasing 
      for (auto X : CIArgs) {
        for (auto Y : CIArgs) {
          if (X != Y) {
            if (AA.alias(X, Y) == AliasResult::NoAlias) {
              // copy function and replace call-site
            }
          }
        }
      }
    }
}

CoAliasAnalysis::Result CoAliasAnalysis::run(Function &F,
                                             FunctionAnalysisManager &FAM) {

  outs() << "Analyzing function " << F.getName() << "\n";
  return CoAliasAnalysis::Result();
}

PreservedAnalyses CoAliasPrinterPass::run(Function &F,
                                          FunctionAnalysisManager &FAM) {
  // auto &CAI = FAM.getResult<CoAliasAnalysis>(F);
  OS << "'CoAlias Analysis' for function '" << F.getName() << "':\n";

  return PreservedAnalyses::all();
}

PreservedAnalyses CoAliasPass::run(Function &F, FunctionAnalysisManager &FAM ) {
  outs() << "Transforming the function " << F.getName() << "\n";
  return PreservedAnalyses::none();
}

};

void registerAnalysis(FunctionAnalysisManager &FAM) {
  FAM.registerPass([] { return coalias::CoAliasAnalysis(); });
}

bool registerPipeline(StringRef Name, FunctionPassManager &FPM,
                      ArrayRef<PassBuilder::PipelineElement>) {
    if (Name == "print<co-alias>") {
        FPM.addPass(coalias::CoAliasPrinterPass(errs()));
        return true;
    }

    if (Name == "co-alias") {
        FPM.addPass(coalias::CoAliasPass());
        return true;
    }

    return false;
}


PassPluginLibraryInfo getCoAliasPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "CoAlias", LLVM_VERSION_STRING,
    [](PassBuilder &PB) {
      // 1. Register CoAliasAnalysis so that other analyses can get its results
      //    from getResult<CoAliasAnalysis>
      // 2. Register CoAliasPass, the transformation pass.
      PB.registerAnalysisRegistrationCallback(registerAnalysis);

      PB.registerPipelineParsingCallback(registerPipeline);

            // using PipelineElement = typename PassBuilder::PipelineElement;
            // PB.registerPipelineStartEPCallback(
            //     [](ModulePassManager &MPM, OptimizationLevel OL) {
            //       if (OL.getSpeedupLevel() >= 2) {
            //         MPM.addPass();
            //       }
            //     });
    }};
}

// The public entry point for a pass plugin:
extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
    return getCoAliasPluginInfo();
}
