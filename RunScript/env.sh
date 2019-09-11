#!/usr/bin/env zsh --login

# Base Dir
BASEDIR=$(realpath $(dirname "$0"))

# 注入 framework 名称
export FRAMEWORK_NAME="TLocationPlugin"

# App 包名
export APP_NAME="wework"

# 二进制文件名称
export BINARY_NAME="wework"

# Payload Path
export PAYLOAD_PATH=$(realpath "${BASEDIR}/../Payload")

# App 包根目录
export APP_CONTENT_PATH="${PAYLOAD_PATH}/${BINARY_NAME}.app"

# 默认 App icon 图片名称
export PRIMARY_ICON_NAME=""
