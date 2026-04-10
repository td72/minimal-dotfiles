# minimal-dotfiles

[![CI](https://github.com/td72/minimal-dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/td72/minimal-dotfiles/actions/workflows/ci.yml)

サーバ作業用の最小限のdotfiles

## 概要
XDG Base Directory仕様に準拠した、最小限の設定ファイル集です。
以下のツールの設定が含まれています：
- Bash
- Fish
- Vim
- Tmux

## インストール
```bash
git clone https://github.com/td72/minimal-dotfiles.git
cd minimal-dotfiles
./setup.sh
```

## Dockerでのテスト

### 前提条件
- Docker
- Docker Compose

### 使用方法

#### 1. インタラクティブな開発環境
```bash
# コンテナを起動して設定をテスト
docker-compose run --rm dev

# または既にビルド済みの場合
docker-compose up -d dev
docker exec -it dotfiles-dev bash
```

#### 2. 自動テストの実行
```bash
# test.shを実行する前に実行権限を付与
chmod +x test.sh

# テストを実行
docker-compose run --rm test
```

#### 3. 異なる環境でのテスト
```bash
# Ubuntu環境でテスト
docker-compose run --rm ubuntu

# Amazon Linux 2環境でテスト
docker-compose run --rm amazonlinux
```

### Dockerコマンド

```bash
# イメージのビルド
docker build -t minimal-dotfiles:dev --target base .
docker build -t minimal-dotfiles:test --target test .

# コンテナの実行
docker run -it --rm minimal-dotfiles:dev bash
docker run --rm minimal-dotfiles:test

# クリーンアップ
docker-compose down
docker rmi minimal-dotfiles:dev minimal-dotfiles:test
```

### テストスクリプト
`test.sh`は以下の項目を検証します：
- XDGディレクトリの存在
- 各設定ファイルの配置
- シンボリックリンクの作成
- コマンドの実行可能性
- セットアップスクリプトの冪等性

## ディレクトリ構造
```
minimal-dotfiles/
├── config/
│   ├── bash/
│   │   ├── bashrc
│   │   └── bash_profile
│   ├── fish/
│   │   └── config.fish
│   ├── tmux/
│   │   └── tmux.conf
│   └── vim/
│       └── vimrc
├── setup.sh
├── test.sh
├── Dockerfile
├── docker-compose.yml
└── README.md
```
