#!/usr/bin/env zsh --login

set -ex

FRAMEWORK_NAME="TLocationPlugin"  # 注入 framework 名称
APP_NAME="wework"           # App 包名
BINARY_NAME="wework"        # 二进制文件名称

ORIGIN_APP_NAME="${APP_NAME}_origin.ipa"
NEW_APP_NAME="${APP_NAME}_new.ipa"

# clean
rm -rf ./Payload

# unzip & copy
APP_CONTENT_PATH="./Payload/${BINARY_NAME}.app"
FRAMEWORKS_PATH="${APP_CONTENT_PATH}/Frameworks"

unzip "${ORIGIN_APP_NAME}"
if [ ! -d "${FRAMEWORKS_PATH}" ]; then
    mkdir -p "${FRAMEWORKS_PATH}"
fi
cp -rf "${FRAMEWORK_NAME}.framework" "${FRAMEWORKS_PATH}"

# inject

pushd . > /dev/null
cd "${APP_CONTENT_PATH}"
yololib "${BINARY_NAME}" "Frameworks/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}"
popd > /dev/null


# clean
rm -f "${NEW_APP_NAME}"

# zip
zip -r "${NEW_APP_NAME}" ./Payload

# clean
rm -rf ./Payload

# sign
set +ex
echo "new app: ${NEW_APP_NAME}; \nyou should sign it, recommend fastlane"

