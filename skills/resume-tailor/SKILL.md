---
name: resume-tailor
description: Tailors a software engineer's LaTeX resume to a specific job posting for the highest possible ATS (Applicant Tracking System) match score. Invoke whenever a user wants to customize, tailor, optimize, rewrite, or "ATS-ify" a resume or CV for a particular job, role, or company — especially when they give a path to a .tex resume file and have a job description to paste. Trigger on requests like "tailor my resume for this job", "optimize my CV for ATS", "make resume.tex match this posting", "customize my resume for this role at Stripe", "rework my resume for this JD", or any message that pairs a LaTeX resume with a job posting. Outputs a kebab-case folder in the current directory containing the updated .tex, a compiled .pdf, and a change report. Use this even when the user doesn't say the word "ATS" — any "make my resume fit this job" intent should trigger it.
---

# Resume Tailor

You take a software engineer's existing LaTeX resume and a target job posting, and produce a tailored version of that resume engineered to score highly in Applicant Tracking Systems (ATS) while staying compelling to a human reviewer. The deliverable is a self-contained folder — named after the job in kebab-case — holding the updated `.tex`, the compiled `.pdf`, and a `CHANGES.md` report.

The job here is **judgment, not mechanical find-and-replace.** ATS keyword matching is the floor, not the ceiling. A resume that's keyword-stuffed but reads like spam fails the human screen that comes right after the ATS. Aim for a document that an ATS ranks near the top *and* a hiring manager wants to read.

## Inputs

You need two things:

1. **The resume** — a path to a `.tex` file. The user usually provides this. If they didn't, ask for the path.
2. **The job posting** — the full text of the role's description. If the user hasn't already pasted it, ask them to paste it in now. Don't proceed on a job title alone; you need the real responsibilities and requirements to extract keywords accurately.

Read the `.tex` file fully before doing anything else, and read the job posting carefully. If either is missing, ask for it rather than guessing.

## Tailoring philosophy

The user has explicitly asked for **aggressive keyword matching with modest, defensible truth-stretching.** They are a fast learner and are comfortable presenting adjacent or quickly-learnable technologies favorably. Honor that — but stay inside the lines that keep them safe in an interview:

- **Reframe and re-emphasize real work** to mirror the posting's exact terminology. If they "built APIs" and the job wants "RESTful microservices," and the work genuinely was services, say "designed and shipped RESTful microservices." This is the highest-value, zero-risk move — do it everywhere it applies.
- **Mirror the posting's vocabulary precisely.** ATS matches on exact strings. If the JD says "CI/CD pipelines," use "CI/CD pipelines," not "automated build systems." If it says "Kubernetes," don't settle for "container orchestration."
- **Stretch modestly toward adjacent/learnable tech.** If the resume shows Docker and the job wants Kubernetes, it's defensible to surface container-orchestration exposure or list Kubernetes as a familiar tool — the user can ramp quickly. Favor stretches that are *plausible given the existing experience*, not inventions from nothing.
- **Never fabricate hard facts.** Do not invent employers, job titles, dates, degrees, certifications, or shipped products that don't exist. Do not claim years of deep expertise in something never touched. These are the things that blow up an interview or a background check — keep them true.
- **Flag every stretch.** Anything you added or amplified beyond a literal reading of the original goes in the `CHANGES.md` "Review before you submit" list, so the user can prepare talking points or veto it. This is what makes aggressive tailoring safe: full transparency back to the user.

When in doubt about whether a stretch is defensible, ask yourself: "Could the user speak to this for two minutes in an interview without getting caught out?" If yes, it's fair game; if no, flag it loudly or leave it out.

## Workflow

### Step 1 — Analyze the job posting

Extract and organize what the ATS and the hiring manager will screen for:

- **Hard skills / technologies**: languages, frameworks, databases, cloud platforms, tools. Capture exact spellings and both acronym + expansion forms (e.g., "AWS" and "Amazon Web Services").
- **Required vs. preferred**: separate must-haves from nice-to-haves. Must-haves drive placement; nice-to-haves are bonus keyword coverage.
- **Responsibilities and domain language**: the verbs and nouns describing the day-to-day (e.g., "distributed systems," "low-latency," "observability," "design reviews").
- **Seniority and scope signals**: leadership, mentorship, ownership, on-call, cross-functional — fold these in where the user's experience supports them.
- **The exact role title** and **company name** — you'll need these for the output folder name.

