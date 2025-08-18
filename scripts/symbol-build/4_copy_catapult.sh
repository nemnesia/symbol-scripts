
#!/bin/sh
set -e

# =============================================
# Symbol Node Catapult/Rest Copy Script
#
# This script copies the built catapult binaries, libraries, and dependencies,
# as well as the rest directory, to /opt/symbol-node.
#
# Usage:
#   ./4_copy_catapult.sh [BASE_PATH]
#
# If BASE_PATH is specified, catapult and rest directories are searched under BASE_PATH.
# If not specified, the script searches for catapult/rest directories under the current directory.
# =============================================


# Get the symbol directory path from the command line argument
if [ $# -lt 1 ]; then
  echo "Usage: $0 <symbol-directory>"
  exit 1
fi

SYMBOL_DIR="$1"

# Copy binaries
mkdir -p /opt/symbol-node/bin
cp ${SYMBOL_DIR}/client/catapult/_build/bin/catapult* /opt/symbol-node/bin

# Copy libraries
mkdir -p /opt/symbol-node/lib
cp ${SYMBOL_DIR}/client/catapult/_build/bin/lib* /opt/symbol-node/lib

# Copy dependencies
mkdir -p /opt/symbol-node/deps
cp -r ${SYMBOL_DIR}/client/catapult/_temp/boost/lib/*.so* /opt/symbol-node/deps
cp -r ${SYMBOL_DIR}/client/catapult/_temp/facebook/lib/*.so* /opt/symbol-node/deps
cp -r ${SYMBOL_DIR}/client/catapult/_temp/mongodb/lib/*.so* /opt/symbol-node/deps
cp -r ${SYMBOL_DIR}/client/catapult/_temp/openssl/*.so* /opt/symbol-node/deps
cp -r ${SYMBOL_DIR}/client/catapult/_temp/openssl/*.cnf* /opt/symbol-node/deps
cp -r ${SYMBOL_DIR}/client/catapult/_temp/openssl/engines-3 /opt/symbol-node/deps
cp -r ${SYMBOL_DIR}/client/catapult/_temp/openssl/ossl-modules /opt/symbol-node/deps
cp -r ${SYMBOL_DIR}/client/catapult/_temp/zeromq/lib/*.so* /opt/symbol-node/deps

# Copy rest directory
cp -r ${SYMBOL_DIR}/client/rest /opt/symbol-node

echo ""
echo "complete"
