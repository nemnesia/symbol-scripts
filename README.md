# symbol-scripts リポジトリ

このリポジトリは Symbol ノード運用や証明書管理のための各種スクリプトをまとめたものです。

## 各スクリプトの説明

- `symbol-node-cert-gen.sh`  
  ノード用の CA 証明書およびノード証明書を新規作成します。

- `symbol-node-cert-upd.sh`  
  既存の CA でノード証明書を再発行（更新）します。

- `pem2hexstr.bash`  
  PEM 形式の秘密鍵ファイルから秘密鍵を 16 進数文字列で表示します。

- `hexstr2pem.bash`  
  16 進数の秘密鍵文字列から PEM 形式の秘密鍵ファイルを生成します。

- `download-peers-p2p.sh`  
  Symbol ノードの P2P ピア情報をダウンロードし、ノードの peers ファイルとして保存します。

## 使い方

### symbol-node-cert-gen.sh

ノード用 CA 証明書・ノード証明書を新規作成します。
`certificates` ディレクトリに作成されます。`certificates` ディレクトリ内にすでに `ca.key.pem` 、 `node.key.pem` が存在する場合は、それらの秘密鍵を使ってノード証明書を生成します。

```
bash symbol-node-cert-gen.sh
```

オプション:

- `-c <日数>` CA 証明書の有効日数（デフォルト: 7300）
- `-n <日数>` ノード証明書の有効日数（デフォルト: 375）
- `-C <名前>` CA 証明書のコモンネーム
- `-N <名前>` ノード証明書のコモンネーム

### symbol-node-cert-upd.sh

既存 CA でノード証明書を再発行（更新）します。

```
bash symbol-node-cert-upd.sh
```

オプション:

- `-n <日数>` ノード証明書の有効日数（デフォルト: 375）
- `-N <名前>` ノード証明書のコモンネーム

### pem2hexstr.bash

PEM 形式の秘密鍵ファイルから秘密鍵を 16 進数文字列で表示します。

```
bash pem2hexstr.bash <pemファイル>
```

### hexstr2pem.bash

16 進数の秘密鍵文字列から PEM 形式の秘密鍵ファイルを生成します。

```
bash hexstr2pem.bash <出力pemファイル>
```

実行後、秘密鍵（16 進数）を入力してください。

### download-peers-p2p.sh

Symbol ノードの P2P ピア情報をダウンロードします。

```
bash download-peers-p2p.sh [mainnet|testnet]
```

引数を省略した場合は mainnet になります。

## Mongo DB 8 インストール

公開鍵のインポート

```bash
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
  sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
  --dearmor
```

リストファイルを作成する

```bash
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
```

MongoDB のインストール

```bash
sudo apt update
sudo apt install -y mongodb-org
```

## Mongo DB 8 アンインストール

MongoDB のアンインストール

```bash
sudo apt purge mongodb-org
```

リストファイルを削除する

```bash
sudo rm /etc/apt/sources.list.d/mongodb-org-8.0.list
```

公開鍵を削除する

```bash
sudo rm /usr/share/keyrings/mongodb-server-8.0.gpg
```

### ログイン出来ないユーザー作成

```bash
sudo useradd -m -s /usr/sbin/nologin hogehoge
```

### ログイン可能に切り替える

```bash
sudo usermod -s /bin/bash hogehoge
```

### ログイン不可に切り替える

```bash
sudo usermod -s /usr/sbin/nologin hogehoge
```
