#!/bin/bash
###############################################################################
### Symbol Node Certificate Generation Script
###############################################################################

# Default values
CA_DAYS=7300
NODE_DAYS=375
CA_CN="Symbol Node CA"
NODE_CN="Symbol Node"

# Parse options
while getopts "c:n:C:N:" opt; do
  case "$opt" in
    c) CA_DAYS="$OPTARG" ;;
    n) NODE_DAYS="$OPTARG" ;;
    C) CA_CN="$OPTARG" ;;
    N) NODE_CN="$OPTARG" ;;
    *) echo "Usage: $0 [-c CA certificate days] [-n Node certificate days] [-C CA certificate name] [-N Node certificate name]"; exit 1 ;;
  esac
done

# Prepare directories and files
mkdir -p certificates/new_certs 
cd certificates
# Create index file for CA database

touch index.txt

# Check if CA key file exists
if [ -f ca.key.pem ]; then
  echo "Using existing CA key file."
else
  echo "Creating new CA key file."
  openssl genpkey -algorithm ed25519 -outform PEM -out ca.key.pem
fi

# Generate CA certificate
openssl rand -out serial.dat -hex 19

echo "[ca]
default_ca = CA_default

[CA_default]
new_certs_dir = ./new_certs
database = index.txt
serial = serial.dat
private_key = ca.key.pem
certificate = ca.cert.pem
policy = policy_catapult

[policy_catapult]
commonName = supplied

[req]
prompt = no
distinguished_name = dn
x509_extensions = x509_v3

[dn]
CN = $CA_CN

[x509_v3]
basicConstraints = critical,CA:TRUE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer

[x509_v3_node]
basicConstraints = CA:FALSE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
" > ca.cnf

openssl req \
  -new \
  -x509 \
  -config ca.cnf \
  -keyform PEM \
  -key ca.key.pem \
  -days "$CA_DAYS" \
  -out ca.cert.pem \
  -extensions x509_v3

# Output CA public key
openssl pkey -in ca.key.pem -pubout -out ca.pubkey.pem

# Generate Node certificate
if [ -f node.key.pem ]; then
  echo "Using existing Node key file."
else
  echo "Creating new Node key file."
  openssl genpkey -algorithm ed25519 -outform PEM -out node.key.pem
fi

echo "[req]
prompt = no
distinguished_name = dn

[dn]
CN = $NODE_CN
" > node.cnf

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
