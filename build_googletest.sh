#!/bin/bash
# Copyright 2022 Ingemar Hedvall
# SPDX-License-Identifier: MIT

SOURCE_DIR=$1
DEST_DIR=$2
BUILD_DIR=$3

echo NofArg: $#

show_usage()
{
echo "Usage:"
echo "./build_googletest.sh SourceDir DestDir BuildDir"
echo "Where:"
echo "SourceDir: [Required] Full path to the expat source directory."
echo "DestDir:   [Required] Full path to the destination expat directory."
echo "BuildDir:  [Optional] Full path to a build root directory. Default is /tmp/gtest"
}

if [ $# -lt 2 ]; then
	show_usage
	exit 0
fi

# Check that source directory exist and is not null
if [ -z "$SOURCE_DIR" ]; then
	echo "Error: Source directory must be supplied!"
	exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
	echo "Error: Source directory must exist!"
	exit 1
fi

# Test that destination directory exist and if not create it
if [ -z "$DEST_DIR" ]; then
	echo "Error: Destination directory must be supplied!"
	exit 1;
fi

if [ ! -d "$DEST_DIR" ]; then
  echo "Making directory: ${DEST_DIR}"
	mkdir -p "$DEST_DIR"
fi

# Create the build directory

if [ -z "$BUILD_DIR" ]; then
	BUILD_DIR="/tmp/gtest"
fi

if [ -d "$BUILD_DIR" ]; then
  mkdir -p "$BUILD_DIR"
fi


for build_type in Debug Release
do
  echo "Generate GOOGLETEST build environment"
  cmake -G "Unix Makefiles" -S "$SOURCE_DIR" -B "$BUILD_DIR" -D CMAKE_INSTALL_PREFIX="$DEST_DIR" \
     -D CMAKE_BUILD_TYPE=$build_type  -D gtest_force_shared_crt=ON -D CMAKE_DEBUG_POSTFIX=d

  echo "Build GOOGLETEST library"
  cmake --build "$BUILD_DIR" --clean-first --parallel 8 --config $build_type

  echo "Install GOOGLETEST library"
  cmake  --install "$BUILD_DIR" --config $build_type --prefix "$DEST_DIR"
done

echo "Removing temporary files"
rm -rf "$BUILD_DIR"
