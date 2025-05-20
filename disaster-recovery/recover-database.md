
# Recovering a Corrupted or Dismounted Exchange Database

This guide provides steps for soft and hard recovery of Exchange mailbox databases.

---

## 1. Identify the Problem

Run the following command to list database statuses:

```powershell
Get-MailboxDatabaseCopyStatus *
```

Look for:
- `Failed`
- `Dismounted`
- `ServiceDown`
- Log generation mismatches

---

## 2. Soft Recovery Using Logs

If log files are intact:

```powershell
eseutil /r E00 /l "D:\Logs" /d "D:\Database" /i
```

Where:
- `/r` = recovery
- `E00` = log prefix (check using `eseutil /mh`)
- `/l` = log path
- `/d` = database path

Then mount the database:

```powershell
Mount-Database -Identity "MailboxDB01"
```

---

## 3. Hard Recovery (Logs Lost or Corrupt)

If logs are missing and you must perform a hard recovery:

```powershell
eseutil /p "D:\Database\MailboxDB01.edb"
```

> ⚠️ Warning: This is destructive. Logs cannot be replayed after this.

Then defragment and integrity check:

```powershell
eseutil /d "D:\Database\MailboxDB01.edb"
eseutil /g "D:\Database\MailboxDB01.edb"
```

---

## 4. Database Not Mounting?

Try forcing it:

```powershell
Mount-Database -Identity "MailboxDB01" -Force
```

---

## 5. Restore from Backup

Use your backup application or this command if using Windows Backup:

```powershell
wbadmin start recovery
```

---

## 6. Post-Recovery Checks

- Verify mailbox access
- Run `Get-MailboxDatabaseCopyStatus`
- Check Event Viewer for ESE and MSExchangeIS errors
