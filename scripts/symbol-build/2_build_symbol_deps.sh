
#!/bin/sh
set -e

# =============================================
# Symbol Node Build: Dependency Installer
#
# This script builds and installs the required dependencies for Symbol node using installDepsLocal.py.
#
# Usage:
#   ./2_build_symbol_deps.sh <symbol-directory>
# =============================================


# Get the symbol directory path from the command line argument
if [ $# -lt 1 ]; then
  echo "Usage: $0 <symbol-directory>"
  exit 1
fi

SYMBOL_DIR="$1"

# Create the temporary directory and move to the catapult client directory
mkdir -p "$SYMBOL_DIR/client/catapult/_temp"
cd "$SYMBOL_DIR/client/catapult"

# Run the dependency installer script
PYTHONPATH="$SYMBOL_DIR/jenkins/catapult/" \
  python3 "../../jenkins/catapult/installDepsLocal.py" \
  --target "./_temp" \
  --versions "../../jenkins/catapult/versions.properties" \
  --build \
  --download

echo ""
echo "complete"
