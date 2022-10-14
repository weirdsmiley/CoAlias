#!/bin/bash

# CC=clang
# OPT=opt
CC=~/workspace/llvm/llvm-project/build/bin/clang
OPT=~/workspace/llvm/llvm-project/build/bin/opt
CFLAGS="-Xclang -disable-O0-optnone -S -emit-llvm"
OPTFLAGS="-O2 -S"
PLUG="--load-pass-plugin=build/CoAliasPass/libLLVMCoAliasPass.so"

function run_test() {
  FILE=$(basename -- "$1")
  OUT="${FILE%.*}"
  ${CC} ${CFLAGS} ${each_test} -o objects/${OUT}.ll
  ${OPT} ${OPTFLAGS} objects/${OUT}.ll -o objects/${OUT}_opt.ll
  echo "Running pass on ${OUT}.ll"
  ${OPT} ${OPTFLAGS} ${PLUG} objects/${OUT}.ll -o objects/${OUT}_optwith.ll
  echo "Dumped ${OUT}.ll, ${OUT}_opt.ll and ${OUT}_optwith.ll"
}

if [[ ! -z $1 && $1 == "clean" ]]; then
  rm -rf ./objects/
  exit
fi

LIST_TESTS="tests/*.c"

if [[ ! -z $1 && -f $1 ]]; then
  LIST_TESTS=$1
fi

# TODO: Make this an cmdline flag to test the respective build (for e.g., there
# is build.old/, and build/)
mkdir -p build
pushd build
cmake -G Ninja .. 
ninja
popd

mkdir -p objects
for each_test in ${LIST_TESTS}; do
  run_test $each_test
done
