
# rasdial_VPN_Wiser_Tecnologia.ps1

$name = 'VPN_Wiser_Tecnologia'
$user = ''
$password = ''

$vpn = Get-VpnConnection -Name $name -ErrorAction SilentlyContinue

while ($true) {

    if (-not $vpn) {

        Write-Host 'VPN VPN_Wiser_Tecnologia not found!' -ForegroundColor DarkRed -ErrorAction SilentlyContinue
        Exit

    }

    if ($vpn.ConnectionStatus -eq 'Connected') {
        Write-Host 'VPN VPN_Wiser_Tecnologia is connected!' -ForegroundColor DarkCyan -ErrorAction SilentlyContinue
    } else {

        Write-Host 'Connecting to the VPN VPN_Wiser_Tecnologia' -ForegroundColor Yellow -ErrorAction SilentlyContinue

        rasdial.exe $name $user $password | Out-Null

        if ($vpn.ConnectionStatus -eq 'Connected') { 
            Write-Host 'VPN VPN_Wiser_Tecnologia is connected!' -ForegroundColor Green -ErrorAction SilentlyContinue
        } else {
            Write-Host 'Unable to connect to the VPN VPN_Wiser_Tecnologia' -ForegroundColor Red -ErrorAction SilentlyContinue
        }

    }

    Start-Sleep -Seconds 3600 -ErrorAction SilentlyContinue

}
