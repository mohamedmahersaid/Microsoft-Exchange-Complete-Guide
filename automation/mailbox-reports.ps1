
# Generate Mailbox Size Report

$output = "C:\Reports\MailboxSizeReport.csv"

if (-not (Test-Path "C:\Reports")) {
    New-Item -ItemType Directory -Path "C:\Reports"
}

Get-Mailbox -ResultSize Unlimited | Get-MailboxStatistics | Select DisplayName, TotalItemSize, ItemCount, LastLogonTime |
    Export-Csv -NoTypeInformation -Path $output

Write-Host "Mailbox report saved to $output"
