#!/bin/bash
# mongo_check_and_prepare.sh
# MongoDBのコレクション存在チェック＆初期化スクリプト

MONGO_HOST="localhost"
MONGO_PORT="27017"
MONGO_DB="catapult"
PREPARE_SCRIPT="/opt/symbol-node/scripts/mongo/mongoDbPrepare.js"


# mongosh接続確認
mongosh --quiet --host "$MONGO_HOST" --port "$MONGO_PORT" --eval "db.stats()" > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "[ERROR] MongoDBに接続できませんでした。設定や起動状態を確認してください。" >&2
  exit 1
fi

# catapultDBの存在チェック（listDatabases方式）
DB_EXISTS=$(mongosh --quiet --host "$MONGO_HOST" --port "$MONGO_PORT" --eval "db.adminCommand({ listDatabases: 1 }).databases.map(db => db.name).includes('$MONGO_DB')")

if [ "$DB_EXISTS" != "true" ]; then
  echo "Database $MONGO_DB does not exist. Running prepare script..."
  mongosh --host "$MONGO_HOST" --port "$MONGO_PORT" "$MONGO_DB" "$PREPARE_SCRIPT"
else
  echo "Database $MONGO_DB already exists. No action needed."
fi