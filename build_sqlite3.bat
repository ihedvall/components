rem Usage build_zlib <SourceDir> <DestDir> <BuildDir> <Tool>. 
rem <SourceDir> (%1) Full path to the sqlite3 source directory.
rem <DestDir> (%2) Full path to the destination directory (Example: k:\sqlite3\master.
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

rmdir "%BUILD_DIR%\sqlite3" /s /q
mkdir "%BUILD_DIR%\sqlite3"
mkdir "%DEST_DIR%"

for %%C in ("Debug" "Release") do (
echo Generate SQLITE3 build environment
cmake -G %GENERATOR% -S "%SOURCE_DIR%" -B "%BUILD_DIR%\sqlite3" -D CMAKE_INSTALL_PREFIX="%DEST_DIR%" -D CMAKE_BUILD_TYPE=%%C %ARCH% -D BUILD_SHARED_LIBS=OFF -D EXPAT_NS=OFF -D CMP0091=NEW 

echo Build SQLITE3 library
cmake --build "%BUILD_DIR%\sqlite3"  --clean-first --parallel 24 --config %%C

echo Install SQLITE3 library 
cmake  --install "%BUILD_DIR%\sqlite3" --config %%C --prefix "%DEST_DIR%"
)

echo Removing SQLITE3 build directory
rmdir "%BUILD_DIR%\sqlite3" /s /q
