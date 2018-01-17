@echo off
cd %TEMP%
echo Current working directory is %CD%
echo
echo Enter credentials to the Viostream GitHub repository...
echo
set /p USERNAME= GitHub Username:
set /p PASSWORD= GitHub Password:
echo
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
choco install terraform -y
choco install git -y
rmdir /Q /S infrastructure
git clone https://%USERNAME%:%PASSWORD%@github.com/Viostream/infrastructure infrastructure
cd infrastructure
terraform init
echo Finished bootstrap scripts.
pause
rem Provision new basic AWS account and TeamCity - Ask user for input
