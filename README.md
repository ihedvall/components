# Component Directory/Disc
Theis repository contains instruction for creating a so-called component directory/disc that includes pre-build
3:rd party libraries and utilities. The target is C++ libraries for Windows 10/11 using MinGW or Microsoft C++

Building a component disc take som time and require some planning. The repository consist mainly of batch files which
called with the following input arguments.

**$> build_XXXX SourceDir DestDir BuildDir Tool**
- SourceDir. Full path to the source files or the repository.
- DestDir. Full path to the destination directory where the build results are placed.
- BuildDir. Root directory where the temporary files are stored. 
- Tool. Keyword that defines the toolset to use. Choose between gcc (MinGW) and msvc (Visual C 2022).

Example: **$> build_wxwidgets E:\wxWidgets K:\wxwidgets\master O:\build msvc** 

Note: The windows batch files doesn't handle UNC path (//server/dir) nor forward slashes.

## Build Machine Requirements
The following software should be installed on a Windows machine.
- MinGW (MSYS2) or MS Visual Studio 2022.
- OpenSSL3 x64 including pre-built libraries.
- CMAKE.
- GIT.

Note: WinFlexBison and Doxygen is not a requirement for the component disc but you need it later on.

## Building Boost
Boost doesn't use cmake for its build. Instead, it uses BJAM or something. 
1. Download and unzip a library from the "boost.org" page.
2. Start the build and take a brake. It takes some time.

## Building Expat
Expat uses cmake but later on the FindPackage() won't find its library. So remove the extra "MD" from the library names.
1. Clone the "libexpat/libexpat" GitHub repository.
2. Do the build and rename the *MD libraries (msvc only).

## Building Google Test
Google test uses cmake.
1. Clone the "google/googletest" GitHub repository.
2. Do the build.

## Building WxWidgets
WxWidgets uses cmake.
1. Clone the "wxWidgets/wxWidgets" GitHub repository.
2. Start the build and take a brake.

## Build Zlib
Zlib uses cmake.
1. Clone the "madler/zlib" GitHub repository.
2. Do the build.

## Build Sqlite
Sqlite doesn't support any build so I have made a CMakeList.txt file in the sqlite sub-directory. 
1. Download the source files from the "sqlite.org" page, unzip and copy over the CMakeList.txt to the source 
directory.
2. Do the build.

## Build Protobuf
Protobuf uses cmake.
1. Clone the "protocolbuffers/protobuf" GitHub repository.
2. Start the build and take a coffee brake.

## Build the Paho MQTT C Interface
The Paho MQTT C interface uses cmake.
1. Clone the "eclipse/paho.mqtt.c" GitHub repository.
2. Do the build.
