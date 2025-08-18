#!/bin/sh
set -e


SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

mkdir -p ${ROOT_DIR}/_symbol/client/catapult/_temp
cd ${ROOT_DIR}/_symbol/client/catapult

PYTHONPATH="${ROOT_DIR}/_symbol/jenkins/catapult/" \
  python3 "${ROOT_DIR}/_symbol/jenkins/catapult/installDepsLocal.py" \
  --target "./_temp" \
  --versions "${ROOT_DIR}/_symbol/jenkins/catapult/versions.properties" \
  --build \
  --download

echo ""
echo "complete"
