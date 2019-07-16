#!/bin/bash

BASE_DIR=$(cd `dirname $0`; pwd)

$BASE_DIR/reflash.sh
$BASE_DIR/deploy.sh