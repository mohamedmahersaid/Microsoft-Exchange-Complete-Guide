
# Exchange Server Monitoring Script

$servers = Get-ExchangeServer | Where-Object {$_.IsMailboxServer -eq $true}

foreach ($server in $servers) {
    Write-Host "Checking server: $($server.Name)" -ForegroundColor Cyan

    # Services
    Get-Service *Exchange* -ComputerName $server.Name | Where-Object {$_.Status -ne 'Running'} |
        Format-Table Name, Status

    # Replication health (if DAG)
    Test-ReplicationHealth -Identity $server.Name | Format-Table Check, Result, Error

    # Queue
    Get-Queue -Server $server.Name | Format-Table Identity, MessageCount, Status
}
