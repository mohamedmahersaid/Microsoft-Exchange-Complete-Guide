
# Installing Microsoft Exchange Server 2019

This guide walks you through installing Microsoft Exchange Server 2019 on Windows Server 2019 or 2022.

---

## 1. System Requirements

- **OS**: Windows Server 2019 Standard or Datacenter
- **AD**: Active Directory functional level 2012 R2 or higher
- **.NET**: .NET Framework 4.8
- **Visual C++**: 2012 & 2013 Redistributables
- **Disk**: At least 30GB free on system drive
- **RAM**: Minimum 8GB (16GB+ recommended)
- **CPU**: 4+ Cores

---

## 2. Install Prerequisites

Open PowerShell as Administrator and run:

```powershell
Install-WindowsFeature Server-Media-Foundation, RSAT-ADDS, Web-Server, Web-Mgmt-Console, Web-Metabase, Web-Asp-Net45, Web-Basic-Auth, Web-Windows-Auth, Web-Digest-Auth, Web-Dyn-Compression, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Net-Ext45, Web-Request-Monitor, Web-Static-Content, Web-Http-Redirect, Web-Http-Errors, WAS-Process-Model, Web-WebSockets, Web-Default-Doc, NET-Framework-Features, NET-Framework-45-Features, Windows-Identity-Foundation
```

Then install:

- [.NET Framework 4.8](https://go.microsoft.com/fwlink/?linkid=2088631)
- [Visual C++ Redistributables (2012 & 2013)](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist)

---

## 3. Prepare Active Directory

From a domain-joined computer with AD RSAT:

```powershell
# Extend schema
Setup.exe /PrepareSchema /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF

# Prepare AD
Setup.exe /PrepareAD /OrganizationName:"YourOrgName" /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF

# Prepare domain
Setup.exe /PrepareDomain /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF
```

---

## 4. Mount Exchange ISO

Mount the ISO and run:

```powershell
Setup.exe /Mode:Install /Roles:Mailbox /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /InstallWindowsComponents
```

---

## 5. Post-Installation

Check services:

```powershell
Get-Service *Exchange* | Where-Object {$_.Status -ne 'Running'}
```

Verify installation:

- Open **Exchange Admin Center**: https://localhost/ecp
- Test mail flow and certificates
