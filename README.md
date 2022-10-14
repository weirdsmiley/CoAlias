# CoAlias

This pass will transform LLVM IR by introducing a cloned function for which we
can statically deduce that its arguments are not aliasing.

