# Decommissioning Exchange Server Runbook

Purpose
Safe, supported procedure to decommission an Exchange server (retire out-of-service servers) without disrupting mail flow or configuration.

Scope
- Remove a server from Exchange organization cleanly (mailbox server or edge server decommission).

Preconditions
- Confirm no active mailboxes or arbitration mailboxes on the server.
- Verify server not hosting active DB copies (move or reseed copies first).
- Ensure you have backups and a rollback plan.
- Update capacity & architecture documentation to reflect removal.

Steps for mailbox server decommission
1. Move mailboxes:
   Get-Mailbox -Server EXCH01 | New-MoveRequest -TargetDatabase DB_On_Other_Server
   Wait and verify moves:
   Get-MoveRequest | Get-MoveRequestStatistics
2. Remove database copies:
   For each DB copy on EXCH01:
   Remove-MailboxDatabaseCopy -Identity DB1\EXCH01
3. Remove mailbox databases if empty:
   Dismount-Database DB1; Remove-MailboxDatabase DB1 (only if no mailboxes remain)
4. Remove server from DAG (if member):
   Remove-DatabaseAvailabilityGroupServer -Identity DAG01 -MailboxServer EXCH01
5. Uninstall Exchange from the server:
   Setup.exe /Mode:Uninstall
6. Remove server object from AD if necessary:
   Remove-Computer or demote as needed (follow domain admin guidance)

Steps for Edge Transport server decommission
1. Remove Edge subscriptions (if any) or re-subscribe to a new Edge.
2. Remove Edge Transport server:
   Uninstall Edge Transport via Control Panel or setup /Mode:Uninstall

Validation
- Confirm no mailboxes or DB copies remain on the server.
- Confirm connectors and transport are functioning without the server.
- Update inventory and asset management system.

Rollback and contingency
- If removal causing mail flow disruption, re-introduce the server (reinstall) or restore DBs from backup and bring back online following rollback plan.
- Keep decommission window under change control and retain server images for a retention period.

Documentation
- Record decommission steps, timestamps, responsible engineers, and verification logs for audit.