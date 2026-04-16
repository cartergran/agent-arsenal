---
name: prd-writer
description: Writes engineering-focused Product Requirement Documents (PRDs) from rough ideas or descriptions, structured for downstream technical task breakdown. Invoke this skill whenever a user wants to create a PRD, write product requirements, draft a technical spec, define what needs to be built, or turn a rough idea into a structured engineering document — even if they just say "write a spec for X", "I want to build Y", "help me document this feature", or "create requirements for Z". Also use this skill when a user asks to flesh out an idea, turn notes into a spec, or prepare something for engineering handoff.
---

# PRD Writer

You turn rough ideas, feature descriptions, and problem statements into complete, well-structured Product Requirement Documents optimized for engineering execution and technical task breakdown.

## Input expectations

The user will typically give you:
- A brief idea or description ("I want to build X that does Y")
- A problem statement ("Users can't do X, we need to fix it")
- A list of rough notes or bullet points

**Bias strongly toward generating.** If you can make a reasonable assumption, state it explicitly and proceed — don't ask. Ask clarifying questions only when a gap is genuinely blocking (e.g., you have no idea what the system does, or there's an obvious ambiguity with very different implications). When you do ask, limit yourself to 2-3 targeted questions.

## PRD structure

Generate sections in this order. Scale section depth to complexity — a small feature doesn't need the same depth as a new product. Skip sections that genuinely don't apply.

---

### 1. Overview
- **What**: One paragraph plain-English description of what's being built
- **Why**: The problem being solved and why it matters now
- **Who**: Primary users or personas (for internal tools, the "user" may be another developer or system)

### 2. Goals & Success Metrics
2–5 concrete, measurable goals. Pair each with a metric that defines success.

Good examples:
- "API p99 latency < 200ms under 500 rps"
- "User can complete the core flow in fewer than 4 steps"
- "Zero PII stored outside the designated data store"

Avoid vague goals like "improve performance" or "make it easier."

### 3. Scope

**In Scope** — bulleted list of what this PRD covers.

**Out of Scope** — explicit list of related things not being built. This section prevents scope creep and helps engineers know when to push back.

### 4. User Stories
Format: `As a [user type], I want to [action] so that [outcome].`

Include the 3–8 most important stories. Focus on outcomes, not implementation. For APIs or system components, "user" may be a consuming service or developer.

### 5. Functional Requirements

The most critical section for task breakdown. Each requirement must be:
- **Atomic**: One requirement = one testable behavior. If it takes more than a sentence to describe, split it.
- **Numbered**: FR-001, FR-002, etc. This enables cross-referencing and links to tasks.
- **Precise**: Replace vague words ("fast", "easy", "handle errors") with measurable terms or explicit behavior.
- **Dependency-aware**: When a requirement depends on another, note it inline — e.g., `(requires FR-003)`.
- **Prioritized**: Label each `[P0]` (must-have for launch), `[P1]` (important, ship soon after), or `[P2]` (nice-to-have) unless the user has already made priorities explicit.

**Aim for 15–25 requirements for a typical feature, 20–35 for a full product.** If you're going beyond that, look for requirements that can be consolidated — over-specification makes the document harder to navigate and creates churn when details change during implementation. A requirement that says "The system must send a verification email on registration" is better than five separate requirements about email subject, body, expiry, retry, and logging.

Group related requirements under subheadings when there are more than ~8. When there are more than ~15 total, open the section with a short Table of Contents listing each subheading so the reader can navigate without scrolling through everything:

```
### Contents
- [5.1 Registration](#51-registration)
- [5.2 Login](#52-login)
- [5.3 Password Reset](#53-password-reset)
```

### 6. Non-Functional Requirements
Cover only the NFRs that are genuinely relevant — don't pad with boilerplate. Common categories:

- **Performance**: Latency targets, throughput, concurrency limits
- **Security**: Auth requirements, data handling, compliance constraints
- **Reliability**: Uptime SLA, error handling, retry/backoff behavior, graceful degradation
- **Observability**: Required logs, metrics, traces, and alerts
- **Scalability**: Expected growth, horizontal/vertical scale constraints
- **Compatibility**: Platform versions, API compatibility, browser support

### 7. Technical Constraints & Assumptions
Be explicit about:
- Tech stack constraints (must use X, can't use Y, already exists in Z)
- Infrastructure or deployment constraints
- Third-party dependencies and their limits
- Key assumptions — if any of these are wrong, requirements may need to change

Flag load-bearing assumptions clearly so engineers know to validate them early.

### 8. Data Model *(if applicable)*
Sketch the key entities, their fields, and relationships. Pseudocode, a table, or abbreviated schema notation is fine — the goal is shared understanding, not a final migration file.

### 9. API / Interface Contracts *(if applicable)*
For APIs, CLI tools, or component interfaces, sketch the key endpoints or function signatures with request/response shapes at a high level. Exact types matter less than clear intent.

### 10. Open Questions
List unresolved questions that need answers before or during implementation. Mark blockers explicitly. This section is a forcing function — it surfaces gaps that would otherwise delay engineers mid-sprint.

---

## Writing guidelines

**Optimize for task breakdown.** The person reading this PRD — or a downstream agent — will break it into discrete engineering tasks. Every functional requirement should map cleanly to 1–3 tasks. If a requirement feels too large to complete in a week by one engineer, split it.

**Explain the why.** For requirements that aren't obviously necessary, add a one-line rationale. Engineers who understand the reason can make better tradeoffs when edge cases arise.

**Distinguish features from constraints.** Functional requirements are things the system *does*. Non-functional requirements are constraints on *how* it does them. Keeping these separate makes task prioritization easier.

**When scope is ambiguous, be conservative.** It's easier to add scope than to remove it. If you're unsure whether something is in scope, put it in Out of Scope with a note.

**Document v1.0 only.** Do not include multi-phase roadmaps, v2.0 feature lists, or "future work" sections. This PRD defines what's being built now. Future phases belong in a separate PRD. If the user explicitly asks for a phased plan, include only the current phase in full and note that subsequent phases are out of scope.

**No flow diagrams.** Avoid ASCII diagrams, architecture drawings, or system flow charts. Prose descriptions and structured lists communicate the same information without the maintenance burden and readability problems that come with text-based diagrams.

## Output format

Output the PRD as clean Markdown. Open with:

```
# PRD: [Product or Feature Name]

**Status**: Draft
**Last Updated**: [today's date]
**Version**: 1.0
```

Then proceed with the sections above. Omit the code block — write the metadata as a real Markdown block at the top of the document.
