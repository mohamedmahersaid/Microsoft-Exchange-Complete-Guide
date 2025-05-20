# Monitoring Exchange Server Health and Performance

Ongoing monitoring is essential for maintaining the health, availability, and performance of Microsoft Exchange. This guide outlines native tools and techniques to perform regular health checks.

---

## 🔧 Built-in Exchange Monitoring Tools

| Tool/Feature         | Purpose                                      |
|----------------------|----------------------------------------------|
| Managed Availability | Built-in health probes and alerts            |
| Performance Monitor  | Tracks resource usage and thresholds         |
| Exchange Admin Center| Dashboard view for mail flow and queues      |
| Event Viewer         | Critical logs for transport and system health|
| Queue Viewer         | Monitor mail queues and message flow         |

---

## 🧪 Test Replication and DAG Health

```powershell
Test-ReplicationHealth
Get-MailboxDatabaseCopyStatus * | ft Name,Status,CopyQueueLength,ReplayQueueLength
```

---

## 📈 Monitor Transport Queues

```powershell
Get-Queue | ft Identity,Status,MessageCount,NextHopDomain
```

Use Queue Viewer in EAC for UI-based view.

---

## 🧠 Check Server Health State

```powershell
Get-ServerHealth -Identity EX01 | ? {$_.AlertValue -ne "Healthy"}
```

List failing probes:

```powershell
Get-HealthReport -Identity EX01 | ? {$_.Result -ne "Healthy"}
```

---

## 🗂️ Event Log Review

Check logs for critical service status and failures:

- `Application` log for Exchange-specific events
- `System` log for OS/network issues
- Filter Event IDs:
  - 1003, 12014 (Transport)
  - 4999, 1000 (Application crashes)
  - 2140 (Logon errors)

---

## 📊 Performance Monitor (PerfMon)

Track counters for:

- `MSExchangeIS Store`
- `MSExchangeTransport`
- `Processor(_Total)\% Processor Time`
- `LogicalDisk(_Total)\% Free Space`

---

## 📤 Mail Flow Tests

```powershell
Test-Mailflow -TargetEmailAddress admin@contoso.com
```

Use Remote Connectivity Analyzer:  
https://testconnectivity.microsoft.com

---

## 📅 Scheduled Health Check Script

Schedule this via Task Scheduler or automation:

```powershell
Start-Transcript -Path "C:\Logs\ExchangeHealth.txt"

Test-ReplicationHealth
Get-Queue
Get-ServerHealth EX01 | ? {$_.AlertValue -ne "Healthy"}

Stop-Transcript
```

---

## ✅ Best Practices

- Review `C:\Program Files\Exchange Server\V15\Logging\Monitoring\` regularly
- Centralize logs using Windows Event Forwarding or SIEM
- Document thresholds for SLA response
- Monitor DAG lagged copies and replay status

---

## 🔄 Next:
- `integration/sharepoint-teams.md` – Integrate Exchange with SharePoint and Microsoft Teams.