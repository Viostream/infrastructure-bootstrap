$cred = Get-Credential

$user = $cred.Username
$pass = ConvertFrom-SecureString $cred.Password

$pair = "$($user):$($pass)"

$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

$basicAuthValue = "Basic $encodedCreds"

$Headers = @{
    Authorization = $basicAuthValue
}

$BootStrapScript = Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Viostream/infrastructure/master/bootstrap/bootstrapLocalWindowsBuildEnvironment.cmd' -Headers $Headers
Invoke-Expression $($BootStrapScript.Content)
