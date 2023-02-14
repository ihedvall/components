rem Usage build_awssdk <SourceDir> <DestDir> <BuildDir> <Tool>. 
rem <SourceDir> (%1) Full path to the AWS SD cloned repository.
rem <DestDir> (%2) Full path to the destination directory (Example: k:/aws/master.
rem <BuildDir> (%3) Full path to a temporary directory where the build is done. The directory should exist.
rem <Tool> (%4) Choose gcc or msvc. 
 
rem The build directory should exist. The build is done in a sub-directory.
rem You must use backslash in directory names (K:\foo not k:/foo)

set SOURCE_DIR=%1
set DEST_DIR=%2
set BUILD_DIR=%3
set BUILD_TOOL=%4

if [%BUILD_TOOL%] == [] set BUILD_TOOL=msvc
echo Build Tool: %BUILD_TOOL%

if [%BUILD_DIR%] == [] set BUILD_DIR=%TEMP%\expat
echo Using temporary directory: %BUILD_DIR%

if [%SOURCE_DIR%] == [] (
    echo Error: Source directory must be supplied.
    exit /b 1
)

if not exist "%SOURCE_DIR%" (
    echo Error: Source directory must exist.
    exit /b 1
)

if [%DEST_DIR%] == [] (
    echo Error: Destination directory must be supplied.
    exit /b 1
)

if not exist "%DEST_DIR%" (
    mkdir "%DEST_DIR%"
    echo Making destination directory: %DEST_DIR%
)

if not exist "%BUILD_DIR%" (
    mkdir "%BUILD_DIR%"
    echo Making temporary directory  %BUILD_DIR%
)

set GENERATOR="Visual Studio 17 2022 Win64"
if %BUILD_TOOL%==gcc set GENERATOR="MinGW Makefiles"

set ARCH=
if %BUILD_TOOL%==msvc set ARCH=-A x64
set GENERATOR="Visual Studio 17 2022"
if %BUILD_TOOL%==gcc set GENERATOR="MinGW Makefiles"

set ARCH=
if %BUILD_TOOL%==msvc set ARCH=-Ax64

rmdir "%BUILD_DIR%\aws" /s /q
mkdir "%BUILD_DIR%\aws"
mkdir "%DEST_DIR%"

for %%C in ("Debug" "Release") do (
echo Generate AWS build environment
cmake -G %GENERATOR% -S "%SOURCE_DIR%" -B "%BUILD_DIR%\aws" -D BUILD_SHARED_LIBS=OFF ^
      -D CMAKE_INSTALL_PREFIX="%DEST_DIR%" -D LEGACY_MODE=OFF ^
	  -D CMAKE_DEBUG_POSTFIX=d -D CMAKE_BUILD_TYPE=%%C %ARCH% 

echo Build AWS SDK library
cmake --build "%BUILD_DIR%\aws"  --clean-first --parallel 24 --config %%C

echo Install AWS SDK library 
cmake  --install "%BUILD_DIR%\aws" --config %%C --prefix "%DEST_DIR%"
)

echo Removing build directory
rmdir "%BUILD_DIR%\aws" /s /q
