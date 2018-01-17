@echo off
cd %TEMP%
echo.
echo Enter credentials to the Viostream GitHub repository...
set /p USERNAME= GitHub Username:
set /p PASSWORD= GitHub Password:
echo.
echo Press any key to install chocolatey...
pause > nul
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
echo.
echo Press any key to install terraform and git...
pause > nul
choco install terraform -y
choco install git -y
rmdir /Q /S infrastructure
echo.
echo Press any key to download terraform scripts from our GitHub repository...
pause > nul
git clone https://%USERNAME%:%PASSWORD%@github.com/Viostream/infrastructure infrastructure
cd infrastructure\terraform\teamcity-dev
echo.
echo Press any key to execute terraform init
pause > nul
terraform init
echo Finished bootstrap scripts.
pause
rem Provision new basic AWS account and TeamCity - Ask user for input
