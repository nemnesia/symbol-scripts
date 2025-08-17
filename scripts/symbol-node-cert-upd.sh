#!/bin/bash
###############################################################################
### Symbol Node Certificate Update Script
###############################################################################

# Default values
NODE_DAYS=375
NODE_CN="Symbol Node"

# Parse options
while getopts "n:N:" opt; do
  case "$opt" in
    n) NODE_DAYS="$OPTARG" ;;
    N) NODE_CN="$OPTARG" ;;
    *) echo "Usage: $0 [-n Node certificate days] [-N Node certificate name]"; exit 1 ;;
  esac
done

# Change to certificates directory
cd certificates

# Check if CA key, certificate, and config exist
if [ ! -f ca.key.pem ] || [ ! -f ca.cert.pem ] || [ ! -f ca.cnf ]; then
  echo "CA key, certificate, or config file not found. Please create them first."
  exit 1
fi

# Check if CA management files exist
if [ ! -f serial.dat ] || [ ! -f index.txt ]; then
  echo "CA management files (serial.dat, index.txt) not found. Please create them first."
  exit 1
fi

# Check if node.key.pem exists
if [ ! -f node.key.pem ]; then
  echo "node.key.pem not found. Existing private key is required."
  exit 1
fi

# Create directory for new certificates
mkdir -p new_certs

# Regenerate Node certificate, CSR, and config file

echo "[req]
prompt = no
distinguished_name = dn

[dn]
CN = $NODE_CN" > node.cnf

openssl req -new -config node.cnf -key node.key.pem -out node.csr.pem

# Sign Node certificate
openssl ca \
  -batch \
  -notext \
  -config ca.cnf \
  -days "$NODE_DAYS" \
  -in node.csr.pem \
  -out node.crt.pem \
  -extensions x509_v3_node

# Concatenate CA certificate and Node certificate
cat node.crt.pem ca.cert.pem > node.full.crt.pem
