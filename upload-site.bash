#!/bin/bash
set -e

MAKEBINARY=

while getopts "m" OPTION; do
  case $OPTION in
    m) MAKEBINARY=1;;
  esac
done

SRC_DIR=$(cd "$(dirname "$0")"; pwd)

if [ -n "$MAKEBINARY" ]; then
  $SRC_DIR/../rpgboss/package/package.sh
  mkdir -p $SRC_DIR/src/files/binaries
  rsync -avz $SRC_DIR/../rpgboss/package/target/* $SRC_DIR/src/files/binaries
fi

docpad generate --env static

rsync -avz --progress -e ssh $SRC_DIR/out/* mathim.com:/home/tommycli/rpgboss
