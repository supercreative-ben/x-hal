#!/bin/bash
set -euo pipefail

echo "==> Building X-HAL..."
./build.sh

echo "==> Zipping X-HAL.app for download..."
rm -f landing/public/X-HAL.zip
zip -r landing/public/X-HAL.zip build/X-HAL.app

echo "==> Committing and pushing..."
git add -A
git commit -m "Update X-HAL app build"
git push

echo ""
echo "Done! Vercel will auto-deploy the new version."
