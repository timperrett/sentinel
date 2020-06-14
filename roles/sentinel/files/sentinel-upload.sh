#!/bin/bash

set -e

REMOTE_BASEDIR="/sentinel"
REMOTE_DIR="${REMOTE_BASEDIR}/$(date +%Y-%m-%d)"
REMOTE_PATH="${REMOTE_DIR}/$(date +%Y-%m-%d-%H.%M.%S).jpg"
UPLOAD_CADANCE="5" # in minutes

# handy function to do math with real nums
calc(){ 
    awk "BEGIN { print "$*" }"
}

# in order to throttle the amount of uploads we have (and 
# therefore consumption of bandwidth), artificially eliminate
# actions that happen on minutes that are not in ${UPLOAD_CADANCE}
# minutely divisions.
if [[ $(calc $(date +%M)%${UPLOAD_CADANCE}) == 0 ]]; then 
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

else 
    echo "--> skipping upload to conserve bandwidth"; 
fi
