---
name: prd-breakdown
description: Translates a Product Requirements Document (PRD) into implementation-ready technical task briefs grouped by agent track (frontend, backend, database, infrastructure, data, etc.), with each task containing rich context so the implementing agent can work autonomously. Use this skill whenever a user wants to break a PRD into engineering tasks, generate an implementation plan from a spec, create a task list for agents, assign work to specialized agents by discipline, or go from requirements to "what each engineer or agent should actually build." Also invoke this skill when the user says things like "break this PRD down", "create tasks from this spec", "what would the frontend agent need to do", "plan out the implementation", "give me agent-ready tasks", "turn this PRD into tickets", or "what do I hand to each engineer". If a PRD or spec is in context or a file path is provided, use this skill proactively.
---

# PRD Breakdown

You translate a Product Requirements Document into a set of implementation-ready task briefs — one batch per agent track — where each task contains enough context that the implementing agent can work autonomously without re-reading the full PRD.

The output is designed to be handed directly to agents (or engineers). The goal is that a frontend agent, a backend agent, and a database agent can each receive their section and get to work with no additional reading required.

## Getting the PRD

The user will provide the PRD in one of:
- A file path (e.g., `PRD.md` or `docs/spec.md`) — read it
- Pasted content in the prompt
- A reference to a document already in context

If nothing is provided, check for `PRD.md` in the current directory. If you still can't find it, ask for it.

**Also look for design assets.** Check whether the user has provided mockups, wireframes, or screenshots alongside the PRD — either as file paths, a `screens/` or `designs/` directory, or images in context. If found, read/view them. Design assets are primary source material for frontend tasks: they resolve ambiguities the PRD text leaves open (layout, component hierarchy, visual states, interaction flows) and should be referenced directly in the relevant task briefs.

## Step 1: Orient yourself

Before generating anything, read the PRD carefully with these questions:

1. **What is being built?** (Overview section) — one product, one feature, or one API?
2. **What tech stack?** (Technical Constraints section) — this tells you which agent tracks to create
3. **What are the P0 requirements?** — these define the minimum viable scope
4. **What are the key data entities and their relationships?** (Data Model section)
5. **What integration patterns or queries exist?** (API/Interface Contracts section)
6. **What performance, security, or reliability constraints apply?** (NFRs)
7. **What is explicitly out of scope?** (Scope section) — prevents agents from over-building
8. **What questions are unresolved?** (Open Questions) — propagate these to the tasks they affect

## Step 2: Identify agent tracks

Map the PRD's tech stack to agent tracks. Common mappings:

| Tech element | Agent track |
|---|---|
| React, React Native, Vue, mobile UI, screens, components, animations | **Frontend** |
| Node, Express, Python/FastAPI, Go, REST/GraphQL API, business logic services | **Backend** |
| SQL schema, migrations, indexes, RLS policies, query patterns, seeds | **Database** |
| CI/CD pipelines, Docker, cloud infra, deployment config, environments | **Infrastructure** |
| ETL jobs, data pipelines, ML models, seed scripts, data ingestion | **Data** |
| Auth system, identity provider integration, session management | **Auth** (merge into Backend if small) |

**Use only the tracks the PRD actually needs.** A Supabase + React Native app likely needs Frontend and Database tracks — not a separate Backend track, since Supabase handles the server side. A Rails API with a React frontend needs Backend, Frontend, and Database. Don't invent tracks that have no work.

**Name tracks based on the actual tech** when it helps clarity: "React Native" instead of just "Frontend", "Supabase / PostgreSQL" instead of just "Database".

## Step 3: Map requirements to tracks

For each functional requirement (FR-xxx), assign it to one primary track. Some FRs touch multiple tracks — note both, but assign the task to the track that owns the bulk of the implementation.

Patterns to watch for:
- Auth flows often have work in both Frontend (forms, state, routing) and Backend/DB (schema, policies)
- Data model changes always touch Database, even when driven by a frontend feature
- Offline sync requirements belong to Frontend (local queue) and Database (sync logic)
- Performance NFRs may generate tasks on both Frontend (prefetch, caching) and Backend (query optimization)

## Step 4: Generate tasks

For each track, write a set of tasks. A good task is:

**Implementation-sized.** One task = 0.5–2 days of work for a skilled engineer. "Implement authentication" is too large. "Implement user registration form with Supabase Auth, including inline username availability check" is right-sized.

**Self-contained.** Include all the context the implementing agent needs: quoted FR text, relevant data model fields, applicable query patterns, relevant NFRs. Don't make the agent hunt for information across the PRD.

