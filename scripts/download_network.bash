#!/bin/bash
set -e


SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

mkdir -p /tmp/symbol-scripts
cd /tmp/symbol-scripts

curl -sOL https://github.com/symbol/networks/archive/refs/heads/mainnet.zip
curl -sOL https://github.com/symbol/networks/archive/refs/heads/sai.zip

unzip mainnet.zip
unzip sai.zip

rm *.zip

# seed
mkdir -p /opt/symbol-node/seed
cp -r /tmp/symbol-scripts/networks-mainnet/seed /opt/symbol-node/seed/mainnet
cp -r /tmp/symbol-scripts/networks-sai/seed /opt/symbol-node/seed/testnet

# mongo
mkdir -p /opt/symbol-node/scripts/mongo
cp -r /tmp/symbol-scripts/networks-mainnet/mongo /opt/symbol-node/scripts

# resources
mkdir -p /opt/symbol-node/resources-sample
cp -r /tmp/symbol-scripts/networks-mainnet/resources/* /opt/symbol-node/resources-sample/mainnet-dual
cp -r /tmp/symbol-scripts/networks-mainnet/resources/* /opt/symbol-node/resources-sample/mainnet-peer
cp -r /tmp/symbol-scripts/networks-sai/resources/* /opt/symbol-node/resources-sample/testnet-dual
cp -r /tmp/symbol-scripts/networks-sai/resources/* /opt/symbol-node/resources-sample/testnet-peer

# rest
mkdir -p /opt/symbol-node/rest/resources-sample
cp -r /tmp/symbol-scripts/networks-mainnet/rest/rest.json /opt/symbol-node/rest/resources-sample/rest.mainnet.json
cp -r /tmp/symbol-scripts/networks-mainnet/rest/rest-light.json /opt/symbol-node/rest/resources-sample/rest-light.mainnet.json
cp -r /tmp/symbol-scripts/networks-sai/rest/rest.json /opt/symbol-node/rest/resources-sample/rest.testnet.json
cp -r /tmp/symbol-scripts/networks-sai/rest/rest-light.json /opt/symbol-node/rest/resources-sample/rest-light.testnet.json



# resources修正
CATAPULT_RESOURCES=/opt/symbol-node/resources-sample
# config-extensions-server.extensions.extension.filespooling
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-extensions-server.properties extensions extension.filespooling "true"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-extensions-server.properties extensions extension.filespooling "false"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-extensions-server.properties extensions extension.filespooling "true"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-extensions-server.properties extensions extension.filespooling "false"
# config-extensions-server.extensions.extension.partialtransaction
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-extensions-server.properties extensions extension.partialtransaction "true"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-extensions-server.properties extensions extension.partialtransaction "false"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-extensions-server.properties extensions extension.partialtransaction "true"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-extensions-server.properties extensions extension.partialtransaction "false"
# config-extensions-recovery.extensions.extension.addressextraction
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-extensions-recovery.properties extensions extension.addressextraction "true"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-extensions-recovery.properties extensions extension.addressextraction "false"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-extensions-recovery.properties extensions extension.addressextraction "true"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-extensions-recovery.properties extensions extension.addressextraction "false"
# config-extensions-recovery.extensions.extension.mongo
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-extensions-recovery.properties extensions extension.mongo "true"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-extensions-recovery.properties extensions extension.mongo "false"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-extensions-recovery.properties extensions extension.mongo "true"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-extensions-recovery.properties extensions extension.mongo "false"
# config-extensions-recovery.extensions.extension.zeromq
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-extensions-recovery.properties extensions extension.zeromq "true"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-extensions-recovery.properties extensions extension.zeromq "false"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-extensions-recovery.properties extensions extension.zeromq "true"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-extensions-recovery.properties extensions extension.zeromq "false"
# config-logging-server.file.directory
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-logging-server.properties file directory "/opt/symbol-node/logs"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-logging-server.properties file directory "/opt/symbol-node/logs"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-logging-server.properties file directory "/opt/symbol-node/logs"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-logging-server.properties file directory "/opt/symbol-node/logs"
# config-logging-server.file.filePattern
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-logging-server.properties file filePattern "/opt/symbol-node/logs/catapult_server%4N.log"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-logging-server.properties file filePattern "/opt/symbol-node/logs/catapult_server%4N.log"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-logging-server.properties file filePattern "/opt/symbol-node/logs/catapult_server%4N.log"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-logging-server.properties file filePattern "/opt/symbol-node/logs/catapult_server%4N.log"
# config-logging-recovery.file.directory
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-logging-recovery.properties file directory "/opt/symbol-node/logs"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-logging-recovery.properties file directory "/opt/symbol-node/logs"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-logging-recovery.properties file directory "/opt/symbol-node/logs"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-logging-recovery.properties file directory "/opt/symbol-node/logs"
# config-logging-recovery.file.filePattern
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-logging-recovery.properties file filePattern "/opt/symbol-node/logs/catapult_server%4N.log"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-logging-recovery.properties file filePattern "/opt/symbol-node/logs/catapult_server%4N.log"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-logging-recovery.properties file filePattern "/opt/symbol-node/logs/catapult_server%4N.log"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-logging-recovery.properties file filePattern "/opt/symbol-node/logs/catapult_server%4N.log"
# config-logging-broker.file.directory
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-logging-broker.properties file directory "/opt/symbol-node/logs"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-logging-broker.properties file directory "/opt/symbol-node/logs"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-logging-broker.properties file directory "/opt/symbol-node/logs"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-logging-broker.properties file directory "/opt/symbol-node/logs"
# config-logging-broker.file.filePattern
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-logging-broker.properties file filePattern "/opt/symbol-node/logs/catapult_server%4N.log"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-logging-broker.properties file filePattern "/opt/symbol-node/logs/catapult_server%4N.log"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-logging-broker.properties file filePattern "/opt/symbol-node/logs/catapult_server%4N.log"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-logging-broker.properties file filePattern "/opt/symbol-node/logs/catapult_server%4N.log"
# config-node.localnode.roles
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-node.properties localnode roles "Peer, Api"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-node.properties localnode roles "Peer"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-node.properties localnode roles "Peer, Api"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-node.properties localnode roles "Peer"
# config-node.node.enableAutoSyncCleanup
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-node.properties node enableAutoSyncCleanup "false"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-node.properties node enableAutoSyncCleanup "true"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-node.properties node enableAutoSyncCleanup "false"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-node.properties node enableAutoSyncCleanup "true"
# config-node.node.maxChainBytesPerSyncAttempt
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-node.properties node maxChainBytesPerSyncAttempt "10MB"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-node.properties node maxChainBytesPerSyncAttempt "10MB"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-node.properties node maxChainBytesPerSyncAttempt "10MB"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-node.properties node maxChainBytesPerSyncAttempt "10MB"
# config-node.node.blockDisruptorMaxMemorySize
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-node.properties node blockDisruptorMaxMemorySize "1000MB"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-node.properties node blockDisruptorMaxMemorySize "1000MB"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-node.properties node blockDisruptorMaxMemorySize "1000MB"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-node.properties node blockDisruptorMaxMemorySize "1000MB"
# config-user.storage.seedDirectory
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-user.properties storage seedDirectory "/opt/symbol-node/seed/mainnet"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-user.properties storage seedDirectory "/opt/symbol-node/seed/mainnet"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-user.properties storage seedDirectory "/opt/symbol-node/seed/testnet"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-user.properties storage seedDirectory "/opt/symbol-node/seed/testnet"
# config-user.storage.certificateDirectory
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-user.properties storage certificateDirectory "/opt/symbol-node/certificates"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-user.properties storage certificateDirectory "/opt/symbol-node/certificates"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-user.properties storage certificateDirectory "/opt/symbol-node/certificates"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-user.properties storage certificateDirectory "/opt/symbol-node/certificates"
# config-user.storage.dataDirectory
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-user.properties storage dataDirectory "/opt/symbol-node/data/data"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-user.properties storage dataDirectory "/opt/symbol-node/data/data"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-user.properties storage dataDirectory "/opt/symbol-node/data/data"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-user.properties storage dataDirectory "/opt/symbol-node/data/data"
# config-user.storage.pluginsDirectory
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-user.properties storage pluginsDirectory "/opt/symbol-node/lib"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-user.properties storage pluginsDirectory "/opt/symbol-node/lib"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-user.properties storage pluginsDirectory "/opt/symbol-node/lib"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-user.properties storage pluginsDirectory "/opt/symbol-node/lib"
# config-user.storage.votingKeysDirectory
crudini --set ${CATAPULT_RESOURCES}/mainnet-dual/config-user.properties storage votingKeysDirectory "/opt/symbol-node/votingkeys"
crudini --set ${CATAPULT_RESOURCES}/mainnet-peer/config-user.properties storage votingKeysDirectory "/opt/symbol-node/votingkeys"
crudini --set ${CATAPULT_RESOURCES}/testnet-dual/config-user.properties storage votingKeysDirectory "/opt/symbol-node/votingkeys"
crudini --set ${CATAPULT_RESOURCES}/testnet-peer/config-user.properties storage votingKeysDirectory "/opt/symbol-node/votingkeys"

# rest.db.url
REST_RESOURCES=/opt/symbol-node/rest/resources-sample
jq '.db.url = "mongodb://127.0.0.1:27017/"' ${REST_RESOURCES}/rest.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.mainnet.json
jq '.db.url = "mongodb://127.0.0.1:27017/"' ${REST_RESOURCES}/rest.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.testnet.json
# rest.apiNode.host
jq '.apiNode.host = "127.0.0.1"' ${REST_RESOURCES}/rest.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.mainnet.json
jq '.apiNode.host = "127.0.0.1"' ${REST_RESOURCES}/rest.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.testnet.json
jq '.apiNode.host = "127.0.0.1"' ${REST_RESOURCES}/rest-light.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest-light.mainnet.json
jq '.apiNode.host = "127.0.0.1"' ${REST_RESOURCES}/rest-light.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest-light.testnet.json
# rest.apiNode.tlsClientCertificatePath
jq '.apiNode.tlsClientCertificatePath = "../certificates/node.crt.pem"' ${REST_RESOURCES}/rest.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.mainnet.json
jq '.apiNode.tlsClientCertificatePath = "../certificates/node.crt.pem"' ${REST_RESOURCES}/rest.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.testnet.json
# rest.apiNode.tlsClientKeyPath
jq '.apiNode.tlsClientKeyPath = "../certificates/node.key.pem"' ${REST_RESOURCES}/rest.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.mainnet.json
jq '.apiNode.tlsClientKeyPath = "../certificates/node.key.pem"' ${REST_RESOURCES}/rest.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.testnet.json
jq '.apiNode.tlsClientKeyPath = "../certificates/node.key.pem"' ${REST_RESOURCES}/rest-light.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest-light.mainnet.json
jq '.apiNode.tlsClientKeyPath = "../certificates/node.key.pem"' ${REST_RESOURCES}/rest-light.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest-light.testnet.json
# rest.apiNode.tlsCaCertificatePath
jq '.apiNode.tlsCaCertificatePath = "../certificates/ca.crt.pem"' ${REST_RESOURCES}/rest.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.mainnet.json
jq '.apiNode.tlsCaCertificatePath = "../certificates/ca.crt.pem"' ${REST_RESOURCES}/rest.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.testnet.json
jq '.apiNode.tlsCaCertificatePath = "../certificates/ca.crt.pem"' ${REST_RESOURCES}/rest-light.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest-light.mainnet.json
jq '.apiNode.tlsCaCertificatePath = "../certificates/ca.crt.pem"' ${REST_RESOURCES}/rest-light.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest-light.testnet.json
# rest.apiNode.inflationPropertyFilePath
jq '.apiNode.inflationPropertyFilePath = "../resources/config-inflation.properties"' ${REST_RESOURCES}/rest.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.mainnet.json
jq '.apiNode.inflationPropertyFilePath = "../resources/config-inflation.properties"' ${REST_RESOURCES}/rest.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.testnet.json
jq '.apiNode.inflationPropertyFilePath = "../resources/config-inflation.properties"' ${REST_RESOURCES}/rest-light.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest-light.mainnet.json
jq '.apiNode.inflationPropertyFilePath = "../resources/config-inflation.properties"' ${REST_RESOURCES}/rest-light.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest-light.testnet.json
# rest.apiNode.networkPropertyFilePath
jq '.apiNode.networkPropertyFilePath = "../resources/config-network.properties"' ${REST_RESOURCES}/rest.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.mainnet.json
jq '.apiNode.networkPropertyFilePath = "../resources/config-network.properties"' ${REST_RESOURCES}/rest.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.testnet.json
# rest.apiNode.nodePropertyFilePath
jq '.apiNode.nodePropertyFilePath = "../resources/config-node.properties"' ${REST_RESOURCES}/rest.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.mainnet.json
jq '.apiNode.nodePropertyFilePath = "../resources/config-node.properties"' ${REST_RESOURCES}/rest.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.testnet.json
# rest.websocket.mq.host
jq '.websocket.mq.host = "127.0.0.1"' ${REST_RESOURCES}/rest.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.mainnet.json
jq '.websocket.mq.host = "127.0.0.1"' ${REST_RESOURCES}/rest.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.testnet.json
# rest.logging.file.filename
jq '.logging.file.filename = "../logs/rest/catapult-rest.log"' ${REST_RESOURCES}/rest.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.mainnet.json
jq '.logging.file.filename = "../logs/rest/catapult-rest.log"' ${REST_RESOURCES}/rest.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.testnet.json
jq '.logging.file.filename = "../logs/rest/catapult-rest.log"' ${REST_RESOURCES}/rest-light.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest-light.mainnet.json
jq '.logging.file.filename = "../logs/rest/catapult-rest.log"' ${REST_RESOURCES}/rest-light.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest-light.testnet.json
# rest.deployment.deploymentTool
jq '.deployment.deploymentTool = "catapult"' ${REST_RESOURCES}/rest.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.mainnet.json
jq '.deployment.deploymentTool = "catapult"' ${REST_RESOURCES}/rest.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.testnet.json
jq '.deployment.deploymentTool = "catapult"' ${REST_RESOURCES}/rest-light.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest-light.mainnet.json
jq '.deployment.deploymentTool = "catapult"' ${REST_RESOURCES}/rest-light.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest-light.testnet.json
# rest.deployment.deploymentToolVersion
jq '.deployment.deploymentToolVersion = "n/a"' ${REST_RESOURCES}/rest.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.mainnet.json
jq '.deployment.deploymentToolVersion = "n/a"' ${REST_RESOURCES}/rest.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.testnet.json
jq '.deployment.deploymentToolVersion = "n/a"' ${REST_RESOURCES}/rest-light.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest-light.mainnet.json
jq '.deployment.deploymentToolVersion = "n/a"' ${REST_RESOURCES}/rest-light.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest-light.testnet.json
# rest.deployment.lastUpdatedDate
jq '.deployment.lastUpdatedDate = "n/a"' ${REST_RESOURCES}/rest.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.mainnet.json
jq '.deployment.lastUpdatedDate = "n/a"' ${REST_RESOURCES}/rest.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest.testnet.json
jq '.deployment.lastUpdatedDate = "n/a"' ${REST_RESOURCES}/rest-light.mainnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest-light.mainnet.json
jq '.deployment.lastUpdatedDate = "n/a"' ${REST_RESOURCES}/rest-light.testnet.json > tmp.json && mv tmp.json ${REST_RESOURCES}/rest-light.testnet.json


cp -r ${ROOT_DIR}/*.bash /opt/symbol-node/scripts
cp -r ${ROOT_DIR}/symbol-build/etc/systemd/system/*.service /etc/systemd/system


rm -rf /tmp/symbol-scripts


echo ""
echo "complete"
