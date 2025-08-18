#!/bin/sh
set -e



SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"


# symbolリポジトリのパスをコマンドライン引数で指定。なければ自動検索。

# コマンドライン引数はsymbolディレクトリのある階層のディレクトリ指定
if [ -n "$1" ]; then
	BASE_PATH="$1"
	SYMBOL_REPO_PATH="$BASE_PATH/catapult"
	REST_REPO_PATH="$BASE_PATH/rest"
	if [ ! -d "$SYMBOL_REPO_PATH" ]; then
		echo "$SYMBOL_REPO_PATH が見つかりません。catapultディレクトリが必要です。" >&2
		exit 1
	fi
	if [ ! -d "$REST_REPO_PATH" ]; then
		echo "$REST_REPO_PATH が見つかりません。restディレクトリが必要です。" >&2
		exit 1
	fi
else
	# デフォルトパス
	DEFAULT_PATH="${ROOT_DIR}/symbol/client/catapult"
	if [ -d "$DEFAULT_PATH" ]; then
		SYMBOL_REPO_PATH="$DEFAULT_PATH"
		REST_REPO_PATH="${ROOT_DIR}/symbol/client/rest"
	else
		# 親ディレクトリ配下からcatapultディレクトリを検索
		SYMBOL_REPO_PATH=$(find "$ROOT_DIR" -type d -name catapult 2>/dev/null | head -n 1)
		if [ -z "$SYMBOL_REPO_PATH" ]; then
			echo "catapultディレクトリが見つかりません。パスを指定してください。" >&2
			exit 1
		fi
		REST_REPO_PATH="$(dirname "$SYMBOL_REPO_PATH")/rest"
		if [ ! -d "$REST_REPO_PATH" ]; then
			# restディレクトリもfindで探す
			REST_REPO_PATH=$(find "$ROOT_DIR" -type d -name rest 2>/dev/null | head -n 1)
			if [ -z "$REST_REPO_PATH" ]; then
				echo "restディレクトリが見つかりません。" >&2
				exit 1
			fi
		fi
	fi
fi

# bin
mkdir -p /opt/symbol-node/bin
cp ${SYMBOL_REPO_PATH}/_build/bin/catapult* /opt/symbol-node/bin

# lib
mkdir -p /opt/symbol-node/lib
cp ${SYMBOL_REPO_PATH}/_build/bin/lib* /opt/symbol-node/lib

# deps
mkdir -p /opt/symbol-node/deps
cp -r ${SYMBOL_REPO_PATH}/_temp/boost/lib/*.so* /opt/symbol-node/deps
cp -r ${SYMBOL_REPO_PATH}/_temp/facebook/lib/*.so* /opt/symbol-node/deps
cp -r ${SYMBOL_REPO_PATH}/_temp/mongodb/lib/*.so* /opt/symbol-node/deps
cp -r ${SYMBOL_REPO_PATH}/_temp/openssl/*.so* /opt/symbol-node/deps
cp -r ${SYMBOL_REPO_PATH}/_temp/openssl/*.cnf* /opt/symbol-node/deps
cp -r ${SYMBOL_REPO_PATH}/_temp/openssl/engines-3 /opt/symbol-node/deps
cp -r ${SYMBOL_REPO_PATH}/_temp/openssl/ossl-modules /opt/symbol-node/deps
cp -r ${SYMBOL_REPO_PATH}/_temp/zeromq/lib/*.so* /opt/symbol-node/deps

# rest
cp -r ${REST_REPO_PATH} /opt/symbol-node

echo ""
echo "complete"
