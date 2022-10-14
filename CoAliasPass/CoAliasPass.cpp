#include "CoAliasPass.h"

namespace coalias {

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
