rem Usage build_zlib <SourceDir> <DestDir> <BuildDir> <Tool>. 
rem <SourceDir> (%1) Full path to the zlib repository.
rem <DestDir> (%2) Full path to the destination directory (Example: k:\zlib\master.
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
if %BUILD_TOOL%==msvc set ARCH=-Ax64

rmdir "%BUILD_DIR%\zlib" /s /q
mkdir "%BUILD_DIR%\zlib"
mkdir "%DEST_DIR%"

for %%C in ("Debug" "Release") do (
echo Generate ZLIB build environment
cmake -G %GENERATOR% -S "%SOURCE_DIR%" -B "%BUILD_DIR%\zlib" -D CMAKE_INSTALL_PREFIX="%DEST_DIR%" -D CMAKE_BUILD_TYPE=%%C %ARCH% -D CMAKE_DEBUG_POSTFIX=d 

echo Build ZLIB library
cmake --build "%BUILD_DIR%\zlib"  --clean-first --parallel 24 --config %%C

echo Install ZLIB library 
cmake  --install "%BUILD_DIR%\zlib" --config %%C --prefix "%DEST_DIR%"
)

echo Removing ZLIB build directory
rmdir "%BUILD_DIR%\zlib" /s /q
