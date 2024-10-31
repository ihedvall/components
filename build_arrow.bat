rem Usage build_arrow SourceDir DestDir BuildDir Tool.
rem SourceDir (%1) Full path to the Apache Arrow CPP directory (inside repository).
rem DestDir (%2) Full path to the destination directory (Example: k:/arrow/latest.
rem BuildDir (%3) Full path to a temporary directory where the build is done. Default %TEMP%/arrow 
rem Tool (%4) Choose gcc or msvc.Default is msvc.
 
rem The build directory should exist. The build is done in a sub-directory.
rem You must use backslash in directory names (K:\foo not k:/foo)

set SOURCE_DIR=%1
set DEST_DIR=%2
set BUILD_DIR=%3
set BUILD_TOOL=%4

rem Set default build tool to Microsoft Visual C++
if [%BUILD_TOOL%] == [] set BUILD_TOOL=msvc
echo Build Tool: %BUILD_TOOL%

set GENERATOR="Visual Studio 17 2022"
if %BUILD_TOOL%==gcc set GENERATOR="MinGW Makefiles"
echo Generator: %GENERATOR%

set ARCH=
if %BUILD_TOOL%==msvc set ARCH=-A x64
echo Architecture: %ARCH%

rem Check that the source directory not is empty and that it exist.
if [%SOURCE_DIR%] == [] (
    echo Error: Source directory must be supplied.
    exit /b 1
)

if not exist "%SOURCE_DIR%" (
    echo Error: Source directory must exist.
    exit /b 1
)

rem Check that the destination directory not is empty.
rem Create directory if it doesn't exists.
if [%DEST_DIR%] == [] (
    echo Error: Destination directory must be supplied.
    exit /b 1
)

if not exist "%DEST_DIR%" (
    mkdir "%DEST_DIR%"
    echo Making destination directory: %DEST_DIR%
)

rem The build directory is normally not supplied.
rem Create a temporary directory in the temp path.
if [%BUILD_DIR%] == [] set BUILD_DIR=%TEMP%\arrow
echo Using temporary directory: %BUILD_DIR%

if not exist "%BUILD_DIR%" (
    mkdir "%BUILD_DIR%"
    echo Making temporary directory  %BUILD_DIR%
)

rem Time to generate, build and install for Debug and Release.
for %%C in ("Debug" "Release") do (
echo Generate ARROW build environment
cmake -G %GENERATOR% -S "%SOURCE_DIR%" -B "%BUILD_DIR%" -D CMAKE_INSTALL_PREFIX="%DEST_DIR%" ^
      -D CMAKE_BUILD_TYPE=%%C %ARCH% -D CMAKE_DEBUG_POSTFIX=d ^
	  -D ARROW_BUILD_SHARED=OFF -D ARROW_BOOST_USE_SHARED=OFF ^
      -D ARROW_CSV=ON -D ARROW_DEPENDENCY_USE_SHARED=OFF ^ 
	  -D ARROW_UTF8PROC_USE_SHARED=OFF -D Boost_DIR="k:/boost/latest"
	  

echo Build ARROW library
cmake --build "%BUILD_DIR%"  --clean-first --parallel 24 --config %%C

echo Install ARROW library 
cmake  --install "%BUILD_DIR%" --config %%C --prefix "%DEST_DIR%"
)

echo Removing ARROW build directory
rmdir "%BUILD_DIR%" /s /q