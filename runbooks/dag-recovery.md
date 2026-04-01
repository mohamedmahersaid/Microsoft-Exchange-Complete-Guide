# DAG Recovery Runbook

Purpose
Recover a failed DAG or perform planned activation/failover in a controlled way with minimum data loss and acceptable downtime.

Scope
- DAG recovery scenarios: single-server failure, multi-server failure, WAN site loss, reseed operations, and restoring DB copies.

Preconditions
- Recent verified backups of mailbox databases and system state.
- Admins on call and approvals per change control.
- Monitoring and runbook available for escalation.

Immediate steps for server failure
1. Determine failure extent:
   Get-MailboxDatabaseCopyStatus * | Where-Object {$_.Status -ne 'Mounted'}
2. If single server failed, verify remaining copy health:
   Get-MailboxDatabaseCopyStatus | Where-Object {$_.ContentIndexState -eq 'Healthy'}

Controlled failover (if required)
1. Suspend the DB copies on the failed server (if accessible):
   Suspend-MailboxDatabaseCopy -Identity DB1\EXCH02 -Confirm:$false
2. Activate a copy on a healthy server (use MoveActiveMailboxDatabase for planned activation):
   Move-ActiveMailboxDatabase -Identity DB1 -ActivateOnServer EXCH03 -MountDialOverride $null -AcceptLargeDataLoss:$false
   Note: For unplanned failure, accept the risk or use the database move with AcceptLargeDataLoss only as last resort.

Re-seeding a copy
1. If data needs reseeding:
   Suspend-MailboxDatabaseCopy -Identity DB1\EXCH02 -Confirm:$false
   Update-MailboxDatabaseCopy -Identity DB1\EXCH02 -ConfigurationOnly:$false
   Resume-MailboxDatabaseCopy -Identity DB1\EXCH02

Restoring from backup
1. If reseed fails or DB is corrupt, restore DB from backup into recovery server following vendor or VSS steps.
2. Use Eseutil to repair if necessary (risky — only after backups and vendor guidance):
   eseutil /mh <DBfile>  (to check DB state)
   eseutil /p <DBfile>  (repair only after careful consideration)

Network/site failure
1. If site-level failure, activate databases in DR site:
   Move-ActiveMailboxDatabase -Identity DB1 -ActivateOnServer EXCHDR01 -MountDialOverride $null
2. Validate replication health and client access from DR site.

Post-recovery validation
- Verify all DBs mounted:
  Get-MailboxDatabase -Status | Where-Object {$_.Mounted -eq $true}
- Confirm mail-flow:
  Test-Mailflow -Identity <test-mailbox>
- Confirm client access:
  Test-OutlookWebServices -Identity <test-user>

Monitoring and cleanup
- Resume any suspended copies after repair and reseed.
- Rebuild search index if needed and validate content indexing:
  Get-MailboxDatabaseCopyStatus | Format-Table Name,ContentIndexState

Escalation and notes
- If cluster or DTC issues occur, escalate to Windows Cluster SME and vendor support.
- Document all actions, timestamps, and associated logs for post-incident review.