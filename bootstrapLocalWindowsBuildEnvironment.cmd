@echo off

set USERNAME=%1
set PASSWORD=%2

:: Run in Command Prompt (cmd.exe)
:: This script will install both the Chocolately .exe file and add the
:: choco command to your PATH variable﻿﻿

@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

:: Install all the packages
:: -y confirm yes for any prompt during the install process ﻿

choco install terraform -fy
choco install git -fy

mkdir tmp
cd tmp
git clone https://%USERNAME%:%PASSWORD%@github.com/Viostream/infrastructure

:: Provision new basic AWS account and TeamCity - Ask user for input
