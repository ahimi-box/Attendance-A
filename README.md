
```
$ git clone https://___________
```

上記のコマンド実行（リポジトリをクローン）後、
次のコマンドで必要になる RubyGems をインストールします。

```
$ bundle install
```

その後、データベースへのマイグレーションを実行します。

```
$ rails db:migrate
```

マイグレーション実行後、サンプルユーザーを生成します。

```
$ rails db:seed
```

これでRailsサーバーを立ち上げる準備が整いました。

```
$ rails server
```

ユーザーの新規作成やログインなどは既に出来る状態になっているはずです。

* **email** : sample@email.com
* **password** : password
