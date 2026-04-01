# Incident Response Runbook — Exchange Critical Incidents

Purpose
Runbook to triage and resolve common critical incidents (mail queue buildup, transport stopping, DB dismount, high latency) with clear escalation and rollback steps.

Scope
- Critical incidents affecting mail flow or mailbox availability.

Initial triage (first 10 minutes)
1. Identify scope and impact:
   - Are users unable to send/receive mail? Which DAG/site?
   - Check key metrics: Get-Queue, Get-MailboxDatabaseCopyStatus, Test-ServiceHealth
2. Preserve evidence:
   - Collect event logs: Export-EventLog -LogName Application -Newest 1000
   - Copy ExchangeSetup.log, transport logs, and diagnostic logs from affected servers

Common incident workflows

A) Mail queue backlog
1. Inspect queues:
   Get-Queue | Sort-Object Quantity -Descending | Format-Table Identity, Status, MessageCount
2. Inspect specific connector queues:
   Get-Queue -Identity '<server>\<connector>' | Get-Message
3. If a specific remote host unreachable, verify DNS and network:
   nslookup <target>; Test-NetConnection -ComputerName <target> -Port 25
4. If due to transport service, restart transport service on affected servers:
   Restart-Service MSExchangeTransport
5. If queue grows due to malware or spam, throttle or apply transport rules to reject suspicious senders.

B) Transport service stopping or crash
1. Check event viewer for process crashes or .NET errors.
2. Restart service:
   Restart-Service MSExchangeTransport
3. If repeated crashes, place server in maintenance and failover using DAG or routing skip list:
   Set-TransportService -Identity EXCH01 -MaxConcurrentMailboxDeliveriesPerSource 0  (temporary throttle)
4. Collect crash dumps and escalate to Microsoft support if required.

C) Database went dismounted or corrupted
1. Check DB status:
   Get-MailboxDatabase -Status | Where-Object {$_.Mounted -eq $false}
2. Attempt to mount:
   Mount-Database DB1
3. If mount fails, examine Eseutil and event logs:
   eseutil /mh <path>\db.edb
4. Restore from Recovery Database as per backup-restore runbook if DB repair not viable.

D) High latency or resource exhaustion
1. Check CPU/memory/IO:
   Get-Counter '\Processor(_Total)\% Processor Time','\Memory\Available MBytes','\LogicalDisk(_Total)\% Disk Time'
2. Identify top processes:
   Get-Process | Sort-Object CPU -Descending | Select-Object -First 10
3. If required, move active databases to alleviate load:
   Move-ActiveMailboxDatabase -Identity DB1 -ActivateOnServer EXCH02

Escalation and communication
- Escalation matrix: Tier 1 -> Tier 2 Exchange SME -> Windows Cluster SME -> Network SME -> Microsoft Support
- Use incident channel (Slack/Teams/email) for real-time updates and runbook reference
- Notify change control and stakeholders with timelines and impact

Post-incident
- Create incident report with timelines, root cause analysis (RCA), corrective actions and follow-ups.
- Review monitoring thresholds, add alerts to prevent recurrence, and schedule remediation tasks.

Notes
- Preserve logs and evidence for RCA and for support cases.
- Always attempt non-destructive recovery first; document each change and step taken.