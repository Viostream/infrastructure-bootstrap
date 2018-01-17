#Do Stuff
$file="bootstrapLocalWindowsBuildEnvironment.cmd"
cd $env:temp
$BootStrapScript = Invoke-WebRequest -Uri ("https://raw.githubusercontent.com/Viostream/infrastructure-bootstrap/master/" + $file)
$BootStrapScript.Content | Out-File $file -Encoding default
Invoke-Expression "cmd.exe /c $file"