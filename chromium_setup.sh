#!/usr/bin/env bash

set -euo pipefail

# revision prefix taken from
# https://github.com/microsoft/playwright/blob/7c4c46c9e7e8c29376ec02c1ae4521db385b63dd/packages/playwright-core/browsers.json#L20
# and filtered in 
# https://commondatastorage.googleapis.com/chromium-browser-snapshots/index.html?prefix=Mac_Arm/
export CHROMIUM_REVISION=1392998
export CHROMIUM_DIR=$HOME/local/chromium

mkdir -p $CHROMIUM_DIR $CHROMIUM_DIR/bin $CHROMIUM_DIR/versions
cd $CHROMIUM_DIR/versions
curl -o chromium-mac-$CHROMIUM_REVISION.zip 'https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Mac_Arm%2F1392998%2Fchrome-mac.zip?generation=1733508362961757&alt=media'
unzip -q chromium-mac-$CHROMIUM_REVISION.zip
mv -v chrome-mac chromium-mac-$CHROMIUM_REVISION
ln -sf $CHROMIUM_DIR/versions/chromium-mac-$CHROMIUM_REVISION/Chromium.app $CHROMIUM_DIR/bin/Chromium.app

# set the env variable export this in you shell profile
export PUPPETEER_EXECUTABLE_PATH=$HOME/local/chromium/bin/Chromium.app/Contents/MacOS/Chromium