# test-docker-secret

Docker コンテナにおける機密情報の扱い方を検証した記録。

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/takuyahara/test-docker-secret)

### ❌ Distroless イメージを使う

[一時ファイルを使用後に削除する
](https://github.com/takuyahara/test-docker-secret/tree/access-to-deleted-file) と同様に、Docker イメージのデータ展開によりファイルを閲覧出来てしまう。

---

Docker イメージのデータをセーブして展開する。

```bash
$ docker save -o save.tar ghcr.io/takuyahara/distroless:latest
$ mkdir save && tar xfv save.tar -C save
$ cd save && ls -l
total 24
drwxr-xr-x@ 5 gitpod gitpod  160 Aug 19 02:37 2fc26300d5e7e423a2da240aa04852cc1dec5638d14cd35be6ec3c1aa212e8ee
-rw-r--r--@ 1 gitpod gitpod 1977 Aug 19 02:37 3f4f992009b74d627d01f6c9dda1eae75cf97683325440a8b7574470ff754a37.json
drwxr-xr-x@ 5 gitpod gitpod  160 Aug 19 02:37 4de43413bf2c191e04db903ce735b3bff5b459769c4259540074736d1582a9e7
drwxr-xr-x@ 5 gitpod gitpod  160 Aug 19 02:37 520b7a1dbd8c150680f594895a3c4738ffa73563c0adcec1e795c9a5631e83a2
drwxr-xr-x@ 5 gitpod gitpod  160 Aug 19 02:37 56f1a7603b2448fe2000f088c9460f75a107c81cd7b78e76411b2c07fc512627
drwxr-xr-x@ 5 gitpod gitpod  160 Aug 19 02:37 7d8a2261b77dae3211fdce78e83aafbcb091935028a9c9372b20c829a14b654e
drwxr-xr-x@ 5 gitpod gitpod  160 Aug 19 02:37 88a4c575c39811b173286a8135f7cbb9ca1684a58b2efee2f3d550bb969fe3a1
drwxr-xr-x@ 5 gitpod gitpod  160 Aug 19 02:37 9cf697342efa27895f7556ae28b3a2e4e332861cd2a969890991b6696c8f9bd2
drwxr-xr-x@ 5 gitpod gitpod  160 Aug 19 02:37 ab1c71a253261a4927a2c0037ddcd59496f0bf352c3bfc876af0e7f91dddf09b
drwxr-xr-x@ 5 gitpod gitpod  160 Aug 19 02:37 ad5703c7445f2fe864ba127761329d414650f3b2f750b841cf55b8ea13e8b488
drwxr-xr-x@ 5 gitpod gitpod  160 Aug 19 02:37 e8b44c4937c908130c651f46865d09719b253ac6092c3c7d80407809ae259618
-rw-r--r--@ 1 gitpod gitpod  899 Jan  1  1970 manifest.json
-rw-r--r--@ 1 gitpod gitpod   93 Jan  1  1970 repositories
```

`manifest.json` より、設定情報が記述された JSON ファイル名を確認する。

<img width="725" alt="Screenshot 2023-08-19 at 3 29 35" src="https://github.com/takuyahara/test-docker-secret/assets/46240835/29f875db-dfb2-493c-94b9-2a500278acf3">

確認したファイルを開いて `.history[]` における **`"empty_layer": true` の項目を除いて**注目し、
 `.env` の追加が配列中の末尾のレイヤーで行われていることを確認する。

<img width="547" alt="Screenshot 2023-08-19 at 3 31 10" src="https://github.com/takuyahara/test-docker-secret/assets/46240835/3428db36-3a7c-405f-a4cf-9f11d66b83bf">

`manifest.json` より、配列中の末尾のレイヤーにおけるデータを格納した tar ファイルのパスを確認する。

<img width="746" alt="Screenshot 2023-08-19 at 3 31 33" src="https://github.com/takuyahara/test-docker-secret/assets/46240835/d484d620-9fa1-4fa5-8cf0-5d77c7fc87d9">

当該の tar ファイルを展開すると、削除前のデータが展開され内容の閲覧が出来てしまうことを確認する。

```bash
$ cd 7d8a2261b77dae3211fdce78e83aafbcb091935028a9c9372b20c829a14b654e
$ tar xfv layer.tar 
.env
$ cat .env
API_TOKEN=my_secret_token
PASSWORD=my_password
```