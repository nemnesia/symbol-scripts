#!/bin/bash
set -e

# =============================================
# Symbol Node Build Dependencies Installer
#
# This script installs the required build dependencies for Symbol node.
#
# Usage:
#   ./1_install_symbol_build_deps.sh
# =============================================



# Update package list and install required packages
sudo apt update
sudo apt -y install git gcc g++ curl libssl-dev libgtest-dev ninja-build pkg-config cmake patchelf unzip crudini

echo ""
echo "complete"
