
# Troubleshooting Client Connectivity Issues (Outlook, OWA, ActiveSync)

---

## 1. Identify Scope

Check if issue affects:
- Web (OWA/ECP) or Outlook (MAPI/Autodiscover)
- All users or specific users
- Internal vs external access

---

## 2. Basic Checks

- Ensure Exchange services are running:
```powershell
Get-Service *Exchange* | Where {$_.Status -ne 'Running'}
```

- Restart IIS:
```powershell
iisreset
```

---

## 3. Autodiscover Troubleshooting

```powershell
Test-OutlookConnectivity -ProbeIdentity AutoDiscover
Test-OutlookWebServices -Identity user@domain.com
```

Check DNS:
- Autodiscover.domain.com points to Exchange
- Internal SCP is correct: `Get-ClientAccessService | fl AutoDiscoverServiceInternalUri`

---

## 4. Outlook Issues

- Clear Outlook profile and recreate
- Run Outlook in safe mode
- Run `Test Email AutoConfiguration` from Outlook > Ctrl+Right Click > Connection Status

---

## 5. OWA/ECP Issues

- Browse https://localhost/ecp on server
- Verify virtual directories:
```powershell
Get-OwaVirtualDirectory | fl Name, InternalURL, ExternalURL
```

---

## 6. ActiveSync Issues

- Test with:
```powershell
Test-ActiveSyncConnectivity -MailboxCredential (Get-Credential)
```

- Check IIS logs and device logs for sync failures

---

## 7. Logs to Review

- IIS Logs: `C:\inetpub\logs\LogFiles`
- Event Viewer: Application logs (MSExchangeFrontEnd, MSExchangeActiveSync)
