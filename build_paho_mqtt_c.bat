rem Usage build_paho_mqtt_c <SourceDir> <DestDir> <BuildDir> <Tool>. 
rem <SourceDir> (%1) Full path to the Eclipse Paho MQTT C repository.
rem <DestDir> (%2) Full path to the destination directory (Example: k:\mqttc\master.
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

rmdir "%BUILD_DIR%\mqttc" /s /q
mkdir "%BUILD_DIR%\mqttc"
mkdir "%DEST_DIR%"


for %%C in ("Debug" "Release") do (

echo Generate MQTT C build environment
cmake -G %GENERATOR% -S "%SOURCE_DIR%" -B "%BUILD_DIR%\mqttc" -D CMAKE_INSTALL_PREFIX="%DEST_DIR%" -D CMAKE_BUILD_TYPE=%%C %ARCH% -D PAHO_BUILD_STATIC=ON -D PAHO_BUILD_SHARED=OFF -D PAHO_WITH_SSL=ON -D PAHO_ENABLE_TESTING=OFF

echo Build MQTT C library
cmake --build "%BUILD_DIR%\mqttc"  --clean-first --parallel 24 --config %%C

echo Install MQTT C library 
cmake  --install "%BUILD_DIR%\mqttc" --config %%C --prefix "%DEST_DIR%"

)

echo Removing MQTT C build directory
rmdir "%BUILD_DIR%\mqttc" /s /q
