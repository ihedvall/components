#!/bin/bash
# Copyright 2022 Ingemar Hedvall
# SPDX-License-Identifier: MIT

SOURCE_DIR=$1
DEST_DIR=$2
BUILD_DIR=$3
TOOLSET=$4

echo NofArg: $#

show_usage()
{
echo "Usage:"
echo "./build_boost.sh SourceDir DestDir BuildDir Toolset"
echo "Where:"
echo "SourceDir: Full path to the boost source directory."
echo "DestDir:   Full path to the destination boost directory."
echo "BuildDir:  Full path to a build root directory. Default is /tmp"
echo "Toolset:   Type of compiler to use. Choose gcc or clang. Default is gcc"
}

if [ $# -lt 2 ]; then
	show_usage
	exit 0
fi

if [ -z "$SOURCE_DIR" ]; then
	echo "Error: Source directory must be supplied!" 
	exit 1
fi	

if [ ! -d "$SOURCE_DIR" ]; then
	echo "Error: Source directory must exist!" 
	exit 1
fi	

if [ -z "$DEST_DIR" ]; then
	echo "Error: Destination directory must be supplied!" 
	exit 1;
fi	

if [ ! -d "$DEST_DIR" ]; then
   echo "Making directory: ${DEST_DIR}"
	mkdir -p "$DEST_DIR"
fi	

if [ -z "$BUILD_DIR" ]; then
	BUILD_DIR="/tmp/boost"
fi	

if [ -d "$BUILD_DIR" ]; then
  mkdir -p "$BUILD_DIR"
fi

if [ -z "$TOOLSET" ]; then
	TOOLSET="gcc"
fi

echo "Move to source dir"
pushd "$SOURCE_DIR" || return

echo "Let's do some boo(s)t jamming"
./bootstrap.sh --with-toolset="${TOOLSET}" --prefix="${DEST_DIR}" --exec-prefix="${DEST_DIR}"

echo "Build the boost libraries and install headers"
./b2 --help
#./b2 --clean
./b2 link=static threading=multi runtime-link=shared --build-type=complete --layout=tagged --build-dir="$BUILD_DIR" install -d0 -j8

echo "Removing temporary files"
rm -rf "$BUILD_DIR"
echo "Returning to original directory"
popd || return

