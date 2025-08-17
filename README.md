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
