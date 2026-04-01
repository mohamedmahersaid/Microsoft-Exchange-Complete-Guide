# DAG Build Runbook

Purpose
This runbook describes a step‑by‑step, production-ready process to create and validate a Database Availability Group (DAG) for Exchange Server (2016/2019). It includes prechecks, DAG creation, database copy creation, and validation steps.

Scope
- On-premises Exchange DAG build for Mailbox role servers.
- Assumes AD, networking, storage and prerequisites are in place.

Prerequisites
- Domain and forest functional levels supported by Exchange version.
- Two or more mailbox servers running Exchange Mailbox role with identical CUs and OS patches.
- Dedicated DAG network(s) or documented network plan (MAPI & replication networks).
- Windows Failover Clustering feature installed and validated.
- Administrative credentials with Exchange Organization and local administrator rights on target servers.
- Backups of AD and configuration (before cluster changes).

Prechecks
1. Verify Exchange versions and patches:
   Get-ExchangeServer | Format-Table Name,AdminDisplayVersion
2. Verify network & DNS resolution:
   Test-ComputerSecureChannel; Resolve-DnsName <server>
3. Verify Windows Failover Clustering prerequisites:
   Get-WindowsFeature Failover-Clustering
4. Check host storage and disk alignment for DB and logs:
   Get-Volume; verify IO performance metrics.

Design decisions (document)
- DAG name convention: DAG-<env>-<site> (example: DAG-PROD-HQ)
- Witness server: choose FileShareWitness on a domain-joined non-Exchange server or use cloud witness
- IP addressing for DAG (if using static)
- IPless DAG option (recommended in modern designs) — prefer IPless if load balancing client access

DAG creation (example, using IPless DAG)
1. Create DAG:
   New-DatabaseAvailabilityGroup -Name DAG-PROD-HQ -WitnessServer DC1.contoso.local -DatabaseAvailabilityGroupIpAddresses $null
2. Confirm DAG object exists:
   Get-DatabaseAvailabilityGroup DAG-PROD-HQ | Format-List Name,Servers,WitnessServer

Add Mailbox servers to DAG
1. Add first mailbox server (repeat for each server):
   Add-DatabaseAvailabilityGroupServer -Identity DAG-PROD-HQ -MailboxServer EXCH01
2. Confirm membership:
   Get-DatabaseAvailabilityGroupServer -Identity DAG-PROD-HQ

Create mailbox database copies
1. For each mailbox database on the source server:
   Add-MailboxDatabaseCopy -Identity DB1 -MailboxServer EXCH02 -ActivationPreference 2
2. Monitor copy status:
   Get-MailboxDatabaseCopyStatus -Identity DB1 | Format-Table Name,Status,ContentIndexState,ActivationPreference

Seeding and reseed considerations
- Use Update-MailboxDatabaseCopy for reseeding (use network/throttling options in heavy environments).
- Example reseed:
  Suspend-MailboxDatabaseCopy -Identity DB1\EXCH02 -Confirm:$false
  Update-MailboxDatabaseCopy -Identity DB1\EXCH02 -AllowFileRestore
  Resume-MailboxDatabaseCopy -Identity DB1\EXCH02

Validation (post-build)
- Ensure all copies are healthy:
  Get-MailboxDatabaseCopyStatus * | Where-Object {$_.Status -ne 'Healthy'}
- Validate client connectivity:
  Test-OutlookWebServices -Identity <user>
  Test-Mailflow -Identity <mailbox>
- Validate DAG and cluster state:
  Test-ReplicationHealth
  Get-Cluster; Get-ClusterGroup

Operational notes & best practices
- Avoid manual activation during normal operations; set activation preferences and let healthy copies auto-activate.
- Document activation priority per DB.
- Monitor lagged copies closely if used; plan reseed and skip preferences.

Rollback / mitigation
- If DAG creation fails during cluster formation, remove failed members:
  Remove-DatabaseAvailabilityGroupServer -Identity DAG-PROD-HQ -MailboxServer EXCH02
- If cluster corruption detected, follow Microsoft guidance for cluster repair or restore from pre-change backup.

References
- Microsoft Exchange DAG documentation