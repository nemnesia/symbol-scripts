#!/bin/sh
set -e



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


echo ""
echo "complete"
