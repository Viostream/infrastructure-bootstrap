# Intermediate bootstrap script
# Open up a new window and execute the main bootstrap script downloaded from our public GitHub repo

$file="bootstrapLocalWindowsBuildEnvironment.cmd"

$BootStrapScript = Invoke-WebRequest -Uri ("https://raw.githubusercontent.com/Viostream/infrastructure-bootstrap/master/" + $file)
$BootStrapScript.Content | Out-File "$env:temp\$file" -Encoding default
Start-Process "cmd.exe" -argument "/k $env:temp\$file"