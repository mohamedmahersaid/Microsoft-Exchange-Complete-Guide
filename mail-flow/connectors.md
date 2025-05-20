
# 📧 Exchange Mail Flow: Configuring Send and Receive Connectors

Microsoft Exchange uses **Receive Connectors** to accept email and **Send Connectors** to route outbound messages. This guide walks through configuration, TLS security, verification, and best practices.

---

## 📥 1. Receive Connectors

Receive connectors accept inbound SMTP email from:

- External senders (internet)
- Internal devices (printers, scanners)
- Partner systems and legacy appliances

### Default Connectors Created by Exchange

- `Default Frontend <Server>` – Receives unauthenticated internet mail.
- `Client Frontend <Server>` – For authenticated SMTP from Outlook or other mail clients.

### View Existing Receive Connectors

```powershell
Get-ReceiveConnector | ft Name,Bindings,RemoteIPRanges
```

### Create a Custom Internal Relay Connector

Used for trusted devices (printers, scanners, applications):

```powershell
New-ReceiveConnector -Name "InternalRelay" `
  -Server EX01 `
  -Bindings 0.0.0.0:25 `
  -RemoteIPRanges 192.168.0.0/24 `
  -Usage Custom `
  -PermissionGroups AnonymousUsers
```

Set authentication and encryption:

```powershell
Set-ReceiveConnector "InternalRelay" -AuthMechanism "TLS"
Set-ReceiveConnector "InternalRelay" -RequireTLS $true
```

> ⚠️ **Security Tip**: Limit IP ranges and avoid anonymous relay where not required.

---

## 📤 2. Send Connectors

Send connectors route outbound SMTP mail to the internet, smart hosts, or cloud services.

### View Existing Send Connectors

```powershell
Get-SendConnector | fl Name,AddressSpaces,SmartHosts
```

### Create Internet Send Connector

```powershell
New-SendConnector -Name "OutboundInternet" `
  -AddressSpaces "*" `
  -Usage Internet `
  -Internet `
  -DNSRoutingEnabled $true `
  -SmartHostAuthMechanism None `
  -FrontendProxyEnabled $true `
  -SourceTransportServers "EX01"
```

### Create Smart Host Connector (e.g., ISP relay)

```powershell
New-SendConnector -Name "SmartHost Connector" `
  -Usage Internet `
  -AddressSpaces "*" `
  -SmartHosts "smtp.relay.com" `
  -SmartHostAuthMechanism "BasicAuth" `
  -AuthenticationCredential (Get-Credential) `
  -SourceTransportServers "EX01"
```

> 💡 Use this when relaying through an ISP or third-party SMTP server.

---

## 🔐 3. TLS and Secure Routing

Force TLS for encryption:

```powershell
Set-SendConnector "OutboundInternet" -RequireTLS $true
Set-ReceiveConnector "InternalRelay" -RequireTLS $true
```

Use `StartTLS` or mutual TLS (mTLS) for secure partner communication.

---

## 🧪 4. Mail Flow Testing

Test message delivery and routing:

```powershell
Test-Mailflow -TargetEmailAddress "admin@domain.com"
```

Track messages:

```powershell
Get-MessageTrackingLog -Recipients "admin@domain.com"
```

---

## 📊 5. Mail Queue Monitoring

View mail queues:

```powershell
Get-Queue
Get-Message -Queue "EX01\Submission"
```

---

## ✅ 6. Best Practices

- Use minimal IP scopes in Receive Connectors.
- Do **not** allow anonymous relay unless required and controlled.
- Separate connectors for Internet, Hybrid, and Partner mail flows.
- Enable logging and review `X-Source` headers for auditing.
- Regularly test connectors and queue performance using PowerShell.

---

## 📚 References

- [Exchange Mail Flow Overview](https://learn.microsoft.com/en-us/exchange/mail-flow/mail-flow)
- [Exchange Connectors Documentation](https://learn.microsoft.com/en-us/exchange/mail-flow/connectors)
