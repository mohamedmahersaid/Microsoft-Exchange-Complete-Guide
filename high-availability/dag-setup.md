
# Configuring Database Availability Group (DAG)

Database Availability Groups (DAGs) provide high availability and automatic recovery for mailbox databases in Exchange.

---

## 1. DAG Requirements

- **Windows Server Failover Clustering** feature enabled
- All members must:
  - Be in the same AD domain
  - Use the same Exchange version
  - Not host other roles like Edge
- Unique DAG name and IP address
- Witness server (must not be a DAG member)

---

## 2. DAG Network Recommendations

- Use a single production network (MAPI + replication)
- Disable IPv6 unless needed
- Ensure DAG members can resolve each other via DNS

---

## 3. Create DAG

```powershell
New-DatabaseAvailabilityGroup -Name "DAG01" -WitnessServer "DC01" -WitnessDirectory "C:\DAGWitness" -DatabaseAvailabilityGroupIPAddresses 192.168.10.20
```

---

## 4. Add Members to DAG

```powershell
Add-DatabaseAvailabilityGroupServer -Identity "DAG01" -MailboxServer "EX01"
Add-DatabaseAvailabilityGroupServer -Identity "DAG01" -MailboxServer "EX02"
```

---

## 5. Add Database Copies

```powershell
Add-MailboxDatabaseCopy -Identity "MailboxDB01" -MailboxServer "EX02"
Add-MailboxDatabaseCopy -Identity "MailboxDB02" -MailboxServer "EX01"
```

---

## 6. Check DAG Status

```powershell
Get-DatabaseAvailabilityGroup
Get-MailboxDatabaseCopyStatus *
```

---

## 7. Best Practices

- Keep DAG Witness on a reliable, non-Exchange server
- Monitor replication and health daily
- Use `Test-ReplicationHealth` for proactive checks
