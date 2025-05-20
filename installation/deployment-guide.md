# Microsoft Exchange Server Deployment Guide

This guide provides a step-by-step procedure for installing Microsoft Exchange Server 2019 in a production or lab environment.

---

## 🛠️ Prerequisites

### OS and Hardware

- Windows Server 2019 or 2022 Standard/Datacenter (GUI)
- 64 GB RAM (minimum for Mailbox role in production)
- 30 GB+ free disk space for install + logs
- .NET Framework 4.8 installed
- Static IP and domain-joined

### Active Directory Requirements

- Schema Master must run Windows Server 2012 R2 or later
- Forest Functional Level: Windows Server 2012 R2 minimum
- Run `adprep` if preparing AD manually

---

## 📥 Download Exchange

Download ISO from Microsoft Volume Licensing Service Center (VLSC) or Evaluation Center:
- File: `ExchangeServer2019-x64.iso`

---

## 🧰 Pre-Installation Tasks

### 1. Install Windows Features

```powershell
Install-WindowsFeature Server-Media-Foundation, RSAT-ADDS, Web-Server, Web-Basic-Auth, Web-Windows-Auth, Web-Metabase, Web-Asp-Net45, NET-Framework-45-Features, Web-Net-Ext45, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Includes, Web-Http-Errors, Web-Static-Content, Web-Http-Logging, Web-Log-Libraries, Web-Request-Monitor, Web-Http-Tracing, Web-Filtering, Web-Mgmt-Console, Web-Scripting-Tools, Web-WMI
```

### 2. Install Unified Communications Managed API

Required for Exchange setup:
- Download UCMA 4.0 from Microsoft Download Center

---

## 🗂️ Prepare Active Directory

From the Exchange setup directory:

```powershell
Setup.exe /PrepareSchema /IAcceptExchangeServerLicenseTerms
Setup.exe /PrepareAD /OrganizationName:"MyOrg" /IAcceptExchangeServerLicenseTerms
Setup.exe /PrepareAllDomains /IAcceptExchangeServerLicenseTerms
```

---

## 🧪 Install Exchange Server

Mount the ISO and run:

```powershell
Setup.exe /Mode:Install /Roles:Mailbox /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF
```

Or use unattended install:

```powershell
Setup.exe /mode:Install /roles:Mailbox /InstallWindowsComponents /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /TargetDir:"C:\Exchange" /MdbName:"MailboxDB01"
```

---

## 🔍 Post-Installation Configuration

1. Launch **Exchange Admin Center**:  
   `https://<server>/ecp`

2. Test **mail flow and OWA**:
   - OWA: `https://<server>/owa`
   - ECP: `https://<server>/ecp`

3. Run `Get-ExchangeServer` to verify roles.

---

## 🧼 Optional Config Tasks

- Create receive/send connectors
- Configure virtual directories
- Import SSL certificates
- Enable anti-malware filtering
- Join DAG if multiple servers

---

## ✅ Best Practices

- Place databases and logs on separate drives
- Backup before and after install
- Use service accounts with least privilege
- Monitor `C:\ExchangeSetupLogs` for issues

---

## 📌 Notes

Exchange 2019 requires no Edge Transport role by default. All roles are combined into **Mailbox** role. For SMTP edge protection, deploy Edge Transport server separately in DMZ.

---

### 🔄 Next:
- `configuration/virtual-directories.md` – Configure Outlook Anywhere, OWA, ECP paths.