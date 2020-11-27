# laravel-voyager-on-docker-containers

Docker Composeを使用してLaravelとVoyagerを動かす

---

## 使い方

①以下のコマンドを実行して、ローカルにリポジトリを複製します。

```
$ git clone https://github.com/qesblog/laravel-voyager-on-docker-containers
```

② laravel-voyager-on-docker-containers ディレクトリに移動します。

```
$ cd laravel-voyager-on-docker-containers
```

③Dockerfile や docker-compose.yml に記載されている設定項目を、環境に合わせて修正します。

例：

```
ROOTPASSWORD
DATABASENAME
USERNAME
USERPASSWORD
http:\/\/example.com/
```

④ host.sh を bash で実行します。

```
$ bash host.sh
```

⑤ブラウザを開いて、Laravelにアクセスします（ドメインやIPアドレスは、環境により異なります）。

