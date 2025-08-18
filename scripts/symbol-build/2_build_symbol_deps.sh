
#!/bin/sh
set -e

# =============================================
# Symbol Node Build: Dependency Installer
#
# This script builds and installs the required dependencies for Symbol node using installDepsLocal.py.
#
# Usage:
#   ./2_build_symbol_deps.sh
# =============================================


# Create temp directory and move to catapult client directory
mkdir -p ./symbol/client/catapult/_temp
cd ./symbol/client/catapult


# Run the dependency installer script
PYTHONPATH="./symbol/jenkins/catapult/" \
  python3 "./symbol/jenkins/catapult/installDepsLocal.py" \
  --target "./_temp" \
  --versions "./symbol/jenkins/catapult/versions.properties" \
  --build \
  --download

echo ""
echo "complete"
