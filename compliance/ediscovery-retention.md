# eDiscovery, In-Place Hold, and Retention Policies in Exchange

Exchange Server provides built-in compliance tools to help organizations meet legal and regulatory requirements for email retention, search, and auditing.

---

## 🔍 What is eDiscovery?

eDiscovery allows authorized users to search mailbox content across the organization for legal or investigative purposes.

---

## 🔐 Role Requirements

Users must be members of:

```plaintext
Discovery Management Role Group
```

Assign via:

```powershell
Add-RoleGroupMember -Identity "Discovery Management" -Member "ComplianceAdmin"
```

---

## 🔎 In-Place eDiscovery Search

Create a new search via EAC:

1. Go to **compliance management > in-place eDiscovery & hold**
2. Click "+" to start a new search
3. Scope: All mailboxes or selected users
4. Conditions: keywords, date range, subject, attachment types
5. Choose to place on hold (optional)

Or via PowerShell:

```powershell
New-MailboxSearch -Name "HR Case" `
  -StartDate "01/01/2023" -EndDate "12/31/2023" `
  -TargetMailbox "DiscoverySearchMailbox@contoso.com" `
  -SearchQuery 'subject:"confidential"' `
  -SourceMailboxes "user1@contoso.com", "user2@contoso.com"
```

---

## 📥 Enable In-Place Hold

```powershell
Set-Mailbox user1 -LitigationHoldEnabled $true
```

To include duration (in days):

```powershell
Set-Mailbox user1 -InPlaceHoldEnabled $true -InPlaceHoldDuration 365
```

---

## 🗂️ Retention Policies

Retention policies define how long items stay in mailbox folders and what happens when they expire.

### 1. Create Tags

```powershell
New-RetentionPolicyTag -Name "Delete After 3 Years" -Type All `
  -RetentionEnabled $true -AgeLimitForRetention 1095 -RetentionAction DeleteAndAllowRecovery
```

### 2. Create Policy and Assign Tags

```powershell
New-RetentionPolicy -Name "StandardPolicy" -RetentionPolicyTagLinks "Delete After 3 Years"
```

### 3. Assign to Mailboxes

```powershell
Set-Mailbox user1 -RetentionPolicy "StandardPolicy"
```

---

## 📜 Audit Logging

Enable mailbox audit logging:

```powershell
Set-Mailbox -Identity "user1" -AuditEnabled $true
```

Review:

```powershell
Search-MailboxAuditLog -Mailboxes "user1" -ShowDetails
```

---

## ✅ Best Practices

- Use `Discovery Search Mailbox` for search results
- Use In-Place Hold for legal/litigation compliance
- Combine retention with journaling if needed
- Regularly review audit logs for sensitive users

---

## 🔄 Next:
- `monitoring/health-checks.md` – Monitor Exchange health with built-in tools.