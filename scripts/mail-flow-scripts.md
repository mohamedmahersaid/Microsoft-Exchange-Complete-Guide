# Exchange Mail Flow PowerShell Scripts

This section provides ready-to-use PowerShell scripts to monitor, test, and troubleshoot Exchange mail flow efficiently.

---

## 📤 Script: Test Mail Flow End-to-End

Sends a test message from a mailbox to a recipient and validates delivery.

```powershell
$from = "testuser@contoso.com"
$to = "admin@contoso.com"
Send-MailMessage -From $from -To $to -Subject "Test Message" -Body "Hello from Exchange" -SmtpServer "localhost"

Start-Sleep -Seconds 10
Test-Mailflow -TargetEmailAddress $to
```

---

## 🕓 Script: Monitor Queue Status

Shows all queues with message counts and potential issues.

```powershell
Get-Queue | Select Identity, MessageCount, Status, DeliveryType, NextHopDomain
```

---

## 📥 Script: Trace Message Delivery

```powershell
$recipient = "admin@contoso.com"
Get-MessageTrackingLog -Recipients $recipient -Start (Get-Date).AddHours(-1) | `
  Select Timestamp, Sender, Recipients, EventId, Source, MessageSubject
```

---

## 🔍 Script: List All Send/Receive Connectors

```powershell
Get-ReceiveConnector | Select Name, Bindings, RemoteIPRanges
Get-SendConnector | Select Name, AddressSpaces, SmartHosts
```

---

## 🧼 Script: Flush or Remove Messages from Queue

```powershell
# Suspend all messages in a queue
Suspend-Message -Filter {Queue -eq "EX01\Submission"}

# Remove all messages to a failed domain
Remove-Message -Filter {NextHopDomain -eq "external.com"} -WithNDR $false
```

---

## 🛡️ Script: Test TLS and Secure Connector

```powershell
Test-SmtpConnectivity -Identity "OutboundInternet" -UseSsl -Port 25 -HelloDomain "contoso.com"
```

---

## ✅ Best Practices

- Run scripts as `Exchange Management Shell` admin
- Schedule queue monitoring via Task Scheduler
- Use `Transcript` logging when troubleshooting:

```powershell
Start-Transcript -Path "C:\Logs\MailFlowDiag.txt"
# run diagnostics
Stop-Transcript
```

---

### 🔄 Next:
- `security/tls-best-practices.md` – Enforce and validate secure email transport.