#!/bin/bash
set -e

# =============================================
# Symbol Node Build: Catapult Build Script
#
# This script configures and builds the Symbol catapult binaries using CMake and Ninja.
#
# Usage:
#   ./3_build_symbol.sh <symbol-directory>
# =============================================


# Get the symbol directory path from the command line argument
if [ $# -lt 1 ]; then
  echo "Usage: $0 <symbol-directory>"
  exit 1
fi

SYMBOL_DIR="$1"


# Create build directory and move to it
mkdir -p ${SYMBOL_DIR}/client/catapult/_build
cd ${SYMBOL_DIR}/client/catapult/_build


# Configure the build with CMake
BOOST_ROOT="$(realpath ../_temp/boost)" \
  cmake .. \
    -DENABLE_TESTS=OFF \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_PREFIX_PATH="$(realpath ../_temp/facebook);$(realpath ../_temp/google);$(realpath ../_temp/mongodb);$(realpath ../_temp/zeromq);$(realpath ../_temp/openssl)" \
    -GNinja


# Build and publish binaries
ninja publish
ninja

echo ""
echo "complete"
