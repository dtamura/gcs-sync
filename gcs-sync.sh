#!/bin/bash

set -eo pipefail

# Create mount directory for service
mkdir -p $MNT_DIR

# echo ${GCP_CREDENTIALS} | base64 -d > /tmp/sa-key.json
# export GOOGLE_APPLICATION_CREDENTIALS=/tmp/sa-key.json

echo "Mounting GCS Fuse."
# for debug: gcsfuse --debug_gcs --debug_fuse
gcsfuse ${GCS_BUCKET_NAME} ${MNT_DIR}
echo "Mounting completed."

echo ${SSH_KEY} | base64 -d > /app/id_rsa
chmod 400 /app/id_rsa

# for debug: rsync -avzP
echo "ファイル同期開始"
echo "rsync -az -e \"ssh -o StrictHostKeyChecking=no -i /app/id_rsa\" ${SSH_USER}@${SOURCE_HOST}:${SOURCE_HOST_DIR} ${MNT_DIR}"
rsync -az -e "ssh -o StrictHostKeyChecking=no -i /app/id_rsa" ${SSH_USER}@${SOURCE_HOST}:${SOURCE_HOST_DIR} ${MNT_DIR}
echo "ファイル同期完了"

sleep 5

echo "DONE"

exit 0
