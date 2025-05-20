# Exchange Server Backup and Database Recovery

Reliable backup and recovery processes are critical to ensure business continuity in Microsoft Exchange environments. This guide outlines strategies for backing up Exchange and recovering databases after failures or disasters.

---

## 🎯 Backup Objectives

- Recover from hardware failure or corruption
- Restore deleted mailboxes or items
- Enable point-in-time recovery (PITR)
- Support compliance and litigation hold scenarios

---

## 🔄 Supported Backup Methods

| Method               | Tool/Technology                     | Notes                                      |
|----------------------|-------------------------------------|--------------------------------------------|
| VSS-Based Backup     | Windows Server Backup, Veeam, DPM   | Must be application-aware (VSS writer)     |
| Manual Backup        | File copy (disconnected DBs only)   | Not supported for online/live databases    |
| DAG Copy Backups     | Backup passive DAG member           | Offloads IO from active servers            |
| Third-Party API      | Exchange-aware backup agents        | Granular mailbox or item-level recovery    |

---

## 🧱 Backup Best Practices

- Use a **DAG** for redundancy, and back up passive copies
- Always back up both **EDB + log files**
- Ensure **circular logging is disabled** for full recovery
- Use **Volume Shadow Copy Service (VSS)** compatible tools

---

## 💾 Common Backup Paths

| Component     | Location                                      |
|---------------|-----------------------------------------------|
| Database (.edb)| `C:\ExchangeDatabases\MailboxDB01.edb`       |
| Log files     | `C:\ExchangeDatabases\MailboxDB01.log`       |
| Transport logs| `C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs` |

---

## 🛠️ Recovery Scenarios

### 🧨 1. Soft Recovery (e.g., dirty shutdown)

```powershell
eseutil /r E00 /l "C:\Logs" /d "C:\ExchangeDatabases\MailboxDB01.edb"
```

Check status:

```powershell
eseutil /mh "C:\ExchangeDatabases\MailboxDB01.edb"
```

---

### ♻️ 2. Restore from Backup

1. Restore files from backup (EDB, logs)
2. Mount database:

```powershell
Mount-Database -Identity "MailboxDB01"
```

If logs are missing:

```powershell
Mount-Database -Identity "MailboxDB01" -Force
```

---

### 🧪 3. Dial Tone Recovery (Temporary Mailboxes)

1. Create a blank DB with same name
2. Swap the DB with the original mailbox
3. Restore data to Recovery DB later

```powershell
New-MailboxDatabase -Name "DT-MailboxDB01" -EdbFilePath ...
```

---

### 🛡️ 4. Recovery Database (RDB)

Used to recover disconnected mailboxes:

```powershell
New-MailboxDatabase -Recovery -Name "RDB01" -EdbFilePath "C:\Recovery\RDB01.edb"
Mount-Database "RDB01"

Restore-Mailbox -Identity "user@contoso.com" -RecoveryDatabase "RDB01"
```

---

## ✅ Recovery Best Practices

- Keep backups off-site or replicated
- Automate regular integrity checks with `New-MailboxRepairRequest`
- Document all backup/restore procedures and test quarterly

---

## 🔄 Next:
- `troubleshooting/common-issues.md` – Fix typical failures and service problems.