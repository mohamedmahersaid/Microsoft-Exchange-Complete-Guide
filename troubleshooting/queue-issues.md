
# Troubleshooting Mail Queue Issues in Exchange

---

## 1. Check Mail Queues

```powershell
Get-Queue | Sort MessageCount -Descending | Format-Table Identity, MessageCount, Status
```

Look for:
- Large queues in `Submission`, `Poison`, `Unreachable`
- Status: `Retry`, `Suspended`, `Active`

---

## 2. Analyze Queued Messages

```powershell
Get-Message -Queue "EX01\Submission" | Select FromAddress, Subject, Status, LastError
```

Check:
- Bad domains
- DNS resolution failures
- Routing issues
- Large message sizes

---

## 3. Common Fixes

### Flush Queue

```powershell
Get-Queue | Where {$_.Status -eq "Retry"} | Retry-Queue
```

### Suspend/Remove Specific Message

```powershell
Suspend-Message -Identity <msg-id>
Remove-Message -Identity <msg-id>
```

---

## 4. DNS and Smart Host Checks

- Verify MX records via nslookup
- Test outbound SMTP using `telnet` or `Test-SmtpConnectivity`
- Confirm smart host authentication if used

---

## 5. Logs to Review

- `C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\MessageTracking`
- Windows Event Viewer → MSExchangeTransport

---

## 6. Preventive Actions

- Enable queue monitoring
- Limit max message size
- Configure alerts for queue thresholds

---

## 7. Useful Tools

- `Queue Viewer` (Exchange Toolbox)
- `Test-Mailflow`, `Test-SmtpConnectivity`
