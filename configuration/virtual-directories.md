# Configuring Exchange Virtual Directories

Virtual directories in Exchange define how clients access services like Outlook on the Web, ECP, EWS, ActiveSync, and Autodiscover. Configuring these correctly is critical for performance, user experience, and hybrid readiness.

---

## 📘 Default Virtual Directories

| Service            | Directory       | Protocol | Example URL                        |
|--------------------|-----------------|----------|-------------------------------------|
| Outlook on the Web | owa             | HTTPS    | https://mail.contoso.com/owa        |
| EAC                | ecp             | HTTPS    | https://mail.contoso.com/ecp        |
| Autodiscover       | autodiscover    | HTTPS    | https://autodiscover.contoso.com    |
| Exchange Web Svc   | ews             | HTTPS    | https://mail.contoso.com/ews        |
| ActiveSync         | Microsoft-Server-ActiveSync | HTTPS | https://mail.contoso.com/Microsoft-Server-ActiveSync |

---

## 🛠️ View Current Virtual Directory Settings

```powershell
Get-OwaVirtualDirectory | fl Server,InternalUrl,ExternalUrl
Get-EcpVirtualDirectory | fl Server,InternalUrl,ExternalUrl
Get-WebServicesVirtualDirectory | fl InternalUrl,ExternalUrl
Get-ActiveSyncVirtualDirectory | fl InternalUrl,ExternalUrl
Get-AutodiscoverVirtualDirectory | fl InternalUrl,ExternalUrl
```

---

## 🌐 Update Internal and External URLs

### Example Configuration

```powershell
Set-OwaVirtualDirectory "EX01\owa (Default Web Site)" `
  -InternalUrl "https://mail.contoso.com/owa" `
  -ExternalUrl "https://mail.contoso.com/owa"

Set-EcpVirtualDirectory "EX01\ecp (Default Web Site)" `
  -InternalUrl "https://mail.contoso.com/ecp" `
  -ExternalUrl "https://mail.contoso.com/ecp"
```

Apply the same pattern to:
- `ActiveSync`
- `Autodiscover`
- `WebServicesVirtualDirectory`

---

## 🔁 Restart IIS

```bash
iisreset /noforce
```

Restarting IIS ensures updated bindings and paths are active.

---

## 📛 Configure Autodiscover DNS Records

Add an external DNS record:
```
Type: A or CNAME
Host: autodiscover.contoso.com
Points to: public IP or Exchange reverse proxy
```

Ensure SSL cert includes `autodiscover.contoso.com`.

---

## ✅ Best Practices

- Use a **single namespace** for all services (`mail.contoso.com`)
- Configure **split DNS** if internal and external clients use the same name
- Include all required names in **SSL certificate**
- Test with:
  - `Test-OutlookWebServices`
  - `Test-ActiveSyncConnectivity`
  - `Remote Connectivity Analyzer`

---

## 🔄 Next:
- `mail-flow/connectors.md` – Configure send/receive connectors.