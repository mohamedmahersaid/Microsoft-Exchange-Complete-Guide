
# Exchange Health Check Script

Write-Host "Exchange Health Check - Summary" -ForegroundColor Cyan

# Check service status
Write-Host "`n[Services Status]"
Get-Service *Exchange* | Where-Object {$_.Status -ne 'Running'} | Select Name, Status

# Check DAG replication (if applicable)
Write-Host "`n[DAG Replication Health]"
Get-MailboxServer | Where {$_.DatabaseCopyAutoActivationPolicy -ne "Blocked"} | ForEach-Object {
    Test-ReplicationHealth -Identity $_.Name
}

# Check Mailbox Database Mount Status
Write-Host "`n[Database Mount Status]"
Get-MailboxDatabaseCopyStatus * | Select Name, Status, ContentIndexState

# Check mail queue
Write-Host "`n[Mail Queue Status]"
Get-Queue | Select Identity, Status, MessageCount

# Summary status
Write-Host "`nCheck completed. Please review logs and take action if needed." -ForegroundColor Green
