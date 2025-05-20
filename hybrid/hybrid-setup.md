
# Hybrid Deployment: Microsoft Exchange + Microsoft 365

Hybrid Exchange allows seamless coexistence between on-premises and Exchange Online mailboxes.

---

## 1. Prerequisites

- Exchange Server 2016/2019 with latest CU
- Valid SSL certificate from trusted public CA
- Matching UPNs and verified domains in Microsoft 365
- Azure AD Connect configured
- SMTP mail flow and Autodiscover publicly accessible

---

## 2. Install Hybrid Configuration Wizard (HCW)

Download and install HCW:
[https://aka.ms/HybridWizard](https://aka.ms/HybridWizard)

---

## 3. Run Hybrid Configuration Wizard

Steps:

1. Sign in to both Microsoft 365 and on-prem Exchange
2. Select:
   - Full Hybrid
   - Classic or Modern (Minimal)
3. Select mail flow:
   - Centralized (via on-prem)
   - Decentralized (direct from Exchange Online)
4. Specify FQDNs, connectors, and receive/send settings

---

## 4. DNS & Certificate Configuration

- Ensure autodiscover.domain.com points to on-prem
- Use SAN certificate trusted by Exchange Online
- Enable OAuth between environments (Modern Auth)

---

## 5. Test Hybrid Functionality

```powershell
Test-HybridConnectivity
Test-OAuthConnectivity -Service EWS -TargetUri https://outlook.office365.com/EWS/Exchange.asmx -Mailbox user@domain.com
```

---

## 6. Migration Preparation

Use **Exchange Admin Center (EAC)** or **PowerShell** to move mailboxes:

```powershell
New-MigrationBatch -Name "MigrateBatch1" -SourceEndpoint "Hybrid Migration Endpoint" -CSVData ([System.IO.File]::ReadAllBytes("C:\Users\admin\Desktop\migration.csv")) -AutoStart -AutoComplete
```

---

## 7. References

- [Hybrid Deployment Docs](https://learn.microsoft.com/en-us/exchange/exchange-hybrid)
- [Microsoft 365 Hybrid Topologies](https://learn.microsoft.com/en-us/exchange/hybrid-deployment/hybrid-topologies)
