## MLOOK DTS Use Cases by User Type

### Students

#### 1. Submit Supporting Documents for Academic Requests

**Primary actor:** Student  
**Goal:** Provide digital copies of requirements (e.g., scholarship, clearance) for processing.  
**Stakeholders:** Student, registrar staff, department reviewers.

#### Preconditions
- Staff member is authenticated and verified.
- Required metadata such as document type, department, and urgency are known.

#### Main Success Scenario
1. Staff navigates to `Documents > Create new`.
2. System displays the document creation form with required metadata fields.
3. Staff completes metadata and uploads the primary attachment.
4. Staff selects initial recipient(s) or relies on auto-routing rules.
5. Staff submits the document.
6. System generates a tracking number, stores the record, and queues notifications.
7. Assigned recipients receive WebSocket and email alerts.

#### Extensions
- 3a. Upload fails → system displays validation error, staff retries.
- 4a. Auto-routing rules find no match → system prompts user to choose recipients manually.
- 5a. Network interruption → system retries submission or preserves draft for later.

#### Postconditions
- Document enters the `routing` state and is visible in the staff "Sent" list and recipients' "Inbox".
- Audit trail records creation event.
- Real-time dashboards update counts.

---

#### 2. Track Status of Personal Requests

**Primary actor:** Student  
**Goal:** Monitor progress of submitted documents and respond to remarks.  
**Stakeholders:** Student, reviewers, advisors.

##### Preconditions
- Student has submitted at least one document.
- Document routing includes student as originator.

##### Main Success Scenario
1. Student opens `Documents > My Requests`.
2. System lists active, returned, and completed documents with status chips.
3. Student filters by status or date to locate a specific request.
4. Student opens a document to review audit trail, remarks, and attachments.
5. If revisions are needed, student uploads the updated file or adds comments.
6. System notifies assigned staff that updates are available.
7. Student receives confirmation when the document advances to the next stage.

##### Extensions
- 4a. Student lacks access → system enforces permissions, preventing unauthorized viewing.
- 5a. Attachment rejected (e.g., wrong format) → validation warns and stops upload.

##### Postconditions
- All document updates captured in audit log.
- Student dashboard reflects current progress and outstanding actions.

---

### Faculty & Staff

#### 3. Submit New Document for Routing

**Primary actor:** Staff or Faculty member  
**Goal:** Start a workflow for a new document that requires review and approval.  
**Stakeholders:** Document owner, assigned reviewers, administrators.

#### Preconditions
- Department head is authenticated and has necessary role permissions.
- Document exists in the `in review` or `for approval` state for this actor.

#### Main Success Scenario
1. Department head opens the document from their inbox.
2. System shows full metadata, attachments, comments, and action history.
3. Department head reviews content and, if needed, adds comments.
4. Department head clicks `Approve`.
5. System prompts for optional remarks and confirms the action.
6. Document status updates to `approved` (or next state per workflow rules).
7. System notifies the creator and next stakeholders in real time.

#### Extensions
- 3a. Department head requires revisions → selects `Return` and adds mandatory remarks.
- 4a. Department head rejects → selects `Reject`; system records reason and halts workflow.
- 5a. Optimistic lock detects concurrent change → system reloads latest state before allowing action.

#### Postconditions
- Document history contains the approval record with timestamp, actor, and remarks.
- Analytics dashboards update performance metrics.

---

#### 4. Acknowledge and Route Received Documents

**Primary actor:** Department staff  
**Goal:** Confirm receipt and forward documents to appropriate recipients.  
**Stakeholders:** Upstream sender, downstream reviewers, administrators.

##### Preconditions
- Staff member has routing permissions.
- Document is assigned to staff inbox with `routing` status.

##### Main Success Scenario
1. Staff opens `Inbox` and selects a document marked as pending acknowledgement.
2. System displays summary with `Receive` action.
3. Staff clicks `Receive`; status transitions to `received`.
4. Staff reviews content; if additional routing is needed, chooses `Forward`.
5. Staff selects next recipient(s) manually or via recommended routing rules.
6. Staff optionally adds remarks or instructions, then confirms.
7. System updates routing history and notifies the new recipients.

##### Extensions
- 3a. Staff notices missing information → selects `Return` with remarks to sender.
- 5a. Auto-routing conflict → system prompts for manual selection.
- 6a. Network issue during forward → system retries or saves action as draft.

##### Postconditions
- Document reflects new holder and updated status.
- Sender and recipients receive notifications.

---

### Department Heads & Approvers

#### 5. Review and Approve Document

**Primary actor:** Department head or approver  
**Goal:** Approve, reject, or return an incoming document.  
**Stakeholders:** Document creator, downstream approvers, administrators.

#### Preconditions
- Administrator is authenticated with dashboard access.
- Latest metrics are available via cache or live aggregation.

#### Main Success Scenario
1. Administrator opens the dashboard.
2. System loads key performance indicators (KPIs) such as documents by status, turnaround time, and bottleneck departments.
3. Administrator filters by department, date range, or document type.
4. System updates charts and lists instantly via cached queries.
5. Administrator drills into a document to view full audit trail if required.

#### Extensions
- 2a. Metrics cache expired → system recomputes using queued jobs or live queries.
- 3a. Administrator exports CSV → system generates downloadable report.
- 5a. Document access restricted → system enforces role-based permissions, showing sanitized view or denying access.

