# Integrating Exchange Server with SharePoint and Microsoft Teams

Integrating Exchange with other Microsoft services such as SharePoint and Teams provides users with seamless collaboration, calendar sharing, eDiscovery, and mailbox-based apps.

---

## 📥 Exchange and SharePoint Integration

### Key Integration Points:

| Feature                  | Description                                           |
|--------------------------|-------------------------------------------------------|
| Site Mailboxes           | Combined SharePoint + Exchange collaboration space   |
| eDiscovery               | Unified compliance search across mail and sites       |
| Calendar Overlay         | Display Exchange calendar on SharePoint site          |
| Contacts Sync            | Sync SharePoint contacts from Exchange mailboxes      |

### Requirements:

- Exchange 2016/2019 and SharePoint 2016/2019/Subscription
- Domain trust or same forest deployment
- Secure token service (STS) configured

### Configure OAuth Authentication

```powershell
Set-AuthConfig -OAuthIssuerId "<SharePointIssuerID>" -NameIdFormat EmailAddress -Realm "<yourdomain>"
Set-PartnerApplication -Identity "SharePoint" -AppOnlyPermissions "Sites.FullControl.All"
```

---

## 🔔 Exchange and Microsoft Teams Integration

### Native Features via Exchange Online:

| Feature                   | Description                                              |
|---------------------------|----------------------------------------------------------|
| Calendar Availability     | Meeting scheduling and availability from Outlook         |
| Mailbox Storage           | Team channel emails stored in group mailboxes            |
| Compliance                | Exchange mailboxes included in Teams eDiscovery          |

### Hybrid Requirements:

- Exchange Online mailbox for Teams-enabled users
- Azure AD Connect syncing on-prem AD with Exchange attributes
- Proper Autodiscover and mailbox anchoring

### Ensure Proper Attributes:

```powershell
Get-ADUser user1 -Properties mail, proxyAddresses, msExchMailboxGUID
```

---

## 🧪 Testing Integration

- Use Test-PartnerApplication cmdlet for SharePoint
- Verify Teams calendar via Outlook or Teams web
- Review event logs and Autodiscover response for mailbox location

---

## 🛠️ Troubleshooting

- Ensure Autodiscover returns correct mailbox endpoint
- Use hybrid Exchange server for attribute stamping
- Monitor OAuth logs in Exchange logging folder

---

## ✅ Best Practices

- Keep Exchange schema up to date in hybrid scenarios
- Always configure Autodiscover and SCP correctly
- Use hybrid license server to maintain Teams support after migration

---

## 🔄 Next:
- `performance/tuning-guide.md` – Optimize Exchange performance and storage efficiency.