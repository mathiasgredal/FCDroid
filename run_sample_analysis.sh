#!/usr/bin/env bash
set -euo pipefail

APK_DIR="${APK_DIR:-/data/apks}"
STRING_TO_FIND="${STRING_TO_FIND:-iframe}"

mkdir -p /workspace/tools/FCDroid/log /workspace/tools/FCDroid/json

if [ ! -d "${APK_DIR}" ]; then
  echo "[!] APK_DIR does not exist: ${APK_DIR}"
  echo "[!] Mount a host directory with APKs, e.g. -v /host/apks:${APK_DIR}:ro"
  exit 1
fi

shopt -s nullglob
apks=("${APK_DIR}"/*.apk)
shopt -u nullglob

if [ "${#apks[@]}" -eq 0 ]; then
  echo "[!] No .apk files found in ${APK_DIR}"
  exit 1
fi

echo "[*] Running FCDroid static analysis on ${#apks[@]} APK(s) from ${APK_DIR}"

# hybrid_inspector expects conf.json in the current working directory.
ln -sf /workspace/tools/FCDroid/conf.json /workspace/tools/conf.json

cd /workspace/tools
python -m FCDroid.hybrid_inspector -d "${APK_DIR}" -t -s "${STRING_TO_FIND}"
