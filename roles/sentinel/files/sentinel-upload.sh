#!/bin/bash

set -e

REMOTE_BASEDIR="/sentinel"
REMOTE_DIR="${REMOTE_BASEDIR}/$(date +%Y-%m-%d)"
REMOTE_PATH="${REMOTE_DIR}/$(date +%Y-%m-%d-%H.%M.%S).jpg"

echo "--> uploading file ${REMOTE_PATH}"

lftp -u "${SFTP_USERNAME},${SFTP_PASSWORD}" "sftp://${SFTP_HOST}" <<EOF
set sftp:auto-confirm yes
set net:timeout 5
set net:max-retries 2
set net:reconnect-interval-base 5
mkdir -p ${REMOTE_DIR}
cd ${REMOTE_DIR}
put /tmp/sentinel.jpg -o ${REMOTE_PATH}
bye
EOF
