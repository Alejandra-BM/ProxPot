#!/bin/bash

SRC_DIR="/opt/dionaea/var/lib/dionaea/"
DEST_DIR="alebm@192.168.128...:~/dionaea/"

rsync -avz --progress \
    "${SRC_DIR}/binaries" \
    "${SRC_DIR}/bistreams" \
    "${SRC_DIR}/ftp" \
    "${SRC_DIR}/http" \
    "${DEST_DIR}"
