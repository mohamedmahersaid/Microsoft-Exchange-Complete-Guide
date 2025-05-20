
# Check Exchange 2019 prerequisites

Write-Host "Checking .NET version..."
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -Name Release

Write-Host "Checking required Windows features..."
$features = @(
    "RSAT-ADDS", "Web-Server", "Web-Mgmt-Console", "Web-Metabase",
    "Web-Asp-Net45", "Web-Windows-Auth", "Web-Basic-Auth",
    "Web-Digest-Auth", "Web-Dyn-Compression", "Web-ISAPI-Ext",
    "Web-ISAPI-Filter", "Web-Net-Ext45", "Web-Request-Monitor",
    "Web-Static-Content", "WAS-Process-Model", "Web-Http-Redirect",
    "Web-WebSockets", "NET-Framework-Features", "NET-Framework-45-Features",
    "Windows-Identity-Foundation"
)

foreach ($feature in $features) {
    $result = Get-WindowsFeature -Name $feature
    if ($result.Installed) {
        Write-Host "$feature is installed"
    } else {
        Write-Host "$feature is NOT installed"
    }
}
