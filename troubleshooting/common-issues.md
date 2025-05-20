# Common Exchange Server Issues and Troubleshooting Guide

This guide covers frequently encountered issues in Microsoft Exchange Server environments and provides troubleshooting steps for each.

---

## 🔒 1. ECP or OWA Not Loading

### Symptoms:
- Browser shows HTTP 500 error
- Blank screen or login loop

### Troubleshooting:
```powershell
Get-ServerComponentState -Identity EX01
Restart-WebAppPool MSExchangeOWAAppPool
Restart-WebAppPool MSExchangeECPAppPool
Get-EcpVirtualDirectory | fl InternalUrl, ExternalUrl
```

### Fix:
- Recycle app pools in IIS
- Check for expired certificates
- Ensure correct DNS and binding for URLs

---

## 📤 2. Mail Flow Delays

### Symptoms:
- Queues grow in transport
- Users complain of slow mail delivery

### Troubleshooting:
```powershell
Get-Queue
Get-MessageTrackingLog -Start (Get-Date).AddMinutes(-30)
Test-Mailflow -TargetEmailAddress test@contoso.com
```

### Fix:
- Check DNS resolution from server
- Review protocol logs under `\TransportRoles\Logs\`
- Restart MSExchangeTransport service

---

## 📬 3. Messages Stuck in Drafts

### Symptoms:
- OWA/Outlook shows unsent messages

### Troubleshooting:
- Check for mailbox database dismount
- Use `Get-MailboxDatabaseCopyStatus`
- Restart MAPI and Transport services

```powershell
Restart-Service MSExchangeIS
Restart-Service MSExchangeTransport
```

---

## 🗂️ 4. Database Mount Failure

### Symptoms:
- DB won’t mount; event logs show ESE errors

### Troubleshooting:
```powershell
Get-MailboxDatabase | Select Name, Mounted
Mount-Database "MailboxDB01" -Force
```

Check with:

```powershell
eseutil /mh "C:\Path\To\MailboxDB01.edb"
```

### Fix:
- Perform soft recovery
- Check disk space, log consistency

---

## ⚙️ 5. Autodiscover Failures

### Symptoms:
- Outlook cannot connect or configure profile

### Troubleshooting:
```powershell
Test-OutlookConnectivity
Test-OutlookWebServices
```

### Fix:
- Verify SSL bindings
- Check DNS record for `autodiscover.contoso.com`
- Include name in Exchange certificate

---

## 🧼 6. Health Probe Failures

Use:

```powershell
Get-ServerHealth EX01 | ? {$_.AlertValue -ne "Healthy"}
```

Or inspect:

```
C:\Program Files\Microsoft\Exchange Server\V15\Logging\Monitoring
```

---

## ✅ Best Practices

- Enable verbose logging during investigation
- Monitor Event Viewer → Application + System + Exchange logs
- Review transport, IIS, and RPC logs for error patterns
- Document root cause after resolution

---

## 🔄 Next:
- `hybrid/setup-guide.md` – Configure hybrid Exchange with Microsoft 365.