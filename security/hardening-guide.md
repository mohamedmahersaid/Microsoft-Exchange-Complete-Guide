
# Exchange Server Security Hardening Guide

This guide helps you secure your on-premises Exchange Server environment using Microsoft-recommended practices.

---

## 1. Server Hardening

- **Keep Exchange and Windows fully patched**
- Remove unused protocols (e.g., SMBv1)
- Disable legacy authentication if not needed (POP3, IMAP, Basic Auth)
- Configure firewalls to only expose required ports (443, 25)
- Use local admin accounts with care and enable auditing

---

## 2. Certificate and TLS Security

- Use a valid public CA certificate (not self-signed)
- Ensure TLS 1.2 is enabled, disable TLS 1.0/1.1
- Use the IISCrypto tool or registry settings to enforce modern ciphers

---

## 3. Configure SPF, DKIM, and DMARC

### SPF (Sender Policy Framework)

Add this DNS TXT record:
```
Name: @
Value: v=spf1 ip4:<your-public-ip> include:spf.protection.outlook.com -all
```

### DKIM

- If hybrid, enable DKIM from Microsoft 365 Security portal
- For on-prem, use 3rd-party tools or edge transport DKIM agents

### DMARC

Add this DNS TXT record:
```
Name: _dmarc.domain.com
Value: v=DMARC1; p=quarantine; rua=mailto:dmarc@domain.com; ruf=mailto:dmarc@domain.com; fo=1
```

---

## 4. Enable Extended Protection (Exchange 2019 CU14+)

Use the Exchange PowerShell module:

```powershell
Get-ExchangeServer | % { Enable-ExchangeCertificateExtendedProtection -Identity $_.Name }
```

Also verify your IIS virtual directories are updated.

---

## 5. Disable Unused Virtual Directories

```powershell
Disable-OutlookAnywhere -Identity "EX01\Rpc (Default Web Site)"
Set-ActiveSyncVirtualDirectory -Identity "EX01\Microsoft-Server-ActiveSync (Default Web Site)" -Enabled $false
```

---

## 6. Enable Anti-Malware and Transport Rules

```powershell
Set-MalwareFilteringServer -Identity "EX01" -BypassFiltering $false
```

Use transport rules to block executables, suspicious headers, or known bad domains.

---

## 7. Audit Logging

Enable mailbox audit logging:

```powershell
Set-Mailbox -Identity user@domain.com -AuditEnabled $true
```

Enable admin audit logging:

```powershell
Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true
```

---

## 8. Monitor and Review

- Use Windows Event Viewer
- Enable Exchange Message Tracking
- Monitor Exchange Health Manager and Performance Counters
- Consider integrating with Microsoft Sentinel or Syslog

---

## 9. References

- [Exchange Server Security](https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/exchange-server-security)
- [Enable SPF/DKIM/DMARC](https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/email-authentication?view=o365-worldwide)
- [Extended Protection](https://techcommunity.microsoft.com/t5/exchange-team-blog/released-may-2023-exchange-server-security-updates/ba-p/3826151)
