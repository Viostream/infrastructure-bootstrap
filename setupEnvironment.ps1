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
Write-Host You can cleanup this installation at any stage using \"choco uninstall terraform git.install -y\"
Write-Host

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

$chocoCmd = choco list --localonly | Where {$_ -like 'git.install *'}
if (!($chocoCmd)) {
	Write-Host
	Write-Host Choco package git not found. Installing...
	iex ("choco install git.install -y") -ErrorAction Stop
	refreshenv
}

$chocoCmd = choco list --localonly | Where {$_ -like 'terraform *'}
if (!($chocoCmd)) {
	Write-Host
	Write-Host Choco package terraform not found. Installing...
	iex ("choco install terraform -y") -ErrorAction Stop
	refreshenv
}

Write-Host Enter credentials to the Viostream GitHub repository...
Write-Host
$gitUser = Read-Host -Prompt "GitHub username"
$gitPass = Read-Host -Prompt "GitHub password" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($gitPass)
$gitPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
Write-Host
Write-Host Downloading terraform scripts from our GitHub repository...
if (Test-Path .\$workingDir) {
	Write-Host "Found previous working directory ${env:TEMP}\${workingDir}. Removing..."
	Remove-Item .\$workingDir -Force -Recurse
}

#git clone "https://${gitUser}:${gitPass}@github.com/Viostream/infrastructure" ${workingDir} 2>Out-Null
cmd /c "refreshenv && git clone https://${gitUser}:${gitPass}@github.com/Viostream/infrastructure ${workingDir} 2>NUL"
if ($LASTEXITCODE) {
		Write-Host "Error running: git clone https://github.com/Viostream/infrastructure ${workingDir}"
		exit 1
}


Write-Host
Write-Host Bootstrapping AWS environment using Terraform. Enter AWS parameters...
Write-Host
$AWS_ACCESS_KEY_ID = Read-Host -Prompt "AWS Access Key ID"
$AWS_SECRET_ACCESS_KEY = Read-Host -Prompt "AWS Secret Access Key"
$KEY_PATH = Read-Host -Prompt "Full path to an SSH private key used to build the TeamCity server"
$env:AWS_ACCESS_KEY_ID = $AWS_ACCESS_KEY_ID
$env:AWS_SECRET_ACCESS_KEY = $AWS_SECRET_ACCESS_KEY
$env:TF_VAR_access_key = $AWS_ACCESS_KEY_ID
$env:TF_VAR_secret_key = $AWS_SECRET_ACCESS_KEY
$env:TF_VAR_key_path = $KEY_PATH
$env:TF_VAR_gituser = $gitUser
$env:TF_VAR_gitpass = $gitPass

Write-Host
cd ${workingDir}\terraform\teamcity-dev
terraform init
Write-Host Destroying existing infrastructure
#terraform plan -destroy -out./destroy.plan.out
terraform destroy
#terraform plan -out=./rds.plan.out -target="module.db" -var "gitpass=${gitPass}" -var "gituser=${gitUser}" -var "access_key=${AWS_ACCESS_KEY_ID}" -var "secret_key=${AWS_SECRET_ACCESS_KEY}" -var "key_path=${KEY_PATH}" 

Write-Host Provisioning RDS instance
#terraform plan -out="./rds.plan.out" -target="module.db"
terraform apply -target="module.db"
if ($LASTEXITCODE) {
	Write-Host "Error provisioning teamcity RDS instance"
	exit 1
}

Write-Host Provisioning the rest of the teamcity infrastructure
terraform apply
if ($LASTEXITCODE) {
	Write-Host "Error provisioning teamcity"
	exit 1
}
Write-Host
cd $env:TEMP
#cd ${workingDir}\terraform\teamcity-dev
#Start-Process powershell
Start-Process cmd -ArgumentList "cd $workingDir\terraform\teamcity-dev"
Write-Host "End of script"
Write-Host
Write-Host "If you would like to uninstall terraform and git, please run:"
Write-Host "	choco uninstall terraform git.install -y"
Write-Host
