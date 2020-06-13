#!/bin/bash

set -x

lftp -u "${SFTP_USERNAME},${SFTP_PASSWORD}" sftp://${SFTP_HOST} <<EOF
cd sentinel
put /tmp/sentinel.jpg -o /sentinel/$(date +%Y-%m-%d-%H.%M.%S).jpg
bye
EOF
