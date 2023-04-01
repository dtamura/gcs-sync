
SSHサーバーからファイルをGCSへ同期する。


Build
----------------

```sh
gcloud builds submit -t asia-docker.pkg.dev/$project_id/containers/gcs-sync:latest
```

Run
-------------------

- `GCS_BUCKET_NAME` 同期先のバケット名（ `gs://` は不要）
- `SOURCE_HOST` 同期元のSSHサーバー
- `SOURCE_HOST_DIR` 同期元のSSHサーバー内ディレクトリ
- `SSH_KEY` SSH鍵ペアのうち、秘密鍵のbase64エンコードした文字列
- `SSH_USER` SSH接続のユーザ名

```sh
docker run --rm --privileged \
    -e "GCS_BUCKET_NAME=$GCS_BUCKET_NAME" \
    -e "SOURCE_HOST=$SOURCE_HOST" \
    -e "SOURCE_HOST_DIR=$SOURCE_HOST_DIR" \
    -e "SSH_KEY=$SSH_KEY" \
    -e "GCP_CREDENTIALS=$GCP_CREDENTIALS" \
    asia-docker.pkg.dev/$project_id/containers/gcs-sync:latest
```

