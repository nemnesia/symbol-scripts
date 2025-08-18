
#!/bin/sh
set -e

# =============================================
# Symbol Node Build: Catapult Build Script
#
# This script configures and builds the Symbol catapult binaries using CMake and Ninja.
#
# Usage:
#   ./3_build_symbol.sh
# =============================================



SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"


# Create build directory and move to it
mkdir -p ${ROOT_DIR}/_symbol/client/catapult/_build
cd ${ROOT_DIR}/_symbol/client/catapult/_build


# Configure the build with CMake
BOOST_ROOT="$(realpath ../_temp/boost)" \
  cmake ${ROOT_DIR}/_symbol/client/catapult \
    -DENABLE_TESTS=OFF \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_PREFIX_PATH="$(realpath ../_temp/facebook);$(realpath ../_temp/google);$(realpath ../_temp/mongodb);$(realpath ../_temp/zeromq);$(realpath ../_temp/openssl)" \
    -GNinja


# Build and publish binaries
ninja publish
ninja

echo ""
echo "complete"
