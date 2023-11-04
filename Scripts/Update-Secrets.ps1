param (
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath,
    [string]$SecretsFilePath = "user-secrets.json",
    [string]$SecretsFileTemplateFilePath = "secrets-template.json"
)

function Update-Secrets {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectPath,
        [Parameter(Mandatory=$true)]
        [string]$SecretsFilePath,
        [Parameter(Mandatory=$true)]
        [string]$SecretsFileTemplateFilePath
    )

    $LocalSecretsFileExists = Test-Path $SecretsFilePath

    if ($LocalSecretsFileExists -eq $false) {
        Validate-SecretsFileTemplate-Exists $SecretsFileTemplateFilePath
        $SecretsFileTemplate = Get-JsonContent $SecretsFileTemplateFilePath
        Write-Host "No secrets file exists at '$SecretsFilePath'" -ForegroundColor Yellow
        Create-New-SecretsFile $SecretsFilePath $SecretsFileTemplate
    } else {
        Write-Host "Found secrets file at '$SecretsFilePath'." -ForegroundColor DarkCyan
        Write-Host "Current secrets:" -ForegroundColor DarkCyan
        List-Current-Secrets $ProjectPath
        Update-SecretsFile $ProjectPath $SecretsFilePath
        Write-Host "Secrets after update:" -ForegroundColor DarkCyan
        List-Current-Secrets $ProjectPath
    }
}

function Validate-SecretsFileTemplate-Exists {
    param (
        [string]$SecretsFileTemplateFilePath
    )

    if (-not (Test-Path -Path $SecretsFileTemplateFilePath -PathType Leaf)) {
        Write-Error "The specified secrets template file does not exist: $SecretsFileTemplateFilePath"
        exit 1
    }
}

function Get-JsonContent {
    param (
        [string]$SecretsFileTemplateFilePath
    )

    try {
        return Get-Content -Path $SecretsFileTemplateFilePath -Raw | ConvertFrom-Json
    }
    catch {
        Write-Error "Failed to read or parse the JSON file: $_"
        exit 1
    }
}

function Create-New-SecretsFile {
    param (
        [string]$SecretsFilePath,
        [object]$SecretsFileTemplate
    )

    $jsonContent = $SecretsFileTemplate | ConvertTo-Json
    $catchOutput = New-Item -ItemType "file" -Path $SecretsFilePath -Force -Value $jsonContent
    Write-Host "IMPORTANT: new secrets file created at '$SecretsFilePath', fill this file with your secrets and run this script again" -ForegroundColor Yellow
    exit 1
}

function Update-SecretsFile {
    param (
        [string]$ProjectPath,
        [string]$SecretsFilePath
    )

    try 
    {
        Init-Secrets $ProjectPath
        Write-Host "Clearing old secrets..." -ForegroundColor DarkCyan
        dotnet user-secrets clear --project $ProjectPath
        Write-Host "Setting new secrets..." -ForegroundColor DarkCyan
        type $SecretsFilePath | dotnet user-secrets set --project $ProjectPath
    }
    catch
    {
        Write-Host "An error occured while updating your secrets file." -ForegroundColor Red
        Write-Host $_
        exit 1
    }
    Write-Host "Secrets file succesfully updated!" -ForegroundColor Green
}

function Init-Secrets {
    param (
        [string]$ProjectPath
    )

     $_ = dotnet user-secrets init --project $ProjectPath
}

function List-Current-Secrets {
    param (
        [string]$ProjectPath
    )

    dotnet user-secrets list --json --project $ProjectPath
}

Update-Secrets $ProjectPath $SecretsFilePath $SecretsFileTemplateFilePath