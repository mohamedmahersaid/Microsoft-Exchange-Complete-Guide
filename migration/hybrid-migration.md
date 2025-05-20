# Hybrid Mailbox Migration to Microsoft 365

Hybrid configuration allows you to migrate mailboxes from on-premises Exchange to Exchange Online while keeping identities synced with Azure AD.

---

## 🔧 Prerequisites

- Hybrid Configuration Wizard completed
- Mail-enabled user synced with Azure AD Connect
- Valid license assigned in Microsoft 365
- Autodiscover and mailbox anchor set correctly

---

## 🚀 Initiate Migration

```powershell
New-MoveRequest -Identity user@contoso.com -Remote -RemoteTargetDatabase "Mailbox Database" -RemoteHostName "mail.contoso.com" -RemoteCredential (Get-Credential)
```

---

## 🧪 Monitor Migration Status

```powershell
Get-MoveRequest | Get-MoveRequestStatistics
```

---

## 🛠️ Resolve Migration Issues

- Ensure legacyExchangeDN is synced
- Check for mailbox size over quota
- Clear previous move requests:

```powershell
Remove-MoveRequest user@contoso.com
```

---

## ✅ Best Practices

- Use batch migration for groups
- Run mailbox health check before moving
- Confirm Outlook profile reconfiguration post-move