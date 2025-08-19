
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

# link
for f in "/opt/symbol-node/bin/"*; do
  if [ -f "$f" ] && [ ! -L "$f" ]; then
    echo "patchelf --set-rpath '\$ORIGIN/../deps' $f"
    patchelf --set-rpath '$ORIGIN/../deps' "$f"
  fi
done

for f in "/opt/symbol-node/deps/"*.so*; do
  if [ -f "$f" ] && [ ! -L "$f" ]; then
    echo "patchelf --set-rpath '\$ORIGIN' $f"
    patchelf --set-rpath '$ORIGIN' "$f"
  fi
done


mkdir -p /opt/symbol-node/logs
mkdir -p /opt/symbol-node/data/data
mkdir -p /opt/symbol-node/data/mongo
mkdir -p /opt/symbol-node/scripts
mkdir -p /opt/symbol-node/certificates
mkdir -p /opt/symbol-node/votingkeys

chown symbol:symbol /opt/symbol-node/logs
chown symbol:symbol -R /opt/symbol-node/data

chmod 700 /opt/symbol-node/certificates
chmod 700 /opt/symbol-node/votingkeys


echo ""
echo "complete"
