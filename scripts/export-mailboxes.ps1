
# Export all mailboxes to PST

$mailboxes = Get-Mailbox -ResultSize Unlimited
$exportPath = "C:\MailboxExports"

if (-Not (Test-Path $exportPath)) {
    New-Item -ItemType Directory -Path $exportPath
}

foreach ($mbx in $mailboxes) {
    $exportFile = "$exportPath\$($mbx.Alias).pst"
    New-MailboxExportRequest -Mailbox $mbx.Alias -FilePath $exportFile
    Write-Host "Started export for $($mbx.Alias)"
}
