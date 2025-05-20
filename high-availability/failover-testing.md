
# Testing DAG Failover

Testing failover ensures your Exchange DAG can recover automatically from outages.

---

## 1. Manual Switchover (Planned)

### Move active database to another server:

```powershell
Move-ActiveMailboxDatabase -Identity "MailboxDB01" -ActivateOnServer "EX02" -Confirm:$false
```

---

## 2. Simulate Failure

### Stop Exchange services on active node:

```powershell
Stop-Service MSExchangeIS
```

Monitor failover via:

```powershell
Get-MailboxDatabaseCopyStatus *
```

---

## 3. Check Replication Health

```powershell
Test-ReplicationHealth "EX01"
Test-ReplicationHealth "EX02"
```

---

## 4. Monitor via EAC

1. Go to **servers > database availability groups**
2. View replication, health, and activation preferences

---

## 5. Additional PowerShell Tools

```powershell
Get-MailboxDatabase | Format-Table Name,MountedOnServer
Get-MailboxDatabaseCopyStatus | Format-List
```

---

## 6. Recommended Practice

- Test failover during maintenance windows
- Regularly review failover logs and events