#### Postconditions
- Administrator identifies workflow issues, enabling targeted interventions.
- Optional exports or snapshots stored for auditing.

---

#### 6. Assign Delegates During Absence

**Primary actor:** Department head  
**Goal:** Ensure continuity of approvals during planned leave.  
**Stakeholders:** Delegated staff, document creators, administrators.

##### Preconditions
- Department head has `delegate` feature enabled.
- Delegate has requisite permissions for targeted document types.

##### Main Success Scenario
1. Department head opens `Admin > Delegation`.
2. System lists current delegations and upcoming leaves.
3. Head selects date range and target document types to delegate.
4. Head chooses one or more staff members as delegates.
5. System validates permissions and asks for confirmation.
6. Delegation becomes active, rerouting new approvals to delegates.
7. System logs delegation, notifies delegates, and updates dashboards.

##### Extensions
- 4a. No eligible delegate → system informs head to adjust permissions.
- 6a. Head cancels leave → delegation is revoked immediately.

##### Postconditions
- Delegates receive future approvals; audit trail records delegated actions.
- Compliance logs reflect delegation changes.

---

### Registrar & Administrative Units

#### 7. Issue Official Documents to Students

**Primary actor:** Registrar staff  
**Goal:** Generate and deliver official documents (e.g., transcripts) digitally.  
**Stakeholders:** Students, department heads, record custodians.

##### Preconditions
- Student request approved and ready for fulfillment.
- Registrar staff has access to document templates and storage.

##### Main Success Scenario
1. Registrar opens approved request from `Documents > Completed`.
2. System shows fulfillment checklist.
3. Registrar uploads official document (PDF) and associates it with the record.
4. Registrar updates status to `Completed` and optionally schedules pickup.
5. System notifies student with download instructions or pickup details.
6. Audit log records fulfillment metadata and responsible staff.

##### Extensions
- 4a. Document requires signature → registrar triggers signature workflow.
- 5a. Student lacks portal access → system sends alternate communication (email).

##### Postconditions
- Student can download official document; record archived for compliance.
- Fulfillment metrics updated for reporting.

---

### Administrators

#### 8. Monitor Document Progress

**Primary actor:** Administrator  
**Goal:** Track lifecycle and performance of documents across departments.  
**Stakeholders:** Executive stakeholders, compliance officers.

#### Preconditions
- User has an active browser session connected via Laravel Echo/Reverb.
- Broadcasting configuration is operational.

#### Main Success Scenario
1. A triggering event occurs (e.g., document forwarded, comment added, signature completed).
2. Backend dispatches the corresponding `ShouldBroadcast` event.
3. Reverb server relays the event to subscribed channels.
4. User's browser receives the payload via WebSocket.
5. Frontend updates notification badge, toast, and relevant lists in real time.

#### Extensions
- 3a. WebSocket server unavailable → frontend falls back to polling or displays connectivity warning.
- 4a. User muted specific notification types → frontend suppresses toast but keeps log entry.

#### Postconditions
- Notification center reflects the new event with read/unread state.
- Audit log captures broadcast and acknowledgement when applicable.

---

#### 9. Respond to System Incidents

**Primary actor:** System administrator  
**Goal:** Diagnose and resolve issues such as failed jobs, notification outages, or storage errors.  
**Stakeholders:** All user roles relying on system availability.

##### Preconditions
- Monitoring alerts or user reports identify a potential incident.
- Administrator has access to logs, queues, and cloud dashboards.

##### Main Success Scenario
1. Administrator reviews alerts (Laravel Pail logs, queue dashboards, uptime monitors).
2. System provides contextual details: stack traces, failed job payloads, broadcast errors.
3. Administrator reproduces or diagnoses root cause.
4. Administrator applies fix (e.g., restart service, deploy patch, adjust config).
5. System health checks return to normal.
6. Administrator communicates resolution via status page or announcements.
7. Post-incident review updates runbooks or automation scripts.

##### Extensions
- 3a. Root cause unclear → administrator escalates to development team with diagnostics.
- 4a. Requires code patch → hotfix deployed under change control.
- 5a. Issue recurs → automated rollback or scaling scripts executed.

##### Postconditions
- System stability restored; incident documented.
- Preventive actions queued for future sprint.

---

### System Scheduler (Automated Tasks)

#### 10. Run Automated Backups

**Primary actor:** System scheduler (cron)  
**Goal:** Ensure regular backups of data and storage assets.  
**Stakeholders:** IT operations, compliance officers.

#### Preconditions
- Scheduled task configured (`php artisan schedule:run`).
- Storage disks and database connections properly configured.

#### Main Success Scenario
1. Cron triggers Laravel scheduler.
2. Scheduler executes `backup:run` per configuration.
3. Spatie Backup package dumps database, copies storage files, and creates archive.
4. System stores backup locally or uploads to configured disks (e.g., S3).
5. Success notification logged and optionally broadcast to administrators.

#### Extensions
- 3a. Disk quota exceeded → package logs failure and raises notification.
- 4a. Cloud storage unreachable → backup retained locally and retry scheduled.

#### Postconditions
- Latest backup archive available for recovery.
- Backup run recorded in audit logs and optional dashboard metrics.

---

These use cases highlight typical interactions across creation, approval, monitoring, notifications, and maintenance—covering the core lifecycle of the MLOOK Document Tracking System.

