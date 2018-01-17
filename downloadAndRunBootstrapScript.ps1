#Do Stuff
$BootStrapScript = Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Viostream/infrastructure-bootstrap/master/bootstrapLocalWindowsBuildEnvironment.cmd'
$BootStrapScript.Content | Out-File $env:temp\bootstrapLocalWindowsBuildEnvironment.cmd -Encoding default
Invoke-Expression "cmd.exe /c $env:temp\bootstrapLocalWindowsBuildEnvironment.cmd"