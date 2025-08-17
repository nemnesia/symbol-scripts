#!/bin/bash
###############################################################################
# Script to generate a PEM private key from a hex string
###############################################################################

# Prompt for the secret key (hex string) with masked input
echo -n "Enter secret key (hex string): "
read -s HEX_KEY
# Print a newline for better formatting after masked input
echo


# Check if output file is specified as the first argument
if [ $# -lt 1 ]; then
    echo "Error: No output file specified." >&2
    echo "Usage: $0 <output-pem-file>" >&2
    exit 1
fi
OUTPUT_FILE="$1"

# Combine header and secret key, convert to binary, and output as PEM
HEADER="302e020100300506032b657004220420"
echo -n "$HEADER$HEX_KEY" | xxd -r -p | openssl pkey -inform DER -out "$OUTPUT_FILE"

# Print the absolute path of the output file
ABS_PATH=$(readlink -f "$OUTPUT_FILE")
echo "PEM file written to: $ABS_PATH"
