
# Exchange Log Troubleshooting Script

$database = "MailboxDB01"
$dbPath = "D:\Database\MailboxDB01.edb"
$logPath = "D:\Logs"

Write-Host "Checking database header information..."
eseutil /mh $dbPath

Write-Host "`nIf database is in Dirty Shutdown, try soft recovery:"
eseutil /r E00 /l $logPath /d "D:\Database" /i

Write-Host "`nIf logs are missing and database won't mount, try hard recovery:"
Write-Host "eseutil /p $dbPath"
Write-Host "Then: eseutil /d $dbPath && eseutil /g $dbPath"

Write-Host "`nAttempt to mount database:"
Mount-Database -Identity $database -Force