**Dependency-aware.** If this task can't start until another is done, say so explicitly. Think about the order things need to land: DB schema usually comes before backend queries, backend queries before frontend integration.

**Criterion-backed.** Each task has acceptance criteria derived from the FR text — specific, testable things the agent can verify when they're done.

**Question-surfacing.** If an Open Question from the PRD affects this task, include it. Better to surface ambiguity before the agent starts building than to have them assume and get it wrong.

## Step 5: Sequence and dependencies

Sequence tasks within each track section **first-to-build to last** — the ordering itself communicates the recommended build sequence without a separate summary section.

For cross-track dependencies, use the `Depends on` field in the individual task: e.g., `Depends on: DB-001 (schema must exist before queries can run)`. Keep the description brief and plain — no dependency graphs or visual representations. A one-line sentence per dependency is enough; the agent reading it should be able to act on it immediately.

Do **not** add a separate "Dependency Summary", "Build Order", or "Critical Path" section at the end of the document. That information belongs in each task's `Depends on` field and in the sequencing order within each track.

## Output format

Produce the output as a markdown document. Use this structure:

```markdown
# Implementation Tasks: [Product Name]

**Source PRD**: [filename or "provided in context"]
**Generated**: [today's date]
**Scope**: [All priorities / P0 only / etc.]

---

## Overview

[2–3 sentences: what's being built, the tech stack, and the approach — enough that any agent can orient without reading the PRD]

## Tracks

- [Track Name](#track-slug) — N tasks (X P0, Y P1)
- ...

---

## [Track Name]

### Shared context for this track

[Everything an agent in this track needs to know before looking at individual tasks: stack details, key constraints, relevant data models, auth assumptions, NFRs that apply across all tasks in this track. Be generous here — context that seems obvious to you may not be obvious to an agent starting fresh.]

---

### [TRACK-001] Task Title

**Priority**: P0
**Satisfies**: FR-012, FR-013
**Depends on**: [other task ID(s), or "none"]

**What to build**
[1–3 sentences describing the concrete deliverable]

**Relevant spec**
[Quote or summarize the exact PRD content this agent needs: FR text, data model fields, query patterns, NFRs. Be specific — if FR-012 says "four action buttons", quote that. If the data model has a UNIQUE constraint relevant to this task, mention it. If a mockup or screenshot covers this screen or component, reference it by filename here — e.g., "See screens/screen-discover.png for the card stack layout."]

**Acceptance criteria**
- [ ] [Specific, testable criterion matching an FR]
- [ ] [Another criterion]

**Notes / open questions**
[Anything the agent should flag or clarify before or during implementation. Include relevant Open Questions from the PRD.]
```

Aim for 5–15 tasks per track for a typical feature, 10–25 for a full product. If you're approaching 30+ tasks per track, look for related tasks that can be combined. Better to have slightly larger tasks with clear criteria than a sprawling list that's hard to navigate.

## Context richness

The most important thing that separates a useful task brief from a useless one is context. Lean toward including more rather than less. Unlike a Jira ticket written for an engineer who can ask follow-up questions, an agent task brief has to be self-contained. Quote the relevant FR text. Include the data model fields. Repeat the NFR latency targets. If you're unsure whether a piece of context belongs in a task, include it.

The one exception: don't copy entire PRD sections wholesale into every task. Be selective — include the excerpts that actually apply.

## What to leave out

**No implementation code.** Don't write TypeScript, Python, SQL, or any other implementation code in tasks. The "Relevant spec" section should quote or paraphrase the PRD's spec (FR text, data model schema, API shapes from the PRD itself) — not show how to implement it. Leave implementation decisions to the agent doing the work. A task that says "the users table has `password_hash text` (null for OAuth users)" is useful context. A task that shows a `bcrypt.hash()` code sample is over-specifying and takes agency away from the implementing agent.

**No dependency graphs or visual representations.** Express dependencies as plain-language text in the `Depends on` field. No ASCII graphs, arrow diagrams, or table-based dependency matrices.

**No single shared "Definition of Done."** Every task must have its own `Acceptance criteria` checklist. A global definition at the top of the document doesn't help an agent working on a specific task.

**Tracks by discipline, not by feature.** A "Feed" track or a "Authentication" track that mixes frontend and backend work is not useful — an agent specialized in React can't use it alongside an agent specialized in SQL. Always split by skill: Frontend, Backend, Database, Infrastructure, etc.
