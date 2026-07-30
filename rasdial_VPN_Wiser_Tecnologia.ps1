
# rasdial_VPN_Wiser_Tecnologia.ps1

$name = "VPN_Wiser_Tecnologia"
$user = ""
$password = ""

function Test-VpnConnected {

    param([string]$VpnName)

    $connection = Get-VpnConnection -Name $VpnName -ErrorAction SilentlyContinue

    if (-not $connection) {
        $connection = Get-VpnConnection -Name $VpnName -AllUserConnection -ErrorAction SilentlyContinue
    }

    if ($connection -and $connection.ConnectionStatus -eq "Connected") {
        return $true
    }

    $rasdial_output = rasdial.exe 2> $null

    if ($rasdial_output -match [regex]::Escape($VpnName)) {
        return $true
    }

    return $false
}

$exists_connection = Get-VpnConnection -Name $name -ErrorAction SilentlyContinue

if (-not $exists_connection) {
    $exists_connection = Get-VpnConnection -Name $name -AllUserConnection -ErrorAction SilentlyContinue
}

if (-not $exists_connection) {
    Write-Host "VPN $name not found!" -ForegroundColor DarkRed
    Exit
}

while ($true) {

    $timestamp = Get-Date -Format "dd/MM/yyyy HH:mm:ss"

    if (Test-VpnConnected -VpnName $name) {
        Write-Host "[$timestamp] VPN $name is connected!" -ForegroundColor DarkCyan
    } else {

        Write-Host "[$timestamp] Connecting to the VPN $name" -ForegroundColor Yellow

        rasdial.exe $name $user $password | Out-Null

        Start-Sleep -Seconds 10.5

        if (Test-VpnConnected -VpnName $name) {
            Write-Host "[$timestamp] VPN $name is connected!" -ForegroundColor Green
        } else {
            Write-Host "[$timestamp] Unable to connect to the VPN $name" -ForegroundColor Red
        }
    }

    Start-Sleep -Seconds 60.5
}
