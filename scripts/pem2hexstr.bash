#!/bin/bash
###############################################################################
# Script to display the private key as a hex string from a PEM file
###############################################################################


# Check if input file is specified as the first argument
if [ $# -lt 1 ]; then
  echo "Error: No input file specified." >&2
  echo "Usage: $0 <pem-file>" >&2
  exit 1
fi
INPUT_FILE="$1"

# Convert PEM to DER, extract the last 34 bytes (private key),
# print as hex, remove ASN.1 prefix, and convert to uppercase
openssl pkey -in $INPUT_FILE -outform DER \
  | tail -c 34 \
  | xxd -p -c 64 \
  | sed 's/^0420//' \
  | tr 'a-f' 'A-F'
