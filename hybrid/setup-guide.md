# Setting Up Hybrid Exchange with Microsoft 365

A hybrid deployment provides coexistence between an on-premises Exchange organization and Exchange Online (Microsoft 365), enabling mailbox migration, shared calendar availability, and centralized mail routing.

---

## 🎯 Benefits of Hybrid Exchange

- Seamless mailbox migration to Microsoft 365
- Unified GAL (Global Address List)
- Free/Busy calendar sharing
- Centralized SMTP routing
- Single sign-on with AAD Connect and Hybrid Modern Auth

---

## 🔧 Prerequisites

- Exchange Server 2016 or 2019 with latest CU
- Valid public SSL certificate
- Mail flow working externally (MX, SPF, DKIM)
- DNS entries for Autodiscover and mail domains
- Azure AD Connect with Exchange hybrid writeback enabled

---

## 🧰 Hybrid Configuration Wizard (HCW)

Download from:  
https://aka.ms/HybridWizard

### Run the Wizard:

1. Launch as administrator
2. Sign in to both on-prem and Microsoft 365 tenants
3. Choose hybrid features (minimal/full, mail routing)
4. Configure send/receive connectors
5. Setup OAuth for modern authentication

---

## 🗂️ Key DNS Records

| Record Type | Host                 | Points To                      |
|-------------|----------------------|--------------------------------|
| CNAME       | autodiscover         | autodiscover.outlook.com       |
| MX          | contoso.com          | contoso.mail.protection.outlook.com |
| TXT         | contoso.com          | SPF record                     |

---

## 🔐 Enable OAuth for Modern Auth

```powershell
Set-OrganizationConfig -OAuth2ClientProfileEnabled $true
```

Run HCW to complete OAuth trust between on-prem and Exchange Online.

---

## ✉️ Mail Flow Configuration

### Centralized Mail Transport (CMT)

- All outbound mail routes through on-prem Exchange
- Ensures transport rules and journaling apply

---

## 📤 Mailbox Move Command

```powershell
New-MoveRequest -Identity "user@contoso.com" -RemoteTargetDatabase "Mailbox Database" -RemoteHostName "mail.contoso.com" -RemoteCredential (Get-Credential)
```

Monitor:

```powershell
Get-MoveRequest | Get-MoveRequestStatistics
```

---

## 🧪 Testing Tools

- Microsoft Remote Connectivity Analyzer:  
  https://testconnectivity.microsoft.com

- `Test-HybridConnectivity` cmdlet

---

## ✅ Best Practices

- Use minimal hybrid if migrating only (no long-term coexistence)
- Keep at least one Exchange server on-prem after migration
- Ensure certificates and DNS names are valid externally
- Use OAuth + HCW over manual config

---

## 🔄 Next:
- `certificate-management/ssl-deployment.md` – Configure SSL certs for all services and bindings.