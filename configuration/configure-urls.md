
# Configure Internal and External URLs for Exchange Services

Configuring Exchange URLs ensures client access to OWA, ECP, EWS, ActiveSync, and Autodiscover from both internal and external networks.

---

## 1. Best Practices

- Use **split DNS** (same namespace internally and externally)
- Assign an SSL certificate that includes all relevant hostnames
- Configure all URLs consistently across all servers

---

## 2. Internal vs External URLs

| Service        | Internal URL                   | External URL                  |
|----------------|--------------------------------|-------------------------------|
| OWA            | https://mail.domain.local/owa  | https://mail.domain.com/owa   |
| ECP            | https://mail.domain.local/ecp  | https://mail.domain.com/ecp   |
| EWS            | https://mail.domain.local/ews  | https://mail.domain.com/ews   |
| ActiveSync     | https://mail.domain.local/Microsoft-Server-ActiveSync | https://mail.domain.com/Microsoft-Server-ActiveSync |
| OAB            | https://mail.domain.local/OAB  | https://mail.domain.com/OAB   |
| Autodiscover   | autodiscover.domain.com        | autodiscover.domain.com       |

---

## 3. PowerShell to Set URLs

Use this script on all mailbox servers:

```powershell
$Server = "EX01"
$ExternalURL = "https://mail.domain.com"
$InternalURL = "https://mail.domain.local"

Set-OwaVirtualDirectory -Identity "$Server\owa (Default Web Site)" -ExternalUrl "$ExternalURL/owa" -InternalUrl "$InternalURL/owa"
Set-EcpVirtualDirectory -Identity "$Server\ecp (Default Web Site)" -ExternalUrl "$ExternalURL/ecp" -InternalUrl "$InternalURL/ecp"
Set-WebServicesVirtualDirectory -Identity "$Server\EWS (Default Web Site)" -ExternalUrl "$ExternalURL/ews/exchange.asmx" -InternalUrl "$InternalURL/ews/exchange.asmx"
Set-ActiveSyncVirtualDirectory -Identity "$Server\Microsoft-Server-ActiveSync (Default Web Site)" -ExternalUrl "$ExternalURL/Microsoft-Server-ActiveSync" -InternalUrl "$InternalURL/Microsoft-Server-ActiveSync"
Set-OabVirtualDirectory -Identity "$Server\OAB (Default Web Site)" -ExternalUrl "$ExternalURL/OAB" -InternalUrl "$InternalURL/OAB"
Set-OutlookAnywhere -Identity "$Server\Rpc (Default Web Site)" -ExternalHostname "mail.domain.com" -InternalHostname "mail.domain.local" -ExternalClientsRequireSsl $true -InternalClientsRequireSsl $true -DefaultAuthenticationMethod NTLM
```

---

## 4. Verify URLs

```powershell
Get-OwaVirtualDirectory | fl Name,InternalURL,ExternalURL
Get-EcpVirtualDirectory | fl Name,InternalURL,ExternalURL
Get-WebServicesVirtualDirectory | fl Name,InternalURL,ExternalURL
Get-OabVirtualDirectory | fl Name,InternalURL,ExternalURL
```
