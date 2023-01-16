#!/usr/bin/env zsh --login

set -ex

CUR_DIR=$(realpath $(dirname "$0"))

source "$CUR_DIR/devices_arm_info.sh"
source "$CUR_DIR/env.sh"


ORIGIN_APP_NAME="${APP_NAME}_origin.ipa"
NEW_APP_NAME="${APP_NAME}_new.ipa"

# clean
rm -rf "$PAYLOAD_PATH"

# unzip & copy Framework
unzip "${ORIGIN_APP_NAME}"
FRAMEWORKS_PATH="${APP_CONTENT_PATH}/Frameworks"
if [ ! -d "${FRAMEWORKS_PATH}" ]; then
    mkdir -p "${FRAMEWORKS_PATH}"
fi
cp -rf "${FRAMEWORK_NAME}.framework" "${FRAMEWORKS_PATH}"

# inject
pushd . > /dev/null

cd "${APP_CONTENT_PATH}"

# 修改支持的机型
#BINARY_INFO=`file ${BINARY_NAME}`
#SUPPORTED_DEVICE_LIST=""
#echo $ARM64_DEVICES
#echo $ARMV7_DEVICES
#
#if [[ "${BINARY_INFO}" =~ "arm64" ]]; then
#    SUPPORTED_DEVICE_LIST="${SUPPORTED_DEVICE_LIST}${ARM64_DEVICES}"
#fi
#
#if [[ "${BINARY_INFO}" =~ "armv7" ]]; then
#    SUPPORTED_DEVICE_LIST="${SUPPORTED_DEVICE_LIST}${ARMV7_DEVICES}"
#fi

PLIST_FILE_PATH="${APP_CONTENT_PATH}/Info.plist"
plutil -remove UISupportedDevices Info.plist
#plutil -replace UISupportedDevices -json "[${SUPPORTED_DEVICE_LIST}]" "${PLIST_FILE_PATH}"
#plutil -p "${PLIST_FILE_PATH}"

# 注入动态库
yololib "${BINARY_NAME}" "Frameworks/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}"

# 注入图标
python3 "${CUR_DIR}/inject_app_icon.py"

popd > /dev/null


# clean
rm -f "${NEW_APP_NAME}"

# zip
zip -r "${NEW_APP_NAME}" ./Payload

# clean
rm -rf "$PAYLOAD_PATH"

set +ex

# sign
echo "new app: ${NEW_APP_NAME}; \nyou should sign it, recommend fastlane"

fastlane sigh resign -i "your_dev_cert" -p "your_mobileprovision_file" ${NEW_APP_NAME}.ipa

