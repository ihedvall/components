rem Usage build_boost <SourceDir> <DestDir> <BuildDir> <Tool> 
rem <SourceDir> (%1) Full path to the boost downloaded source files directory.
rem <DestDir> (%2) Full path to the destination directory (Example: k:/boost/boost_1_79_0).
rem <BuildDir> (%3) Full path to a temporary directory where the build is done. The directory should exist.
rem <Tool> (%4) Choose according to bootstrap.bat:  gcc, clang or msvc. 
 
rem The build directory should exist. The build is done in a sub-directory.
rem You must use backslash in directory names (K:\foo not k:/foo)

set SOURCE_DIR=%1
set DEST_DIR=%2
set BUILD_DIR=%3
set BUILD_TOOL=%4

if [%BUILD_TOOL%] == [] set BUILD_TOOL=vc143
echo Build Tool: %BUILD_TOOL%

if [%SOURCE_DIR%] == [] (
    echo Error: Source directory must be supplied.
    exit /b 1
)

if not exist "%SOURCE_DIR%" (
    echo Error: Source directory must exist.
    exit /b 1
)
if not exist "%SOURCE_DIR%\boost" (
    echo Error: Source directory must include a boost directory.
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
if not exist "%DEST_DIR%\boost" (
    mkdir "%DEST_DIR%\boost"
    echo Making destination directory: %DEST_DIR%\boost
)

if [%BUILD_DIR%] == [] set BUILD_DIR=%TEMP%\boost
echo Using build directory: %BUILD_DIR%

if not exist "%BUILD_DIR%" (
    mkdir "%BUILD_DIR%"
    echo Making temporary directory  %BUILD_DIR%
)


set B2_TOOLSET=vc143
if %BUILD_TOOL%==gcc set B2_TOOLSET=%BUILD_TOOL%
if %BUILD_TOOL%==clang set B2_TOOLSET=%BUILD_TOOL%



echo Copy the boost header files first

mkdir "%DEST_DIR%\lib"
robocopy "%SOURCE_DIR%\boost" "%DEST_DIR%\boost" /MIR /MT /COMPRESS /Z /NFL /NJH /NDL /NC /NS /TEE

echo Building the BJAM
pushd %SOURCE_DIR%
call bootstrap.bat %B2_TOOLSET% 

echo Building BOOST libraries
b2 address-model=64 link=static threading=multi runtime-link=shared --build-type=complete stage --build-dir="%BUILD_DIR%\%BUILD_TOOL%" --stagedir="%BUILD_DIR%\stage/%BUILD_TOOL%" -d0 -j24

echo Copy BOOST libraries
robocopy "%BUILD_DIR%\stage\%BUILD_TOOL%\lib" "%DEST_DIR%\lib" /mt /compress /z /nfl /ndl /njh /nc /ns /s

echo Removing BOOST build directory
rem rmdir "%BUILD_DIR%" /s /q

popd