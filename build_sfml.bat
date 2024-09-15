rem Usage build_wxwidgets SourceDir DestDir BuildDir Tool.
rem SourceDir (%1) Full path to the SFML repository.
rem DestDir (%2) Full path to the destination directory (Example: k:/sfml/master.
rem BuildDir (%3) Full path to a temporary directory where the build is done.
rem Tool (%4) Choose gcc or msvc.
 
rem The build directory should exist. The build is done in a sub-directory.
rem You must use backslash in directory names (K:\foo not k:/foo)

set SOURCE_DIR=%1
set DEST_DIR=%2
set BUILD_DIR=%3
set BUILD_TOOL=%4

if [%BUILD_TOOL%] == [] set BUILD_TOOL=msvc
echo Build Tool: %BUILD_TOOL%

set GENERATOR="Visual Studio 17 2022"
if %BUILD_TOOL%==gcc set GENERATOR="MinGW Makefiles"
echo Generator: %GENERATOR%

set ARCH=
if %BUILD_TOOL%==msvc set ARCH=-A x64
echo Architecture: %ARCH%

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

if [%BUILD_DIR%] == [] set BUILD_DIR=%TEMP%\sfml
echo Using build directory: %BUILD_DIR%

if not exist "%BUILD_DIR%" (
    mkdir "%BUILD_DIR%"
    echo Making temporary directory  %BUILD_DIR%
)

for %%C in ("Debug" "Release") do (
echo Generate SFML build environment
cmake -G %GENERATOR% -S "%SOURCE_DIR%" -B "%BUILD_DIR%" -D CMAKE_INSTALL_PREFIX="%DEST_DIR%" ^
      -D CMAKE_BUILD_TYPE=%%C %ARCH% -D BUILD_SHARED_LIBS=OFF -D SFML_BUILD_EXAMPLES=OFF


echo Build SFML library
cmake --build "%BUILD_DIR%"  --clean-first --parallel 24 --config %%C

echo Install SFML library 
cmake  --install "%BUILD_DIR%" --config %%C --prefix "%DEST_DIR%"
)

echo Removing SFML build directory
rmdir "%BUILD_DIR%" /s /q