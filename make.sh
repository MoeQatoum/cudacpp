#!/bin/bash

#colors
W="\033[0;00m"
G="\033[0;92m"
R="\033[0;91m"
Y="\033[0;93m"

BUILD_DIR=$(pwd)/build
ROOT_DIR=$(pwd)
CONFIG=RELEASE
ARCH=x64
TARGET=install
CLEAN=false
# CXX_COMPILER="~/devel-tools/clang-15.0.7/bin/clang++"
# C_COMPILER="~/devel-tools/clang-15.0.7/bin/clang"
CXX_COMPILER="clang++-15"
C_COMPILER="clang-15"
CUDA_ROOT_DIR="/usr/local/cuda-12.1"

INSTALL_PREFIX=$("pwd")/out

opts=("$@")
for ((i = 0; i < $#; i++)); do
  case "${opts[$i]}" in
  --clean)
    CLEAN=true
    ;;
  --no-run)
    RUN=false
    ;;
  --prefix)
    INSTALL_PREFIX=${opts[$((i + 1))]}
    ((i++))
    ;;
  --examples)
    BUILD_EXAMPLES=true
    ;;
  --config)
    CONFIG=${opts[$((i + 1))]}
    ((i++))
    ;;
  --compiler)
    COMPILER=${opts[$((i + 1))]}
    ((i++))
    ;;
  --cuda-path)
    COMPILER=${opts[$((i + 1))]}
    ((i++))
    ;;
  --arch)
    ARCH=${opts[$((i + 1))]}
    ((i++))
    ;;
  --target)
    TARGET=${opts[$((i + 1))]}
    ((i++))
    ;;
  -j)
    if [[ ${opts[$((i + 1))]} =~ $num_re ]]; then
      JOBS="-j ${opts[$((i + 1))]}"
      ((i++))
    else
      JOBS="-j"
    fi
    ;;
  -h)
    printf "help:\n"
    printf "  --clean       Remove existing build folder.\n"
    printf "  --no-run      Build but don't run the app.\n"
    printf "  --prefix      Specify install prefix.\n"
    printf "  --config      Specify build type. Options RELEASE, DEBUG ...\n"
    printf "  --compiler    Specify compiler. Default clang\n"
    printf "  --cuda-path   Specify cuda toolkit path. Default \"/usr/local/cuda/bin/nvcc\"\n"
    printf "  --target      NOT USED. specify target.\n"
    printf "  -j            Allow N jobs at once\n"
    printf "  -h            this help.\n"
    exit 0
    ;;
  *)
    printf "\"${opts[$((i))]}\" is invalid option, -h for help.\n"
    exit 1
    ;;
  esac
done

if [ $CLEAN == true ]; then
  printf "${Y}-- Removing build folder${W}\n"
  rm -rf $BUILD_DIR
  if [[ $? -eq 1 ]]; then
    printf "${R}-- Clean Error: Build folder not found $BUILD_DIR.${W}\n"
    exit 1
  fi
  printf "${Y}-- Removing installed build${W}\n"
  rm -rf $INSTALL_PREFIX
  if [[ $? -eq 1 ]]; then
    printf "${R}-- Clean Error: install folder not found $BUILD_DIR.${W}\n"
    exit 1
  fi
fi

cmake -S $ROOT_DIR -B $BUILD_DIR \
  -D CMAKE_CXX_COMPILER=$CXX_COMPILER \
  -D CMAKE_C_COMPILER=$C_COMPILER \
  -D CMAKE_CUDA_HOST_COMPILER=$CXX_COMPILER \
  -D CMAKE_BUILD_TYPE:STRING=$CONFIG \
  -D CMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
  -D CMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE
if [[ $? -eq 1 ]]; then
  printf "${R}-- Cmake failed${W}\n" &&
    exit 1
fi

cmake --build $BUILD_DIR --target $TARGET -j -v
# ./out/cuda-playground-matsum
# ./out/cuda-playground-matmul
./out/cuda-example
