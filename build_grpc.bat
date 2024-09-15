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

set ARCH=-Ax64
rem if %BUILD_TOOL%==msvc set ARCH=-Ax64
if %BUILD_TOOL%==gcc set ARCH=-D OPENSSL_NO_ASM=ON

rmdir "%BUILD_DIR%\grpc" /s /q
mkdir "%BUILD_DIR%\grpc"
mkdir "%DEST_DIR%"


for %%C in ("Debug" "Release") do (

echo Generate gRPC C build environment

cmake -G%GENERATOR% -S %SOURCE_DIR% -B %BUILD_DIR%\grpc -DCMAKE_INSTALL_PREFIX=%DEST_DIR% ^
	-DABSL_PROPAGATE_CXX_STD=ON -DgRPC_INSTALL=ON -DBUILD_SHARED_LIBS=OFF ^
	-DgRPC_BUILD_TESTS=OFF -DCMAKE_DEBUG_POSTFIX=d -DCMAKE_BUILD_TYPE=%%C %ARCH% %PROJ_DEF%

echo Build gRPC C library
cmake --build "%BUILD_DIR%\grpc"  --clean-first --parallel 24 --config %%C

echo Install gRPC C library
cmake  --install "%BUILD_DIR%\grpc" --config %%C --prefix "%DEST_DIR%"

)

echo Removing gRPC C build directory
rmdir "%BUILD_DIR%\grpc" /s /q
