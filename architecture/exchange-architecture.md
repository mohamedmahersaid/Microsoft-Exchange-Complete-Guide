
# Exchange Server Architecture Guide

This section outlines the core architectural concepts of Microsoft Exchange Server 2016/2019 for on-premises and hybrid environments.

---

## 1. Exchange Server Roles

Modern Exchange uses a simplified role architecture:

- **Mailbox Server Role**: Hosts mailbox databases, client access services (MAPI, OWA, POP/IMAP, EWS), transport services, and Unified Messaging.
- **Edge Transport Role** (optional): Deployed in the DMZ for anti-spam, mail flow protection, and policy enforcement.

---

## 2. Recommended Deployment Models

| Model                                         | Description | Use Case |
|-------                                        |-------------|----------|
| Single Server                                 | All roles on one VM/server | Lab / small office |
| Multiple Mailbox Servers + Load Balancer      | High availability, better performance | Medium to large enterprises |
| DAG + Load Balancer                           | Full fault tolerance | Enterprise deployments |
| Hybrid (On-Prem + Exchange Online)            | Coexistence with Microsoft 365 | Cloud transition / hybrid identity |

---

## 3. Network Architecture

### Internal

- Subnet: `192.168.10.0/24`
- DNS: Internal AD DNS
- Clients connect via Load Balancer to Exchange servers.

### Perimeter

- NAT & Firewall to forward HTTPS (443) and SMTP (25)
- Optional Edge Transport in DMZ

---

## 4. Storage Design

- Use separate volumes for logs and databases
- Support JBOD or RAID10
- Follow Microsoft IOPS guidance
- DAG enables replication between servers

### DAG Basics

- Minimum 2 servers
- Witness server required for odd-member majority
- Automatic failover

---

## 5. Sample Diagram (include your .drawio/.png here)

```
[ Exchange Clients ]
        |
   Load Balancer
   |         |
[EX01]     [EX02]
   |  \     /  |
   |   DAG Replication
   |     |     |
  DB1   DB2   DB3
```

---

## 6. DNS and Virtual Directory Planning

| Service | Internal URL | External URL |
|---------|---------------|----------------|
| OWA     | mail.domain.local/owa | mail.domain.com/owa |
| ECP     | mail.domain.local/ecp | mail.domain.com/ecp |
| EWS     | mail.domain.local/ews | mail.domain.com/ews |

---

## 7. Sizing and Best Practices

- RAM: 8GB minimum; 32GB+ for production
- CPUs: 4+ cores
- NIC: 1Gbps minimum
- Use Exchange Calculator for sizing: https://aka.ms/exchangecalculator

---

## 8. References

- [Exchange Deployment Guide (Microsoft)](https://learn.microsoft.com/en-us/exchange/planning-and-deployment)
- [Exchange Preferred Architecture](https://learn.microsoft.com/en-us/exchange/plan-and-deploy/deployment-ref/preferred-architecture)
