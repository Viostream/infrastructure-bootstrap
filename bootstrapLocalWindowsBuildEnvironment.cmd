@echo off
pause
echo Enter credentials to the Viostream GitHub repository...
set /p USERNAME= GitHub Username:
set /p PASSWORD= GitHub Password:
rem @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
rem choco install terraform -fy
rem choco install git -fy
mkdir tmp
cd tmp
git clone https://%USERNAME%:%PASSWORD%@github.com/Viostream/infrastructure
rem Provision new basic AWS account and TeamCity - Ask user for input
