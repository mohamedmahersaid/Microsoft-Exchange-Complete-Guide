# TLS Best Practices for Microsoft Exchange Server

Transport Layer Security (TLS) is essential for securing SMTP communication both internally and externally. This guide outlines how to enforce, test, and troubleshoot TLS on Microsoft Exchange Server.

---

## 🔒 What is TLS in Exchange?

- **TLS (StartTLS)**: Encryption is initiated after connection setup (default in Exchange).
- **Mutual TLS (MTLS)**: Both sender and receiver authenticate with certificates.
- **Opportunistic TLS**: Exchange attempts TLS but falls back to unencrypted if not available (default for external).

---

## ⚙️ Configure Receive Connector for TLS

```powershell
Set-ReceiveConnector "Default EX01" `
  -AuthMechanism TLS `
  -RequireTLS $true `
  -PermissionGroups AnonymousUsers
```

For internal SMTP relay connectors:

```powershell
Set-ReceiveConnector "Internal Relay" `
  -AuthMechanism TLS `
  -RequireTLS $true
```

---

## ⚙️ Configure Send Connector for TLS

```powershell
Set-SendConnector "OutboundInternet" `
  -RequireTLS $true `
  -TlsDomain "partnerdomain.com"
```

---

## 📜 Configure Domain Security (Mutual TLS)

1. Add domain to `TLSReceiveDomainSecureList` and `TLSSendDomainSecureList`:

```powershell
Set-TransportConfig -TLSSendDomainSecureList "partnerdomain.com"
Set-TransportConfig -TLSReceiveDomainSecureList "partnerdomain.com"
```

2. Configure connector with `TlsAuthLevel`:

```powershell
Set-SendConnector "Partner Connector" -TlsAuthLevel DomainValidation
```

---

## 🧪 Test TLS Connectivity

```powershell
Test-SmtpConnectivity -Identity "OutboundInternet" -UseSsl -Port 25
```

Or use `openssl`:

```bash
openssl s_client -connect mail.contoso.com:25 -starttls smtp
```

---

## 📝 Logging and Verification

Enable verbose protocol logging:

```powershell
Set-ReceiveConnector "Default EX01" -ProtocolLoggingLevel Verbose
Set-SendConnector "OutboundInternet" -ProtocolLoggingLevel Verbose
```

Log files are located in:

```
C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\ProtocolLog\SmtpReceive
```

---

## 🔐 TLS 1.2 Enforcement (Windows Server)

Exchange 2019 supports TLS 1.2 natively. Disable older versions via registry:

```reg
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server]
"Enabled"=dword:00000000

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server]
"Enabled"=dword:00000000
```

Restart server after registry changes.

---

## ✅ Best Practices

- Use certificates from trusted CAs with proper SANs
- Prefer `RequireTLS` + `TlsAuthLevel` for sensitive domains
- Monitor TLS logs for downgrade attempts
- Update .NET + OS for latest cipher suite support

---

### 🔄 Next:
- `backup-recovery/database-recovery.md` – Protect and restore Exchange data.