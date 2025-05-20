Start-Transcript -Path "C:\Logs\DailyHealthCheck.txt"
Test-ServiceHealth
Test-ReplicationHealth
Get-Queue | Where-Object {$_.MessageCount -gt 10}
Stop-Transcript