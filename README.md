# test-docker-secret

Docker コンテナにおける機密情報の扱い方を検証した記録。

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/takuyahara/test-docker-secret)

### ❌ 一時ファイルを使用後に削除する

最終版のレイヤーでは `.env` が存在しないことを確認する。

```bash
$ docker run ghcr.io/takuyahara/access-to-deleted-file:latest cat .env
cat: can't open '.env': No such file or directory
```

Docker イメージのデータをセーブして展開する。

```bash
$ docker save -o save.tar ghcr.io/takuyahara/access-to-deleted-file:latest
$ mkdir save && tar xfv save.tar -C save
$ cd save && ls -l
total 16
drwxr-xr-x  2 gitpod gitpod   62 Aug 18 16:34 04eea7ccbbd0c429b7ea16404d754f07cf85a25c3386073f4c2d473d00f60dd0
drwxr-xr-x  2 gitpod gitpod   66 Aug 18 16:34 357a4789a04cf15ae0bf9654b98f8ce2d7e3b71c0ed3507828f58684f981ffe7
drwxr-xr-x 19 gitpod gitpod 4096 Aug 18 16:34 43c3cad4039e0dfccb627ac80524d0890ad58d02dfd6cae315f53b8d495c91c7
-rw-r--r--  1 gitpod gitpod 1750 Aug 18 16:37 6ab5ceb9c6f4f2e720d80c78e3e651a68883ca9a744ffda16eac3188ade8b8f4.json
-rw-r--r--  1 gitpod gitpod  501 Aug 18 16:31 manifest.json
-rw-r--r--  1 gitpod gitpod  124 Jan  1  1970 repositories
```

`manifest.json` より、設定情報が記述された JSON ファイル名を確認する。

<img width="771" alt="Screenshot 2023-08-19 at 1 49 10" src="https://github.com/takuyahara/test-docker-secret/assets/46240835/ef1ac993-1c57-4d1c-8db8-7f06df61f057">

確認したファイルを開いて `.env` の追加が配列中の末尾から 2 番目のレイヤーで行われていることを確認する。

<img width="685" alt="Screenshot 2023-08-19 at 1 46 52" src="https://github.com/takuyahara/test-docker-secret/assets/46240835/d7819f11-b2a1-465d-a0c1-5943a91fc29e">

`manifest.json` より、配列中の末尾から 2 番目のレイヤーにおけるデータを格納した tar ファイルのパスを確認する。

<img width="738" alt="Screenshot 2023-08-19 at 1 49 23" src="https://github.com/takuyahara/test-docker-secret/assets/46240835/ebbc39a4-8f4f-4a1a-aefd-d68af6585a24">

当該の tar ファイルを展開すると、削除前のデータが展開され内容の閲覧が出来てしまうことを確認する。

```bash
$ cd 04eea7ccbbd0c429b7ea16404d754f07cf85a25c3386073f4c2d473d00f60dd0
$ tar xfv layer.tar 
.env
$ cat .env
API_TOKEN=my_secret_token
PASSWORD=my_password
```