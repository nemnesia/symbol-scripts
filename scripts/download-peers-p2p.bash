#!/bin/bash
###############################################################################
# Script to download P2P peer information for Symbol node
###############################################################################

# Default network is mainnet
NETWORK="mainnet"

# Check command line argument for network type
if [ "$1" = "testnet" ]; then
    NETWORK="testnet"
elif [ "$1" = "mainnet" ]; then
    NETWORK="mainnet"
elif [ -n "$1" ]; then
    echo "Error: Invalid network type '$1'. Use 'mainnet' or 'testnet'."
    echo "Usage: $0 [mainnet|testnet]"
    exit 1
fi

# Set API URL according to the network
if [ "$NETWORK" = "testnet" ]; then
    API_URL="https://nwmimic.nemnesia.com/testnet/api/symbol/nodes/peers-p2p"
else
    API_URL="https://nwmimic.nemnesia.com/api/symbol/nodes/peers-p2p"
fi

# Download peers and save to the appropriate files
echo "Downloading peers for $NETWORK network..."
curl -s "$API_URL" | jq > /opt/symbol-node/resources/peers-p2p.json
cp /opt/symbol-node/resources/peers-p2p.json /opt/symbol-node/resources/peers-api.json
echo "Peers downloaded successfully for $NETWORK network."
