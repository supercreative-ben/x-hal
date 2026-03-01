#!/bin/bash
set -euo pipefail

PRODUCT_NAME="X-HAL"
BUNDLE_ID="com.xhal.breathwork"
APP_DIR="build/${PRODUCT_NAME}.app"
CONTENTS_DIR="${APP_DIR}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

echo "Building ${PRODUCT_NAME}..."
swift build -c release 2>&1

BINARY_PATH=$(swift build -c release --show-bin-path)/${PRODUCT_NAME}

echo "Generating app icon..."
swift generate-icon.swift 2>&1
iconutil -c icns build/AppIcon.iconset -o build/AppIcon.icns 2>&1

echo "Packaging ${PRODUCT_NAME}.app..."
rm -rf "${APP_DIR}"
mkdir -p "${MACOS_DIR}" "${RESOURCES_DIR}"

cp "${BINARY_PATH}" "${MACOS_DIR}/${PRODUCT_NAME}"
cp build/AppIcon.icns "${RESOURCES_DIR}/AppIcon.icns"

cat > "${CONTENTS_DIR}/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleExecutable</key>
	<string>X-HAL</string>
	<key>CFBundleIdentifier</key>
	<string>com.xhal.breathwork</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>X-HAL</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>1.0</string>
	<key>CFBundleVersion</key>
	<string>1</string>
	<key>LSMinimumSystemVersion</key>
	<string>14.0</string>
	<key>CFBundleIconFile</key>
	<string>AppIcon</string>
	<key>NSPrincipalClass</key>
	<string>NSApplication</string>
</dict>
</plist>
PLIST

if [ -d "X-HAL/Resources/Sounds" ]; then
    cp -r X-HAL/Resources/Sounds "${RESOURCES_DIR}/Sounds"
fi

BUNDLE_PATH=$(swift build -c release --show-bin-path)/X-HAL_X-HAL.bundle
if [ -d "${BUNDLE_PATH}" ]; then
    cp -r "${BUNDLE_PATH}" "${RESOURCES_DIR}/"
fi

echo ""
echo "Done! ${PRODUCT_NAME}.app is at: $(pwd)/${APP_DIR}"
echo "Run with: open ${APP_DIR}"
