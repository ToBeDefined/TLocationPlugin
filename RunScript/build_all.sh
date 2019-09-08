#!/usr/bin/env zsh --login

set -ex

FMK_NAME="TLocationPlugin"
UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-universal

# make sure the output directory exists
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

# Step 1. Build Device and Simulator versions
xcodebuild -target "${FMK_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
xcodebuild -target "${FMK_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphonesimulator BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build

# Step 2. Copy the framework structure (from iphoneos build) to the universal folder
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${FMK_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

# Step 3. Copy Swift modules from iphonesimulator build (if it exists) to the copied framework directory
SIMULATOR_SWIFT_MODULES_DIR="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${FMK_NAME}.framework/Modules/${FMK_NAME}.swiftmodule/."
if [ -d "${SIMULATOR_SWIFT_MODULES_DIR}" ]; then
    cp -R "${SIMULATOR_SWIFT_MODULES_DIR}" "${UNIVERSAL_OUTPUTFOLDER}/${FMK_NAME}.framework/Modules/${FMK_NAME}.swiftmodule"
fi

# Step 4. Create universal binary file using lipo and place the combined executable in the copied framework directory
SIMULATOR_FRAMEWORK_PATH="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${FMK_NAME}.framework/${FMK_NAME}"
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${FMK_NAME}.framework/${FMK_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${FMK_NAME}.framework/${FMK_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${FMK_NAME}.framework/${FMK_NAME}"

# Step 5. Convenience step to copy the framework to the project's directory
cp -R "${UNIVERSAL_OUTPUTFOLDER}/${FMK_NAME}.framework" "${PROJECT_DIR}"

# Step 6. strip
strip -ur "${PROJECT_DIR}/${FMK_NAME}.framework/${FMK_NAME}"

# Step 7. show nm
nm "${PROJECT_DIR}/${FMK_NAME}.framework/${FMK_NAME}"

# Step 8. Convenience step to open the project's directory in Finder
rm -rf build

set +ex
