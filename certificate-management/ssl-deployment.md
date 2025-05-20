# SSL Certificate Deployment in Microsoft Exchange

This guide provides a step-by-step process to request, import, assign, and manage SSL certificates in Exchange Server for secure communication across all services.

---

## 📄 Why SSL Matters in Exchange

Exchange relies on SSL/TLS to secure:

- OWA, ECP, ActiveSync, EWS, Autodiscover
- SMTP for mail flow (client and server-side)
- POP/IMAP (if enabled)
- Hybrid Exchange and Microsoft 365 coexistence

---

## 🧾 Step 1: Create a Certificate Request

### Using EAC:

1. Go to **Servers > Certificates**
2. Choose your server and click “+”
3. Select *Create a request for a certificate from a certification authority*
4. Enter a friendly name and domains to include:
   - mail.contoso.com
   - autodiscover.contoso.com
   - server FQDN

### Using PowerShell:

```powershell
New-ExchangeCertificate -GenerateRequest `
  -SubjectName "C=US, O=Contoso, CN=mail.contoso.com" `
  -DomainName autodiscover.contoso.com, mail.contoso.com `
  -PrivateKeyExportable $true `
  -Path "C:\certreq.req"
```

---

## 🔐 Step 2: Submit CSR to a Trusted CA

- Use DigiCert, Sectigo, Entrust, or internal PKI
- Receive `.cer` or `.crt` file upon validation

---

## 📥 Step 3: Import and Assign the Certificate

```powershell
Import-ExchangeCertificate -FileData ([Byte[]]$(Get-Content -Path "C:\cert.cer" -Encoding byte -ReadCount 0))

# Find thumbprint
Get-ExchangeCertificate | fl Thumbprint,Subject

# Assign to Exchange services
Enable-ExchangeCertificate -Thumbprint ABC123... -Services IIS,SMTP,POP,IMAP
```

---

## 🌍 Step 4: Validate Certificate Bindings

```powershell
Get-OutlookAnywhere | fl ExternalHostname,SSLOffloading
Get-ClientAccessService | fl AutoDiscoverServiceInternalUri
```

Use:
- https://www.ssllabs.com/ssltest/
- PowerShell: `Test-OutlookWebServices`

---

## 🔁 Step 5: Renew or Replace Expiring Certificate

```powershell
Renew-ExchangeCertificate -Thumbprint ABC123... -PrivateKeyExportable $true
```

Assign to services again after renewal.

---

## 🛡️ Best Practices

- Use SAN certificate with all Exchange namespaces
- Avoid self-signed certs for production
- Monitor expiration regularly (use script)
- Export cert with private key for backup:

```powershell
$pwd = ConvertTo-SecureString -String "P@ssw0rd" -Force -AsPlainText
Export-ExchangeCertificate -Thumbprint ABC123... -BinaryEncoded:$true -Password $pwd -FileName "C:\backup.pfx"
```

---

## 🔄 Next:
- `high-availability/dag-setup.md` – Configure a Database Availability Group (DAG).