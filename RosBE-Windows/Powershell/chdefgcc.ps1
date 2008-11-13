#
# PROJECT:     RosBE - ReactOS Build Environment for Windows
# LICENSE:     GNU General Public License v2. (see LICENSE.txt)
# FILE:        Root/chdefgcc.cmd
# PURPOSE:     Tool to change the current gcc in RosBE.
# COPYRIGHT:   Copyright 2007 Daniel Reimer <reimer.daniel@freenet.de>
#                             Peter Ward <dralnix@gmail.com>
#

if ($_ROSBE_MODE -eq "RosBE") {
    $host.ui.RawUI.WindowTitle = "Change the current MinGW/GCC Host/Target directory..."
}

function EOA {
    IEX "&'$_ROSBE_BASEDIR\rosbe-gcc-env.cmd' chdefgcc"
}

function INTERACTIVE {
    $_1 = Read-Host "Please enter a MinGW/GCC directory (don't use quotes): "
    if ($_1 -eq $null) {
        "ERROR: You must enter a MinGW/GCC directory."
    }
    $_2 = Read-Host "Please specify, if this will be the Target or Host GCC: "
    if ($_2 -eq $null) {
        "ERROR: You must enter ""target"" or ""host""."
    }
}
if ($_ROSBE_VERSION -ne $null) {
    $host.ui.RawUI.WindowTitle = "ReactOS Build Environment $_ROSBE_VERSION"
}

#
# Parse the command line arguments.
#
$_1 = $args[0]
"$_1"
$_1 = IEX "& '$_ROSBE_BASEDIR\Tools\rquote.exe' '$_1'"
$_2 = $args[1]
if ($_1 -eq $null) {
    INTERACTIVE
}
if ($_2 -eq $null) {
    INTERACTIVE
}

if (Test-Path "$_ROSBE_BASEDIR\$_1\.") {
    $_1 = "$_ROSBE_BASEDIR\$_1"
} elseif (!(Test-Path "$_1\.")) {
    "ERROR: The path specified doesn't seem to exist."
}

if (!(Test-Path "$_1\bin\*gcc.exe")) {
    "ERROR: No MinGW/GCC found in the specified path."
}

if ($_2 -eq "target") {
    $_ROSBE_TARGET_MINGWPATH = $_1
    "Target Location: $_ROSBE_TARGET_MINGWPATH"
    EOA
}
if ($_2 -eq "host") {
    $_ROSBE_HOST_MINGWPATH = $_1
    "Host Location: $_ROSBE_HOST_MINGWPATH"
    EOA
} else {
    "ERROR: You specified wrong parameters."
}

#
# Unload all used Vars.
#
$_1 = $null
$_2 = $null