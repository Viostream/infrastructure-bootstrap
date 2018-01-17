$cred = Get-Credential

$user = $cred.Username
$pass = ConvertFrom-SecureString $cred.Password

$pair = "$($user):$($pass)"

$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

$basicAuthValue = "Basic $encodedCreds"

$Headers = @{
    Authorization = $basicAuthValue
}

$BootStrapScript = Invoke-WebRequest -Uri 'https://github.com/Viostream/infrastructure/blob/bootstrap1.0/bootstrap/bootstrapLocalWindowsBuildEnvironment.cmd' -Headers $Headers
Invoke-Expression "cmd.exe /c $($BootStrapScript.Content)"
