#!/bin/bash

BASE_DIR=$(cd `dirname $0`; pwd)

$BASE_DIR/build/reflash.sh
$BASE_DIR/build/upload.sh