# Managing Mailboxes in Exchange Server

Mailbox management is a core administrative task in Exchange Server. This guide covers PowerShell and GUI-based mailbox operations.

---

## 🧍 Create a New Mailbox

```powershell
New-Mailbox -Name "John Doe" -UserPrincipalName jdoe@contoso.com -Password (ConvertTo-SecureString -AsPlainText "P@ssword1" -Force)
```

---

## 👥 Enable a Mailbox for an Existing AD User

```powershell
Enable-Mailbox -Identity "DOMAIN\jdoe"
```

---

## 📥 Disable a Mailbox

```powershell
Disable-Mailbox -Identity jdoe@contoso.com
```

---

## 📁 Move a Mailbox

```powershell
New-MoveRequest -Identity jdoe@contoso.com -TargetDatabase "MailboxDB02"
```

---

## 📦 Set Mailbox Quota

```powershell
Set-Mailbox -Identity jdoe@contoso.com -IssueWarningQuota 1.9GB -ProhibitSendQuota 2GB -ProhibitSendReceiveQuota 2.3GB
```

---

## 🗑️ Remove a Mailbox

```powershell
Remove-Mailbox -Identity jdoe@contoso.com
```

---

## 📊 Report on All Mailboxes

```powershell
Get-Mailbox | Get-MailboxStatistics | Select DisplayName, TotalItemSize, ItemCount
```