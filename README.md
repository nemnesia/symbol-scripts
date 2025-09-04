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

## Symbol ノードインストール

### 1. ユーザー作成

symbol ユーザーをログイン可能ユーザーで作成する。

```bash
sudo adduser symbol
sudo passwd symbol
```

### 2. Node.js インストール

v20 をインストールする。

```bash
sudo mkdir -p /usr/local/node-users/symbol
sudo chown -R symbol: /usr/local/node-users/symbol
cd /usr/local/node-users/symbol
sudo curl -OL https://nodejs.org/dist/v20.19.4/node-v20.19.4-linux-x64.tar.xz
sudo tar -xJf node-v20.19.4-linux-x64.tar.xz
sudo mv node-v20.19.4-linux-x64 node
sudo chown -R symbol: node
sudo rm node-v20.19.4-linux-x64.tar.xz
```

```bash
sudo echo 'export PATH=/usr/local/node-users/symbol/node/bin:$PATH' | sudo tee -a /home/symbol/.bashrc
```

### 3. Mongo DB 8 インストール

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

### 4. Symbol ノードビルド

```bash
git clone https://github.com/nemnesia/symbol-scripts.git
git clone https://github.com/symbol/symbol.git -b client/catapult/v1.0.3.8
./symbol-scripts/scripts/symbol-build/1_install_symbol_build_deps.bash
./symbol-scripts/scripts/symbol-build/2_build_symbol_deps.bash symbol
./symbol-scripts/scripts/symbol-build/3_build_symbol.bash symbol
sudo ./symbol-scripts/scripts/symbol-build/4_copy_catapult.bash symbol
```

```bash
sudo -u symbol ./symbol-scripts/scripts/5_download_network.bash
```

### 5. ノード証明書の作成

ここから `symbol` ユーザーで作業する。

```bash
su symbol
cd /opt/symbol-node
```

新規作成

```bash
./scripts/symbol-node-cert-gen.bash
```

引き継ぐ
`certificates` ディレクトリに `ca.key.pem`, `node.key.pem` を入れておくことで、その秘密鍵で証明書を作成します。

```bash
./scripts/hexstr2pem.bash certificates/ca.key.pem
./scripts/hexstr2pem.bash certificates/node.key.pem
./scripts/symbol-node-cert-gen.bash
```

VRF, リモートの秘密鍵もこのタイミングで作っておきましょう。

```bash
openssl genpkey -algorithm ed25519 -outform PEM -out certificates/vrf.key.pem
openssl genpkey -algorithm ed25519 -outform PEM -out certificates/remote.key.pem
```

秘密鍵の値は `pem2hexstr.bash` で確認出来ます。

```bash
./scripts/pem2hexstr.bash certificates/vrf.key.pem
./scripts/pem2hexstr.bash certificates/remote.key.pem
```

### 6. ノードの設定

`resources-sample`から作成したいロールをコピーします。

```bash
cp resources-sample/testnet-dual/* resources
```

ノード情報を設定するために `resources/config-node.properties` を編集します。

- host: 自 IP やドメインを設定
- friendlyName: ノードの名前(なんでもいいです)※日本語不可

```ini
[localnode]

host = myServerHostnameOrPublicIp
friendlyName = myServerFriendlyName
```

ハーベストの設定を `resources/config-harvesting.properties` に設定します。

- `harvesterSigningPrivateKey`: リモートアカウントの秘密鍵
- `harvesterVrfPrivateKey`: VRF アカウントの秘密鍵
- `enableAutoHarvesting`: `true`
- `maxUnlockedAccounts`: 委任を受け入れる最大値
- `delegatePrioritizationPolicy`: 委任者の最大を超えたときの追い出し挙動(`Importance` または `Age`)
- `beneficiaryAddress`: ハーベスト報酬の受け取りアドレス

```ini
[harvesting]

harvesterSigningPrivateKey = AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
harvesterVrfPrivateKey = AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

enableAutoHarvesting = false
maxUnlockedAccounts = 10
delegatePrioritizationPolicy = Importance
beneficiaryAddress =
```

### 7. 接続ピアリストの作成

```bash
./scripts/download-peers-p2p.bash testnet
```

### 8. Rest の設定

Node.js のモジュールをインストール。

```bash
cd rest
npm i
```

設定ファイルコピー。

```bash
cp resources-sample/rest.testnet.json resources/rest.json
```

### 9. ポート開放

```bash
sudo ufw allow 7900
sudo ufw allow 3000
```

### 10. サービス起動

`symbol-mongo` サービス起動後、自動的に MongoDB 初期化サービス `symbol-mongo-init` が起動します。

再起動すると PID 管理ディレクトリが消えてしまうので、再起動時に作成するようにします。

```bash
sudo vi /etc/tmpfiles.d/symbol-node.conf
```

```bash
#Type   Path                    Mode    UID            GID          Age  Argument
d       /run/symbol-node        0755    symbol         symbol       -
```

サービス起動

起動はこの順番です。ただ、rest はいつでも良いです。停止はこの逆順となります。

```bash
sudo systemctl start symbol-mongo
sudo systemctl start symbol-rest
sudo systemctl start symbol-broker
sudo systemctl start symbol-server
```

## XX. メモ

### Mongo DB 8 アンインストール

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

### ユーザー関連

#### ログイン不可に切り替える

```bash
sudo usermod -s /usr/sbin/nologin hogehoge
```

#### ログイン可能に切り替える

```bash
sudo usermod -s /bin/bash hogehoge
```
