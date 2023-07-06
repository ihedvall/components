rem Usage build_grpc_c <SourceDir> <DestDir> <BuildDir> <Tool>.
rem <SourceDir> (%1) Full path to the source repository.
rem <DestDir> (%2) Full path to the destination directory.
rem <BuildDir> (%3) Full path to a temporary directory where the build is done. The directory should exist.
rem <Tool> (%4) Choose gcc or msvc.

rem The build directory should exist. The build is done in a sub-directory.
rem You must use backslash in directory names (K:\foo not k:/foo)

set SOURCE_DIR=%1
if [%SOURCE_DIR%] == [] set SOURCE_DIR="l:\grpc"
echo SOURCE DIR: %SOURCE_DIR%

set DEST_DIR=%2
if [%DEST_DIR%] == [] set DEST_DIR="k:\grpc"
echo DEST DIR: %DEST_DIR%

set BUILD_DIR=%3
if [%BUILD_DIR%] == [] set BUILD_DIR="o:\build"
echo BUILD DIR: %BUILD_DIR%

set BUILD_TOOL=%4
if [%BUILD_TOOL%] == [] set BUILD_TOOL=msvc
echo BUILD TOOL: %BUILD_TOOL%

set GENERATOR="Visual Studio 17 2022"
if %BUILD_TOOL%==gcc set GENERATOR="MinGW Makefiles"

set ARCH=
if %BUILD_TOOL%==msvc set ARCH=-Ax64
if %BUILD_TOOL%==gcc set ARCH=-D OPENSSL_NO_ASM=ON

rmdir "%BUILD_DIR%\grpc" /s /q
mkdir "%BUILD_DIR%\grpc"
mkdir "%DEST_DIR%"


for %%C in ("Debug" "Release") do (

echo Generate MQTT C build environment
set PROJ_DEF=-D gRPC_INSTALL=ON -D gRPC_SSL_PROVIDER=package -D gRPC_BUILD_TESTS=OFF -D CMAKE_CXX_STANDARD=20 -D ABSL_PROPAGATE_CXX_STD=ON -D CMAKE_DEBUG_POSTFIX=d
cmake -G %GENERATOR% -S "%SOURCE_DIR%" -B "%BUILD_DIR%\grpc" -D CMAKE_INSTALL_PREFIX="%DEST_DIR%" -D CMAKE_BUILD_TYPE=%%C %ARCH% %PROJ_DEF%

echo Build MQTT C library
cmake --build "%BUILD_DIR%\grpc"  --clean-first --parallel 24 --config %%C

echo Install MQTT C library
cmake  --install "%BUILD_DIR%\grpc" --config %%C --prefix "%DEST_DIR%"

)

echo Removing MQTT C build directory
rmdir "%BUILD_DIR%\grpc" /s /q
