param(
    [switch]$StartDjango = $true,
    [switch]$StartAspNet = $true
)

Write-Host "Starting 'start_all' helper..."
$proj = Split-Path -Parent $MyInvocation.MyCommand.Definition
Push-Location $proj

# Get python executable, prefer venv
$venv = Join-Path $proj ".venv\Scripts\python.exe"
if (Test-Path $venv) { $pyExe = $venv } else { $pyExe = (Get-Command python -ErrorAction SilentlyContinue).Source }

if ($StartDjango) {
    Write-Host "Starting Django dev server on 127.0.0.1:8000"
    $djangoArgs = @('manage.py','runserver','127.0.0.1:8000')
    Start-Process -FilePath $pyExe -ArgumentList $djangoArgs -WorkingDirectory $proj -NoNewWindow -PassThru | Out-Null
}

if ($StartAspNet) {
    Write-Host "Starting ASP.NET app on 127.0.0.1:5000"
    $aspArgs = 'run','--project','OnlinePharmacyAspNet/OnlinePharmacyAspNet.csproj','--urls','http://127.0.0.1:5000'
    Start-Process -FilePath 'dotnet' -ArgumentList $aspArgs -WorkingDirectory (Join-Path $proj 'OnlinePharmacyAspNet') -NoNewWindow -PassThru | Out-Null
}

Start-Sleep -Seconds 2

function Check-Http {
    param([string]$url)
    try { $r = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop; return $r.StatusCode } catch { return $null }
}

$d = Check-Http -url 'http://127.0.0.1:8000/'
$a = Check-Http -url 'http://127.0.0.1:5000/'

Write-Host "Django:" ($d -ne $null ? "$d OK" : "Not responding")
Write-Host "ASP.NET:" ($a -ne $null ? "$a OK" : "Not responding")

Pop-Location

Write-Host "start_all completed."