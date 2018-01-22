# Open up a new window and execute the main bootstrap script downloaded from our public GitHub repo

$workingDir = "infrastructure"
cd $env:TEMP

Write-Host
Write-Host This script will:
Write-Host   1. Install chocolatey package manager
Write-Host   2. Install terraform
Write-Host   3. Install git
Write-Host   4. Clone the Viostream Infrastructure GitHub repository
Write-Host   5. Use terraform to bootstrap a new AWS environment and provision TeamCity
Write-Host
Write-Host You can cleanup the above at any stage using choco uninstall
Write-Host
Write-Host Enter credentials to the Viostream GitHub repository...
Write-Host
$gitUser = Read-Host -Prompt "GitHub username"
$gitPass = Read-Host -Prompt "GitHub password" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($gitPass)
$gitPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

try { 
	$chocoCmd = Get-Command choco -ErrorAction Stop
} catch {
	Write-Host
	Write-Host Chocolatey not found. Installing...
	
	iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
	
	if (!($?)) {
		$env:Path += ";" + "$env:ALLUSERSPROFILE" + "\chocolatey\bin"
	}
} 

#git.install 
$chocoCmd = choco list --localonly | Where {$_ -like 'git.install *'}
if (!($chocoCmd)) {
	Write-Host
	Write-Host Choco package git not found. Installing...
	iex ("choco install git.install -y") -ErrorAction Stop
	refreshenv
}

Write-Host
Write-Host Downloading terraform scripts from our GitHub repository...
if (Test-Path .\$workingDir) {
	Write-Host "Found previous working directory ${env:TEMP}\${workingDir}. Removing..."
	Remove-Item .\$workingDir -Force -Recurse
}

#git clone "https://${gitUser}:${gitPass}@github.com/Viostream/infrastructure" ${workingDir} 2>Out-Null
cmd /c "refreshenv && git clone https://github.com/Viostream/infrastructure ${workingDir}"
if ($LASTEXITCODE) {
		Write-Host "Error running: git clone https://github.com/Viostream/infrastructure ${workingDir}"
		exit 1
}

$chocoCmd = choco list --localonly | Where {$_ -like 'terraform *'}
if (!($chocoCmd)) {
	Write-Host
	Write-Host Choco package terraform not found. Installing...
	iex ("choco install terraform -y") -ErrorAction Stop
	refreshenv
}

cd ${workingDir}\terraform\teamcity-dev
Write-Host
Write-Host Initialising Terraform. Enter AWS environment parameters...
Write-Host
$AWS_ACCESS_KEY_ID = Read-Host -Prompt "AWS Access Key ID"
$AWS_SECRET_ACCESS_KEY = Read-Host -Prompt "AWS Secret Access Key"
$env:AWS_ACCESS_KEY_ID = $AWS_ACCESS_KEY_ID
$env:AWS_SECRET_ACCESS_KEY = $AWS_SECRET_ACCESS_KEY
Write-Host
#terraform init -var gitpass=${gitPass} -var gituser=${gitUser} -var access_key=${AWS_ACCESS_KEY_ID} -var secret_key=${AWS_SECRET_ACCESS_KEY}
terraform init
Write-Host Provision the RDS instance and its pre-requisites
#-auto-approve
terraform apply -target=module.db -var gitpass=${gitPass} -var gituser=${gitUser} -var access_key=${AWS_ACCESS_KEY_ID} -var secret_key=${AWS_SECRET_ACCESS_KEY} -auto-approve
terraform apply -var gitpass=${gitPass} -var gituser=${gitUser} -var access_key=${AWS_ACCESS_KEY_ID} -var secret_key=${AWS_SECRET_ACCESS_KEY} -auto-approve
Write-Host
Write-Host Finished script. Cleaning up...
Write-Host "Removing ${env:TEMP}\${workingDir}"
cd $env:TEMP
Remove-Item "${env:TEMP}\${workingDir}" -Force -Recurse
Write-Host
Write-Host "If you would like to uninstall terraform and git, please run:"
Write-Host "	choco uninstall terraform git.install -y"
Write-Host
