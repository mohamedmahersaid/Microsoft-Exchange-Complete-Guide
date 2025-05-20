
# Managing Exchange SSL Certificates

---

## 1. Certificate Requirements

- Public CA-issued certificate (for production)
- Includes SANs like:
  - mail.domain.com
  - autodiscover.domain.com

---

## 2. Generate Certificate Request (CSR)

```powershell
New-ExchangeCertificate -GenerateRequest -FriendlyName "Exchange 2019 Cert" -SubjectName "CN=mail.domain.com" -DomainName mail.domain.com, autodiscover.domain.com -PrivateKeyExportable $true -Path "C:\CertRequest.req"
```

---

## 3. Import Certificate

After receiving the certificate from your CA:

```powershell
Import-ExchangeCertificate -FileData ([Byte[]]$(Get-Content -Path "C:\cert.cer" -Encoding byte -ReadCount 0))
```

---

## 4. Assign Services

```powershell
Get-ExchangeCertificate | fl Thumbprint,Subject

Enable-ExchangeCertificate -Thumbprint <THUMBPRINT> -Services "IIS,SMTP,IMAP,POP"
```

---

## 5. Verify

```powershell
Get-ExchangeCertificate | fl *
```
