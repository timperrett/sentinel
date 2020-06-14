#!/bin/bash

set -e

REMOTE_BASEDIR="/sentinel"
REMOTE_DIR="${REMOTE_BASEDIR}/$(date +%Y-%m-%d)"
REMOTE_PATH="${REMOTE_DIR}/$(date +%Y-%m-%d-%H.%M.%S).jpg"
UPLOAD_CADANCE="5" # in minutes
DEBUG=${DEBUG:-off}


if [ -z ${SFTP_HOST} ]; then
    echo "SFTP_HOST must be set"
    exit 1
fi

if [ -z ${SFTP_USERNAME} ]; then
    echo "SFTP_USERNAME must be set"
    exit 1
fi

if [ -z ${SFTP_PASSWORD} ]; then
    echo "SFTP_PASSWORD must be set"
    exit 1
fi

# handy function to do math with real nums
calc(){ 
    awk "BEGIN { print "$*" }"
}

upload(){
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
}

if [[ ${DEBUG} == "on" ]]; then
    upload
else
    # in order to throttle the amount of uploads we have (and 
    # therefore consumption of bandwidth), artificially eliminate
    # actions that happen on minutes that are not in ${UPLOAD_CADANCE}
    # minutely divisions.
    if [[ $(calc $(date +%M)%${UPLOAD_CADANCE}) == 0 ]]; then 
        upload
    else 
        echo "--> skipping upload to conserve bandwidth"; 
    fi
fi
