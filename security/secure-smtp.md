# Securing Exchange SMTP

Proper configuration of Exchange SMTP security ensures confidential and authenticated mail flow both internally and externally.

---

## 🔐 TLS Configuration on Receive Connectors

```powershell
Set-ReceiveConnector "Default EX01" -RequireTLS $true -AuthMechanism TLS
```

---

## 🛡️ Send Connector TLS

```powershell
Set-SendConnector "InternetOutbound" -RequireTLS $true -TlsAuthLevel DomainValidation
```

---

## 🧾 Enable Protocol Logging

```powershell
Set-ReceiveConnector "Default EX01" -ProtocolLoggingLevel Verbose
Set-SendConnector "InternetOutbound" -ProtocolLoggingLevel Verbose
```

Logs:  
`C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\ProtocolLog`

---

## 🧪 Test TLS

```powershell
Test-SmtpConnectivity -Identity "InternetOutbound" -UseSsl
```