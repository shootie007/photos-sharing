# README

写真管理アプリケーション

# 開発環境構築手順

## Docker Desktopのインストール

参考： https://docs.docker.jp/desktop/install/mac-install.html

## 環境変数の設定

`.env` ファイルを作成し、以下の値を設定する（任意）

```
DB_USER=<任意の値>
DB_PASSWORD=<任意の値>
```

## シークレット値の設定

```
$ docker compose run --rm web bash

# コンテナ内部で以下を実行
$ EDITOR=vim bin/rails credentials:edit
```

エディターが起動したら、以下の値を設定して保存

```
secret_key_base: <任意の文字列>
oauth:
  client_id: <oauthのクライアントID>
  clinet_secret: <oauthのクライアントのシークレット値>
```

## 環境の立ち上げ

dockerコンテナをビルドし、環境を立ち上げる

```
$ docker compose build
$ docker compose up -d
```

# 動作確認

## ログインユーザー情報

開発環境の場合のみ、seed に記述されたユーザー情報でログインできる
