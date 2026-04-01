# Exchange Server Installation Runbook

## Purpose
Step-by-step, production-ready runbook to install Microsoft Exchange Server 2019 (applies to 2016/2019 with version-specific notes). Designed for admins to follow in pre-production and production environments.

## Scope
- On-premises Exchange 2019
- Assumes Active Directory prepared and Windows Server hosts ready

## Preconditions
- Domain functional level supported by Exchange version
- Schema master accessible and backups in place
- Administrative account with Enterprise Admin and Schema Admin rights available
- Required Windows updates applied and server restarted
- Network and DNS fully configured (internal/external namespaces planned)

## Prerequisites
1. Prepare Active Directory:
   - Extend schema (only if not already extended): `Setup.exe /PrepareSchema /IAcceptExchangeServerLicenseTerms`
   - Prepare AD: `Setup.exe /PrepareAD /OrganizationName:\"<OrgName>\" /IAcceptExchangeServerLicenseTerms`
   - Prepare domain: `Setup.exe /PrepareAllDomains /IAcceptExchangeServerLicenseTerms`
2. Install required Windows features (example for Exchange 2019):
   - `Install-WindowsFeature Server-Media-Foundation, NET-Framework-45-Features, RSAT-ADDS`
3. Install Visual C++ Redistributable as required by CU
4. Configure storage and volumes (ReFS recommended for DB/Logs on supported workloads)
5. Configure service accounts (gMSA recommended for service automation)

## Installation Steps
1. Copy Exchange binaries to the server and verify digital signatures.
2. Run Setup in GUI or unattended mode. Example unattended command:

```
Setup.exe /Mode:Install /Roles:Mailbox /IAcceptExchangeServerLicenseTerms /TargetDir:\"C:\\Program Files\\Microsoft\\Exchange Server\\V15\" 
```

3. Monitor setup logs: `%SystemDrive%\ExchangeSetupLogs\` for errors.
4. Post-install configuration:
   - Configure service startup types and verify services are running
   - Configure virtual directories and external/internal URLs
   - Configure accepted domains and email address policies
   - Configure send/receive connectors

## Validation
- Use `Test-ServiceHealth` and `Get-ServerComponentState` to verify components
- Run `Get-MailboxDatabase -Status` and ensure databases mount
- Verify OWA/ECP accessibility and SSL certificate bindings
- Verify mail flow by sending/receiving test messages internally and externally

## Rollback / Remediation
- If installation fails during schema extension, restore AD from pre-install backup if possible
- If the server is unusable post-install, demote remove server with `Uninstall-ExchangeServer` steps in lab after documentation

## Notes
- Always test a full installation in a lab matching production scale before performing production installs.
- Keep CUs and prerequisites documented in the ROADMAP and RELEASE notes.

## References
- Microsoft official Exchange installation documentation
