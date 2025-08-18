
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


# Specify the path to the symbol repository as a command-line argument, or search automatically if not provided.

# If a command-line argument is given, treat it as the base directory containing catapult/rest.
if [ -n "$1" ]; then
	BASE_PATH="$1"
	SYMBOL_REPO_PATH="$BASE_PATH/catapult"
	REST_REPO_PATH="$BASE_PATH/rest"
	if [ ! -d "$SYMBOL_REPO_PATH" ]; then
		echo "$SYMBOL_REPO_PATH not found. catapult directory is required." >&2
		exit 1
	fi
	if [ ! -d "$REST_REPO_PATH" ]; then
		echo "$REST_REPO_PATH not found. rest directory is required." >&2
		exit 1
	fi
else
	# Search for catapult directory under the current directory
	SYMBOL_REPO_PATH=$(find . -type d -name catapult 2>/dev/null | head -n 1)
	if [ -z "$SYMBOL_REPO_PATH" ]; then
		echo "catapult directory not found. Please specify the path." >&2
		exit 1
	fi
	REST_REPO_PATH="$(dirname "$SYMBOL_REPO_PATH")/rest"
	if [ ! -d "$REST_REPO_PATH" ]; then
		# If not found, also search for rest directory under the current directory
		REST_REPO_PATH=$(find . -type d -name rest 2>/dev/null | head -n 1)
		if [ -z "$REST_REPO_PATH" ]; then
		echo "rest directory not found." >&2
		exit 1
		fi
	fi
fi

# Copy binaries
mkdir -p /opt/symbol-node/bin
cp ${SYMBOL_REPO_PATH}/_build/bin/catapult* /opt/symbol-node/bin

# Copy libraries
mkdir -p /opt/symbol-node/lib
cp ${SYMBOL_REPO_PATH}/_build/bin/lib* /opt/symbol-node/lib

# Copy dependencies
mkdir -p /opt/symbol-node/deps
cp -r ${SYMBOL_REPO_PATH}/_temp/boost/lib/*.so* /opt/symbol-node/deps
cp -r ${SYMBOL_REPO_PATH}/_temp/facebook/lib/*.so* /opt/symbol-node/deps
cp -r ${SYMBOL_REPO_PATH}/_temp/mongodb/lib/*.so* /opt/symbol-node/deps
cp -r ${SYMBOL_REPO_PATH}/_temp/openssl/*.so* /opt/symbol-node/deps
cp -r ${SYMBOL_REPO_PATH}/_temp/openssl/*.cnf* /opt/symbol-node/deps
cp -r ${SYMBOL_REPO_PATH}/_temp/openssl/engines-3 /opt/symbol-node/deps
cp -r ${SYMBOL_REPO_PATH}/_temp/openssl/ossl-modules /opt/symbol-node/deps
cp -r ${SYMBOL_REPO_PATH}/_temp/zeromq/lib/*.so* /opt/symbol-node/deps

# Copy rest directory
cp -r ${REST_REPO_PATH} /opt/symbol-node

echo ""
echo "complete"
