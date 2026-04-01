# Backup & Restore Runbook

Purpose
Guidance for performing backups and restoring Exchange mailbox databases (ESE/VSS/3rd-party). Includes verification and restore validation steps.

Scope
- On-premises Exchange database backup/restore scenarios including full and granular restores.

Prerequisites
- Approved backup solution configured (VSS-aware or Exchange-aware backup) and backup job verification.
- Recovery/restore test plan and a test environment for restores.
- Documented retention and retention policies.

Backup best practices
- Use Exchange-aware backup software that supports VSS and Exchange quiescing.
- Schedule regular full and incremental backups per RPO/RTO.
- Maintain offsite copies or immutable storage for retention/DR.

Daily backup verification
1. Verify successful jobs:
   - Check backup software job logs.
   - Validate backup catalog and hashes.
2. Record job IDs and retention metadata.

Restore procedures (full DB restore)
1. Identify target DB and recovery point.
2. Notify stakeholders and schedule maintenance window.
3. Take DB copy offline (if applicable) and ensure passive copies are consistent.
4. Restore DB files to a recovery location (do not overwrite active DBs).
5. Mount DB on recovery server for validation or use Recovery Database (RDB) approach:
   - Create a Recovery Database:
     New-MailboxDatabase -Recovery -Name RDB01 -Server EXCHREC -EdbFilePath 'D:\Recovery\DB01.edb' -LogFolderPath 'D:\Recovery\Logs'
   - Mount RDB:
     Mount-Database RDB01
   - Use New-MailboxRestoreRequest to extract mailboxes or items:
     New-MailboxRestoreRequest -SourceDatabase RDB01 -SourceStoreMailbox 'user@contoso.com' -TargetMailbox 'user@contoso.com'
6. After successful restore, remove RDB and cleaned artifacts.

Using Eseutil for database repair (only when necessary)
1. Check database header:
   eseutil /mh <path>\database.edb
2. When the DB is soft-corrupt and backups exist, consider eseutil /p after consulting vendor and taking full backups:
   eseutil /p <path>\database.edb
   eseutil /d <path>\database.edb (defragment)
   eseutil /mh to verify header state
3. Recreate streaming or index if content index is corrupt:
   Reset-SearchIndex.ps1 or appropriate ESE/Index rebuild steps

Granular restores (mailbox or item)
- Use New-MailboxRestoreRequest or third-party granular restore capabilities.
- Test the restore to a recovery mailbox before restoring to production.

Validation & verification
- Validate mailbox items restored and permissions.
- Verify mail flow and client access for recovered mailboxes.
- Run message tracking tests and use test accounts.

Rollback and re-run
- If the restore is incomplete or corrupt, log incident, run a different recovery point, or escalate to vendor support.

Post-restore tasks
- Reconfigure backups and verify jobs.
- Document the restore event in change-control and incident logs.