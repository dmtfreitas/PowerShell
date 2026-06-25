
# Watchdog_Started_with_Windows_PowerShell_ISE.ps1

$script_path      = ""
$python_file      = ""
$interval_seconds = 3600
$pause_file       = "$script_path\pause.flag"
$log_file         = "$script_path\watchdog.log"

function Log ($message) {

    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"; "$time - $message" | Tee-Object -FilePath $log_file -Append

}

function Get-Python {

    $pattern = [regex]::Escape($python_file)

    Get-CimInstance Win32_Process -Filter "Name LIKE 'python%'" | Where-Object { $_.CommandLine -and $_.CommandLine -match $pattern }

}

function Stop-Python {

    $targets = Get-Python

    if (-not $targets) {

        Log 'Not Found Process Script execution for Ending!'
        return

    }

    foreach ($p in $targets) {

        Log "Killed PID $($p.ProcessId) | $python_file"
        taskkill /PID $($p.ProcessId) /T /F 2>$null | Out-Null

    }

    Start-Sleep -Seconds 7.5

}

function Start-Python {

    Log 'Starting Scriptig Python: NFS-e_automation_rewind_days.py'
    Start-Process -FilePath "python" -ArgumentList $python_file -WorkingDirectory $script_path

}

Stop-Python

Log 'Watchdog Started with Windows PowerShell ISE...'

$last_restart = Get-Date

Start-Python

while ($true) {

    Start-Sleep -Seconds 10.5

    if (Test-Path $pause_file) {

        if (Get-Python) {

            Log 'Stoped Manually | Ending Process!'
            Stop-Python

        }

        continue
    }

    if (-not (Get-Python)) {

        Log 'Process Offline | Restarting!'

        Start-Python
        $last_restart = Get-Date
        continue
    }

    $elapsed = (Get-Date) - $last_restart

    if ($elapsed.TotalSeconds -ge $interval_seconds) {

        Log 'Restarting Programed | Ending and Restarting!'

        Stop-Python
        Start-Python
        $last_restart = Get-Date

    }

}