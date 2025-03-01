#!/bin/sh
set -e

# check that the user has specified a file name
if [ $# -ne 2 ]; then
  echo "ERROR: Please write your command with the format ./compile.sh [sketch folder name] [delay]"
  exit 1
fi

# check that arduino-cli is installed
if ! eval "arduino-cli" >/dev/null 2>&1; then
  echo "ERROR: Please install arduino-cli first"
  exit 2
fi

# run make with the specified folder name
make -j4 -B SKETCH_FOLDER_NAME="$1" DELAY_TIME_MS="$2"

echo ""
echo "--------------- Finished compilation ---------------"
echo ""

make upload SKETCH_FOLDER_NAME="$1"

echo ""
echo "----------------- Finished upload -----------------"
echo ""