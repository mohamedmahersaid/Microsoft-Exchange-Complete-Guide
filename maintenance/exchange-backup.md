
# Exchange Server Backup Strategy

Regular backups are critical for disaster recovery, data integrity, and compliance in Exchange Server environments.

---

## 1. What Should Be Backed Up

- Mailbox databases (`.edb`)
- Transaction logs
- System state (AD, OS)
- Exchange configuration
- Custom scripts or transport rules

---

## 2. Backup Methods

### Windows Server Backup (Built-in)

1. Install Windows Server Backup:
   ```powershell
   Install-WindowsFeature Windows-Server-Backup
   ```
2. Create backup schedule for:
   - Exchange installation directory
   - `C:\Program Files\Microsoft\Exchange Server\V15`
   - Database and log file paths

> ⚠️ Supports only VSS-based backups of mounted DBs

### Enterprise Backup Tools

- **Veeam**, **Veritas**, **Commvault**, etc.
- Use application-aware VSS plugins
- Ensure logs are properly truncated

---

## 3. Manual Backup of Databases

Use `eseutil` and `robocopy` (during downtime only):

```powershell
Dismount-Database -Identity "MailboxDB01"
robocopy "D:\ExchangeDBs\MailboxDB01" "E:\Backups\MailboxDB01" /MIR
Mount-Database -Identity "MailboxDB01"
```

---

## 4. Verify Backups

Use this command to verify:

```powershell
Get-MailboxDatabase | fl Name,BackupInProgress,LastFullBackup
```

---

## 5. Automating Backup Reports

Use Task Scheduler + PowerShell script to send backup status email.

---

## 6. Restore Strategy

- Use backup software console or:
```powershell
Restore-Database -Identity "MailboxDB01" -Recovery
```

---

## 7. Best Practices

- Schedule nightly backups
- Keep at least 3 copies (local + offsite/cloud)
- Regularly test restoration
- Monitor Event Logs: `Application` > `ESE` or `MSExchangeIS`
