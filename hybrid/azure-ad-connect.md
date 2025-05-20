
# Azure AD Connect Setup Guide

Azure AD Connect synchronizes identities from on-prem Active Directory to Microsoft Entra ID (Azure AD).

---

## 1. Prerequisites

- .NET Framework 4.8
- Server joined to domain
- Enterprise admin rights
- Microsoft 365 global admin credentials

---

## 2. Download & Install

Download:  
[https://www.microsoft.com/en-us/download/details.aspx?id=47594](https://www.microsoft.com/en-us/download/details.aspx?id=47594)

Run installer:
- Use **Express Settings** (for most orgs)
- Or use **Custom** to select OUs, configure filtering

---

## 3. Verify UPN Suffixes

Ensure all users have routable UPN suffix (e.g., user@domain.com, not user@domain.local)

---

## 4. Configure Password Hash Sync (Recommended)

During setup, select:
- Password Hash Sync (simple and secure)
- Enable seamless SSO (optional)
- Enable Hybrid Exchange (if applicable)

---

## 5. Sync Options

Use PowerShell:

```powershell
Start-ADSyncSyncCycle -PolicyType Delta
```

Verify:

```powershell
Get-ADSyncScheduler
```

---

## 6. Monitoring & Logs

- Azure AD Connect Health (Portal + Agent)
- Windows Event Viewer > Applications and Services Logs > Directory Synchronization

---

## 7. References

- [Azure AD Connect Docs](https://learn.microsoft.com/en-us/azure/active-directory/hybrid/whatis-azure-ad-connect)
