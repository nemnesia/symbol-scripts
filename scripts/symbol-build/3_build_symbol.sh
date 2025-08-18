#!/bin/sh
set -e


SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

mkdir -p ${ROOT_DIR}/_symbol/client/catapult/_build
cd ${ROOT_DIR}/_symbol/client/catapult/_build

BOOST_ROOT="$(realpath ../_temp/boost)" \
  cmake ${ROOT_DIR}/_symbol/client/catapult \
    -DENABLE_TESTS=OFF \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_PREFIX_PATH="$(realpath ../_temp/facebook);$(realpath ../_temp/google);$(realpath ../_temp/mongodb);$(realpath ../_temp/zeromq);$(realpath ../_temp/openssl)" \
    -GNinja

ninja publish
ninja

echo ""
echo "complete"
