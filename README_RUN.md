Run project helper

This repository includes a convenience PowerShell script `run_project.ps1` to automate common local setup tasks.

Usage examples (PowerShell):

- Install deps, migrate, start server and open Edge:

  .\run_project.ps1 -OpenBrowser

Start both services with the helper script (recommended):
  powershell -NoProfile -ExecutionPolicy Bypass -File start_all.ps1 -StartDjango -StartAspNet

Start services individually (if you prefer separate terminals):
  - Django (foreground):
    & '.\.venv\Scripts\python.exe' manage.py runserver 127.0.0.1:8000
  - ASP.NET (foreground):
    cd OnlinePharmacyAspNet
    dotnet run --project OnlinePharmacyAspNet.csproj --urls "http://127.0.0.1:5000"

- Install deps, migrate, seed the medicines, create a superuser and open browser:

  .\run_project.ps1 -Seed -CreateSuperuser -OpenBrowser

Notes:
- `CreateSuperuser` will prompt for username, email and a secure password.
- The script requires Python in PATH and will use `python` to run manage.py commands.
- For production-like email sending, set SMTP env vars as described in `pharmacy_project/settings.py`.