Build a mental (or written) keyword checklist. You'll verify coverage against it at the end.

### Step 2 — Map the resume against the posting

Go through the resume section by section and identify:

- Which JD keywords are **already present** (good — make sure they're prominent).
- Which are **present but buried or under-worded** (reframe to surface them).
- Which are **absent but supportable** by existing experience (add via reframing or the skills section).
- Which are **absent and unsupportable** (candidates for a flagged stretch, or omit).

### Step 3 — Rewrite, preserving the LaTeX

Edit the resume to maximize relevant keyword coverage and recency-weighted relevance:

- **Skills/Technologies section**: this is the single highest-leverage ATS surface. Ensure every must-have technology the user can credibly claim appears here, spelled exactly as the JD spells it. Group sensibly (Languages, Frameworks, Cloud/Infra, etc.).
- **Experience bullets**: rewrite to lead with impact and embed JD keywords naturally. Quantify wherever the original gives you numbers (or where the user can plausibly supply them — flag invented numbers). Prioritize bullets most relevant to this role; reorder within a job if it helps.
- **Summary/objective** (if present, or add a short one if the template supports it): a 2–3 line headline mirroring the role title and top keywords is a strong ATS and human signal.
- **Preserve the template.** Keep the document's existing LaTeX structure, packages, custom commands, and styling intact. Edit content inside the existing macros — don't rewrite the formatting or swap the document class. The output must compile with the same engine the original was written for. If the resume runs long, tighten rather than restructure.

Follow the ATS formatting rules in `references/ats-guidelines.md` — read that file before finalizing. It covers what ATS parsers can and can't read (tables, columns, headers/footers, glyphs) and how to keep a LaTeX resume machine-readable.

### Step 4 — Create the output folder and write the .tex

Derive a kebab-case folder name from the company and role, e.g. `stripe-senior-backend-engineer` or `acme-platform-engineer`. If the company is unknown, use the role alone (`senior-backend-engineer`). Create the folder **in the current working directory**.

Write the tailored resume as `<folder>/<original-filename>` (keep the original base filename so the user recognizes it). If the original template `\input{}`s or `\include{}`s other files, copy those dependencies into the folder too so it compiles standalone.

### Step 5 — Compile to PDF

Use the bundled script, which auto-installs Tectonic via Homebrew if no LaTeX engine is present, then compiles:

```bash
bash <skill-dir>/scripts/build_pdf.sh <folder>/<resume>.tex
```

The script prefers `tectonic` and falls back to `latexmk`/`xelatex`/`pdflatex` if one is already installed. It writes the `.pdf` next to the `.tex`. If compilation fails, read the LaTeX error, fix the offending edit (a stray brace, an undefined macro you introduced), and recompile — do not hand back a broken `.tex`. The original compiled, so any failure is almost always something your edit introduced.

### Step 6 — Write CHANGES.md

In the same folder, write a `CHANGES.md` report so the user can review and prep. Include:

```markdown
# Tailoring report — <Role> @ <Company>

## ATS keyword coverage
| JD keyword | Required? | Covered? | Where |
|---|---|---|---|
| Kubernetes | required | yes | Skills, Bullet 2 (Acme) |
| ... | | | |

## What changed
- Reframed <X> bullets to mirror JD terminology
- Added a Summary headlining the role
- Reordered Experience to lead with the most relevant role
- ...

## Review before you submit  ⚠️
Stretches and amplifications you should be ready to speak to (or veto):
- Listed Kubernetes as familiar — backed by Docker experience, not production K8s. Prep a talking point.
- ...

## Estimated ATS match
A short, honest read on coverage of must-have vs. preferred keywords.
```

Be candid in the coverage table and the review list — its value is letting the user walk into the interview unsurprised.

## Wrapping up

Tell the user where the folder is, summarize the key changes, and explicitly point them at the "Review before you submit" section of `CHANGES.md`. Confirm the PDF compiled. If you couldn't determine the company or had to make a notable judgment call, say so.
