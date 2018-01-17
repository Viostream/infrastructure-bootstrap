$BootStrapScript = Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Viostream/infrastructure-bootstrap/master/bootstrapLocalWindowsBuildEnvironment.cmd'
$BootStrapScript.Content | Out-File $env:temp\bootstrapLocalWindowsBuildEnvironment.cmd -Encoding UTF8
$BootStrapScript.Content > $env:temp\bootstrapLocalWindowsBuildEnvironment.cmd
Invoke-Expression "cmd.exe /c $env:temp\bootstrapLocalWindowsBuildEnvironment.cmd"