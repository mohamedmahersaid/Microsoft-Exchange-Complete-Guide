# Microsoft Exchange Server Architecture Overview

Microsoft Exchange Server is a robust, enterprise-class email, calendaring, contact, and collaboration platform. Its architecture is modular, scalable, and designed for high availability and hybrid integration.

---

## 🔧 Core Roles and Components

| Role               | Description                                                                 |
|--------------------|-----------------------------------------------------------------------------|
| **Mailbox Server** | Hosts mailbox databases and transport service. All client access and mail flow occur here in Exchange 2016/2019. |
| **Edge Transport** | Deployed in DMZ, handles anti-spam, routing, and SMTP relay (optional).     |
| **Client Access Services** | Provides HTTPS endpoints for Outlook, EAS, OWA — now a service inside Mailbox role. |

---

## 📦 Service Layers

- **Transport Layer** – Responsible for routing mail between mailboxes and to/from external systems.
- **Store Layer (Information Store)** – Manages mailbox databases (.edb files), indexing, and log files.
- **Client Access Layer** – Handles user connectivity: MAPI/HTTP, Outlook Anywhere, ActiveSync, OWA.

---

## 🗂️ Key Exchange Databases

- **Mailbox Databases (.edb)** – Stores all user mailbox data, calendar items, tasks, contacts.
- **Queue Databases** – Temporarily store emails during routing (mail.que, poison.que).
- **Search Index Catalogs** – Full-text indexing for OWA/Outlook searches.

---

## 📡 Protocols Used

| Protocol       | Purpose                               |
|----------------|----------------------------------------|
| HTTPS (443)    | Outlook, OWA, EAC, EWS, ActiveSync     |
| SMTP (25, 587) | Mail flow (external/internal)          |
| MAPI/HTTP      | Primary Outlook connectivity protocol  |
| RPC/HTTP       | Legacy Outlook connectivity (deprecated)|
| IMAP/POP3      | Optional legacy client protocols       |

---

## 🔁 High Availability (DAG)

Exchange supports **Database Availability Groups (DAG)** for native HA and site resilience:
- Multiple mailbox servers hosting replicated copies
- Built-in log shipping and replay mechanism
- Supports automatic or manual failover

---

## 🌐 Hybrid Connectivity

Exchange Hybrid allows:
- Coexistence with Microsoft 365 (Exchange Online)
- Mail routing between cloud/on-prem
- Shared GAL, Free/Busy, and mailbox migration

Hybrid deployment includes:
- Exchange Hybrid Configuration Wizard (HCW)
- Azure AD Connect with Exchange Hybrid Writeback
- OAuth-based modern authentication

---

## 🔍 Architecture Diagram (Suggested)

```plaintext
Internet
   │
Edge Transport (Optional)
   │
Client Access Services (HTTPS)
   │
Mailbox Server Role (Transport + Store)
   │
Mailbox Databases (.edb)
```

---

## 📌 Summary

Microsoft Exchange combines transport, storage, and access layers into a unified architecture. Since 2016, all roles are merged into the **Mailbox role**, simplifying deployments while maintaining advanced capabilities like DAG, hybrid, and compliance.

For production deployments, always:
- Deploy at least 2 DAG members with witness server
- Use load balancers for HTTPS access
- Monitor queue health and index state

---

### ✅ Next:
- `installation/deployment-guide.md` – Complete step-by-step install on Windows Server.