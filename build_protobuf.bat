rem Usage build_protobuf <SourceDir> <DestDir> <BuildDir> <Tool>. 
rem <SourceDir> (%1) Full path to the Google Protobuf repository.
rem <DestDir> (%2) Full path to the destination directory (Example: k:\protobuf\master.
rem <BuildDir> (%3) Full path to a temporary directory where the build is done. The directory should exist.
rem <Tool> (%4) Choose gcc or msvc. 
 
rem The build directory should exist. The build is done in a sub-directory.
rem You must use backslash in directory names (K:\foo not k:/foo)

set SOURCE_DIR=%1
set DEST_DIR=%2
set BUILD_DIR=%3
set BUILD_TOOL=%4

set GENERATOR="Visual Studio 17 2022"
if %BUILD_TOOL%==gcc set GENERATOR="MinGW Makefiles"

set ARCH=
if %BUILD_TOOL%==msvc set ARCH=-Ax64 -D protobuf_MSVC_STATIC_RUNTIME=OFF

rmdir "%BUILD_DIR%\protobuf" /s /q
mkdir "%BUILD_DIR%\protobuf"
mkdir "%DEST_DIR%"


for %%C in ("Debug" "Release") do (

echo Generate PROTOBUF build environment
cmake -G %GENERATOR% -S "%SOURCE_DIR%" -B "%BUILD_DIR%\protobuf" -D CMAKE_INSTALL_PREFIX="%DEST_DIR%" -D CMAKE_BUILD_TYPE=%%C %ARCH% -D CMAKE_DEBUG_POSTFIX=d -D ZLIB_ROOT=k:/zlib/master -D protobuf_BUILD_TESTS=OFF -D protobuf_BUILD_LIBPROTOC=ON -D protobuf_BUILD_ABSL_PROVIDER=ON

echo Build PROTOBUF library
cmake --build "%BUILD_DIR%\protobuf"  --clean-first --parallel 24 --config %%C

echo Install PROTOBUF library 
cmake  --install "%BUILD_DIR%\protobuf" --config %%C --prefix "%DEST_DIR%"

)

echo Removing PROTOBUF build directory
rmdir "%BUILD_DIR%\protobuf" /s /q
