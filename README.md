# Component Directory Build
This repository contains instruction for creating a so-called component directory/disc that includes pre-build
3:rd party libraries and utilities. It replace the usage of the VCPKG dependency manager. Most projects within the 
GitHub:ihedvall/* repositories, can be built using either the VCPKG manager or the components directory. 

- **VCPKG**. Set the CMAKE property (-D)CMAKE_TOOLCHAIN_FILE=_'Path to the vcpkg.cmake file'_. 
- **Components Directory**. Set CMAKE property (-D)COMP_DIR=_'Path to the root component directory'_.

Building a component disc take some times and require some planning. This repository consist mainly of script files 
that is either called from windows Powershell or from a Linux/Unix bash shell. Windows scripts are batch (*.bat) files
while Linux uses the bash shell (*.sh) scripts.

Git normally clones the third party repositories to a local directory but some third party libraries should be 
unzipped instead (Typical boost and wxWidgets). Let us call this directory the **Repository Directory**.

Next is to create a component directory either locally or on a remote NAS. The latter is used if many developer uses
the same directory. This is the **Component Directory**.

The third directory is the build directory. By default, this directory is set to the temporary directory 
(%TEMP% in windows). The scripts create a sub-directory and all temporary build files are created here. The
sub-directory is deleted at the end of the build. It's highly recommended to use a local fast disc (SSD) for the 
build directory

All scripts are run from the command shell and have the following inputs. 

**build_XXXX SourceDir DestDir BuildDir Tool**

- **SourceDir**. Full path to the source files or the repository.
- **DestDir**. Full path to the destination directory where the build results are placed.
- **BuildDir**. Root directory where the temporary files are stored. Can be ignored. 
- **Tool**. Keyword that defines which toolset to use. If ignored uses default compiler.

Example: **$> build_wxwidgets E:\wxWidgets K:\wxwidgets\master O:\build msvc** 

Note: The windows batch files doesn't handle UNC path (//server/dir) nor forward slashes.

## Build Machine Requirements

The following software should be installed.

- A C++ compiler. 
- CMAKE. 
- GIT.
- Optionally OpenSSL3 x64 including pre-built libraries.

## Building Boost

Boost is not fetched from GIT. Instead is a version unzipped from the [Boost Home Page](https://www.boost.org/). 
It doesn't build using the CMAKE. Instead it uses something called BJAM. 

1. Download and unzip a library from the "boost.org" page.
2. Select to the destination path to the _'COMP_DIR/boost/latest'_ path. 
3. Start the build and take a brake. It takes some time.

## Building Expat

Expat uses CMAKE but the CMAKE FindPackage() call won't find its library. 
So remove the extra "MD" from the library names after build. 
Note this may be fixed in later releases.

1. Clone the [libexpat](https://github.com/libexpat/libexpat) GitHub repository.
2. Select the destination path to the _COMP_DIR/expat/master_.
3. Do the build and rename the *MD libraries (msvc only).

## Building Google Test

Google test uses CMAKE.

1. Clone the [Google Test](https://github.com/google/googletest) GitHub repository.
2. Select the destination path to the _COMP_DIR/googletest/master_.
3. Do the build. It should be fast.

## Building wxWidgets

WxWidgets uses CMAKE.

1. Do not use GIT. Instead download one of the compressed source file. See [wxWidgets Home Page](https://wxwidgets.org/).
2. Select the destination path to the _COMP_DIR/wxwidgets/master_.
3. Start the build and take a brake.

## Build Zlib

Zlib uses CMAKE.

1. Clone the [ZLIB](https://github.com/madler/zlib) GitHub repository.
2. Select the destination path to the _COMP_DIR/zlib/master_.
3. Do the build. It should be fast.

## Build SQLite
Sqlite doesn't support any build so I have made a CMakeList.txt file in the sqlite sub-directory. 

1. Download the source files from the [SQLite Home Page](https://www.sqlite.org/) page, unzip and copy over the CMakeList.txt to the source 
directory.
2. Select the destination path to the _COMP_DIR/sqlite/master_.
3. Do the build.

## Build Protobuf or gRPC

Protobuf uses CMAKE. This build take some time and fails depending on the SSL library. 
Well the gRPC uses its own SSL not openSSL so you might get problem later on.
Clone some released code as the latest code normally fails.
You can use the gRPC github repository as well as it includes the protobuf

1. Clone the [ProtoBuf](https://github.com/protocolbuffers/protobuf.git) GitHub repository.
2. Select the destination path to the _COMP_DIR/protobuf/master_.
3. Start the build and take a coffee brake. You need some good luck as well.

## Build the Paho MQTT C Interface

The Paho MQTT C interface uses CMAKE.
1. Clone the [PAHO C Library](https://github.com/eclipse-paho/paho.mqtt.c.git) GitHub repository.
2. Select the destination path to the _COMP_DIR/pahomqttc/master_. Note that this path may change in the future.
3. Do the build.
