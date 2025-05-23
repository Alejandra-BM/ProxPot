#!/bin/bash

SRC_DIR="/opt/dionaea/var/lib/dionaea/"
SRC_DIR2="/opt/cowrie/"
DEST_DIR="alebm@192.168.128.xxx:~/dionaea/"

rsync -avz --progress \
    "${SRC_DIR}/binaries" \
    "${SRC_DIR}/bistreams" \
    "${SRC_DIR}/ftp" \
    "${SRC_DIR}/http" \
    "${SRC_DIR2}/logs" \
    "${DEST_DIR}"
