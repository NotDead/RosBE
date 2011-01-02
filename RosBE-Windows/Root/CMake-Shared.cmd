::
:: PROJECT:     RosBE - ReactOS Build Environment for Windows
:: LICENSE:     GNU General Public License v2. (see LICENSE.txt)
:: FILE:        Root/CMake-Shared.cmd
:: PURPOSE:     Perform the CMake build of ReactOS - Shared commands.
:: COPYRIGHT:   Copyright 2010 Daniel Reimer <reimer.daniel@freenet.de>
::

@echo off
if not defined _ROSBE_DEBUG set _ROSBE_DEBUG=0
if %_ROSBE_DEBUG% == 1 (
    @echo on
)

if %_ROSBE_WRITELOG% == 1 (
    if not exist "%_ROSBE_LOGDIR%\." (
        mkdir "%_ROSBE_LOGDIR%" 1> NUL 2> NUL
    )
)

:: Setting for MinGW Compiler in CMake
set BUILD_ENVIRONMENT=MINGW

:: Get the current date and time for use in in our build log's file name.
call "%_ROSBE_BASEDIR%\TimeDate.cmd"

title '%TITLE_COMMAND%' cmake build started: %TIMERAW%   (%ROS_ARCH%)

:: Do the actual building
if %_ROSBE_SHOWTIME% == 1 (
    set BUILDTIME_COMMAND=buildtime.exe
) else (
    set BUILDTIME_COMMAND=
)

if not exist "host-tools\." (
    mkdir "host-tools" 1> NUL 2> NUL
)
cd host-tools

:: Variable with the Host Tools Path
set REACTOS_BUILD_TOOLS_DIR=%CD%

cmake.exe -G "MinGW Makefiles" -DARCH=%ROS_ARCH% ..\
if %_ROSBE_WRITELOG% == 1 (
    %BUILDTIME_COMMAND% mingw32-make.exe -j %MAKE_JOBS% %* 2>&1 | tee.exe "%_ROSBE_LOGDIR%\BuildToolLog-%ROS_ARCH%-%datename%-%timename%.txt"
) else (
    %BUILDTIME_COMMAND% mingw32-make.exe -j %MAKE_JOBS% %*
)
cd..
echo.

if not exist "reactos\." (
    mkdir "reactos" 1> NUL 2> NUL
)
cd reactos
cmake.exe -G "MinGW Makefiles" -DCMAKE_TOOLCHAIN_FILE=toolchain-mingw32.cmake -DARCH=%ROS_ARCH% -DREACTOS_BUILD_TOOLS_DIR:DIR="%REACTOS_BUILD_TOOLS_DIR%" ..\
if %_ROSBE_WRITELOG% == 1 (
    %BUILDTIME_COMMAND% mingw32-make.exe -j %MAKE_JOBS% %* 2>&1 | tee.exe "%_ROSBE_LOGDIR%\BuildROSLog-%ROS_ARCH%-%datename%-%timename%.txt"
) else (
    %BUILDTIME_COMMAND% mingw32-make.exe -j %MAKE_JOBS% %*
)
cd..

:EOC
:: Highlight the fact that building has ended.

if !errorlevel! GEQ 1 (
    playwav.exe error.wav
) else (
    playwav.exe notification.wav
)

flash.exe

title ReactOS Build Environment %_ROSBE_VERSION%