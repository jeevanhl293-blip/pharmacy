param(
    [switch]$Seed,
    [switch]$CreateSuperuser,
    [switch]$OpenBrowser
)

Set-StrictMode -Version Latest
$proj = Split-Path -Parent $MyInvocation.MyCommand.Definition
Push-Location $proj

Write-Host "Working directory: $proj"

Write-Host "1) Installing Python dependencies from requirements.txt (may take a few minutes)"
python -m pip install -r requirements.txt

Write-Host "2) Making and applying migrations"
python manage.py makemigrations --noinput
python manage.py migrate --noinput

if ($Seed) {
    Write-Host "3) Running medicine seeder (management command)"
    python manage.py add_comprehensive_medicines
}

if ($CreateSuperuser) {
    # Ask for credentials
    $username = Read-Host "Superuser username"
    $email = Read-Host "Superuser email"
    $password = Read-Host -AsSecureString "Superuser password"
    # Convert secure string to plain for passing to script
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
    $plain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)

    Write-Host "Creating superuser..."
    python create_superuser.py $username $email $plain
}

Write-Host "Starting Django development server on 127.0.0.1:8000 (bind to localhost for dev)"
Start-Process -NoNewWindow -FilePath python -ArgumentList "manage.py runserver 127.0.0.1:8000"
Start-Sleep -Seconds 1
Write-Host "Checking if server is listening on 127.0.0.1:8000..."
try {
    $r = Invoke-WebRequest -UseBasicParsing -Uri http://127.0.0.1:8000/ -TimeoutSec 5 -ErrorAction Stop
    Write-Host "Server responded: $($r.StatusCode)"
} catch {
    Write-Host "Server did not respond to HTTP check. If you see 'can't reach', check the output of 'python manage.py runserver' and firewall settings."
}

if ($OpenBrowser) {
    Start-Sleep -Seconds 1
    Start-Process msedge 'http://localhost:8000'
}

Pop-Location
