Event-Pass

A secure, programmable event pass smart contract built in **Clarity** for the **Stacks blockchain**.

---

 Overview

**Event-Pass** is a decentralized smart contract that enables event organizers to issue, manage, and validate blockchain-based event passes.

Each pass is represented as a non-fungible on-chain asset that can function as a digital ticket, membership credential, or access authorization token. The contract enforces deterministic rules for minting, ownership, validation, and optional transfer restrictions.

This solution reduces ticket fraud, improves transparency, and enables programmable access control for events.

---

 Problem Statement

Traditional ticketing systems suffer from:

- Ticket fraud and duplication
- Scalping and unauthorized resale
- Centralized custody risks
- Limited transparency
- Manual verification processes

Event-Pass addresses these issues by:

- Issuing tamper-resistant on-chain passes
- Enforcing controlled minting authority
- Preventing double validation
- Providing transparent ownership tracking
- Enabling deterministic access verification

---

 Architecture

 Built With
- **Language:** Clarity
- **Blockchain:** Stacks
- **Framework:** Clarinet

 Asset Model
- NFT-style event pass representation
- Unique pass ID per ticket
- Event-specific metadata support

---

 Roles

1. Organizer
- Creates events
- Defines event metadata
- Mints event passes
- Configures transfer permissions
- Validates entry (or delegates validation)

2. Attendee
- Receives or purchases event pass
- Holds ownership of pass
- Uses pass for event entry

3. Validator (Optional)
- Verifies pass authenticity
- Marks pass as used upon entry

---

Pass Lifecycle

1. Organizer creates an event.
2. Event metadata (name, date, venue, capacity) is stored on-chain.
3. Organizer mints passes up to the event capacity.
4. Passes are assigned to attendees.
5. At event entry:
   - Pass ownership is verified.
   - Pass validity is checked.
   - Pass is marked as used (if configured).
6. Pass cannot be reused once marked.

---

Core Features

- Organizer-controlled minting
- NFT-style pass ownership tracking
- Unique pass IDs
- Event metadata storage
- Entry validation logic
- Anti-duplication safeguards
- Optional transfer restrictions
- Burn or mark-as-used functionality
- Deterministic state transitions
- Transparent on-chain logging
- Clarinet-compatible project structure

---

 Security Design Principles

- Restricted minting authority
- Prevention of double validation
- Explicit state lifecycle enforcement
- Deterministic verification checks
- Minimal external dependencies
- Audit-ready architecture

---

License

MIT License

---
 Development & Testing
1. Install Clarinet
Follow official Stacks documentation to install Clarinet.

2. Initialize Project
```bash
clarinet new event-pass

