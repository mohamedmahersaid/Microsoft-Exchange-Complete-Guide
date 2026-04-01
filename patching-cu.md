# Cumulative Update (CU) and Patching Runbook

## Purpose
Step-by-step runbook for applying Cumulative Updates (CUs) and security patches to Microsoft Exchange Server with minimal downtime and rollback steps.

## Scope
Applicable to on-prem Exchange 2016/2019

## Preconditions
- Valid backup of Exchange databases and system state (VSS snapshot or third-party backup)
- Maintenance window and change ticket opened
- Lab validation completed for the target CU
- Health checks passing pre-patch (use Get-ExchangeServerHealth)
- All mailbox moves and long-running operations completed or scheduled off-window

## Patch Process (High level)
1. Read release notes: review Microsoft CU KB, prerequisites, blocking issues.
2. Test in lab: Validate CU install and rollback in a representative lab.
3. Notify stakeholders: maintenance window and expected impact.

## Detailed Steps
1. Pre-checks (run as Admin):
   - Export server state: `Get-ServerHealth` / `Test-ServiceHealth`
   - Snapshot or backup DBs and system state; verify backups.
   - Run antivirus exclusion checks and disable backup jobs.
   - Verify available disk space for CU staging (C:\ExchangeSetupLogs, drive with installer).

2. Mount maintenance mode (if using DAG):
   - Suspend DAG copy activation for the target DBs if needed: `Suspend-MailboxDatabaseCopy -Identity DB01 -ActivationOnly`
   - Redirect client traffic if applicable (load balancer or MX changes)

3. Install CU (example unattended):
   - `Setup.exe /Mode:Upgrade /IAcceptExchangeServerLicenseTerms`
   - Monitor logs: `%SystemDrive%\ExchangeSetupLogs\`

4. Post-install validations:
   - Reboot if required, then verify `Test-ServiceHealth` and `Get-MailboxDatabase -Status`
   - Verify replication and reseed DB copies: `Get-MailboxDatabaseCopyStatus`
   - Test mail flow, OWA, ECP, and transport services.

## Rollback Plan
- If servers are not recoverable: bring up lab-based rollback steps. For Exchange CUs, rollback often requires full restore from backup or reinstall previous build using backups. Document and test rollback in lab.

## Post-Patch Tasks
- Re-enable suspended DB activation: `Resume-MailboxDatabaseCopy -Identity DB01`
- Re-enable antivirus agents and backup jobs, monitor performance for 72 hours.

## Troubleshooting
- Check ExchangeSetup.log and Event Viewer Application/System logs
- Common errors: schema mismatch (ensure AD was prepared), missing prerequisites, DEP/antivirus interference

## References
- Microsoft CU KB and Exchange Update documentation