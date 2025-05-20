
# Automated Cleanup of Exchange Logs (30+ days)

$logPath = "C:\Program Files\Microsoft\Exchange Server\V15\Logging"
$daysOld = 30

Write-Host "Cleaning up logs older than $daysOld days from $logPath..."

Get-ChildItem -Path $logPath -Recurse -Include *.log |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$daysOld) } |
    Remove-Item -Force

Write-Host "Cleanup completed."
