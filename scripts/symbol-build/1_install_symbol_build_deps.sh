#!/bin/sh
set -e


sudo apt update
sudo apt -y install git gcc g++ curl libssl-dev libgtest-dev ninja-build pkg-config cmake

echo ""
echo "complete"
