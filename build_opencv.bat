rem Usage build_opencv SourceDir ContribDir DestDir BuildDir Tool.
rem SourceDir (%1) Full path to the OpenCV repository.
rem ContribDir (%2) Full path to the OpenCV contribution repository.
rem DestDir (%3) Full path to the destination directory (Example: k:/sfml/master.
rem BuildDir (%4) Full path to a temporary directory where the build is done.
rem Tool (%5) Choose gcc or msvc.
 
rem The build directory should exist. The build is done in a sub-directory.
rem You must use backslash in directory names (K:\foo not k:/foo)

set SOURCE_DIR=%1
set CONTRIB_DIR=%2
set DEST_DIR=%3
set BUILD_DIR=%4
set BUILD_TOOL=%5

if [%BUILD_TOOL%] == [] set BUILD_TOOL=msvc
echo Build Tool: %BUILD_TOOL%

set GENERATOR="Visual Studio 17 2022"
if %BUILD_TOOL%==gcc set GENERATOR="MinGW Makefiles"
echo Generator: %GENERATOR%

set ARCH=
if %BUILD_TOOL%==msvc set ARCH=-A x64
echo Architecture: %ARCH%

if [%SOURCE_DIR%] == [] (
    echo Error: OpenCV source directory must be supplied.
    exit /b 1
)

if not exist "%SOURCE_DIR%" (
    echo Error: OpenCV source directory must exist.
    exit /b 1
)

if [%CONTRIB_DIR%] == [] (
    echo Error: OpenCV contibution directory must be supplied.
    exit /b 1
)

if not exist "%CONTRIB_DIR%" (
    echo Error: OpenCV contribution directory must exist.
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

if [%BUILD_DIR%] == [] set BUILD_DIR=%TEMP%\opencv
echo Using build directory: %BUILD_DIR%

if not exist "%BUILD_DIR%" (
    mkdir "%BUILD_DIR%"
    echo Making temporary directory  %BUILD_DIR%
)

for %%C in ("Debug" "Release") do (
echo Generate OpenCV build environment
cmake -G %GENERATOR% -S "%SOURCE_DIR%" -B "%BUILD_DIR%" -D CMAKE_INSTALL_PREFIX="%DEST_DIR%" ^
      -D CMAKE_BUILD_TYPE=%%C %ARCH% -D BUILD_SHARED_LIBS=OFF ^
	  -D OPENCV_EXTRA_MODULES_PATH="%CONTRIB_DIR%/modules" -D BUILD_PERF_TESTS=OFF ^
	  -D BUILD_TESTS=OFF 


echo Build OpenCV library
cmake --build "%BUILD_DIR%"  --clean-first -j24 --config %%C

echo Install OpenCV library 
cmake  --install "%BUILD_DIR%" --config %%C --prefix "%DEST_DIR%"
)

echo Removing OpenCV build directory
rmdir "%BUILD_DIR%" /s /q