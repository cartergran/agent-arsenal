# ATS guidelines for LaTeX resumes

Applicant Tracking Systems parse a resume into structured text before any human sees it, then rank it against the job's keywords. The goal is a document the parser reads cleanly *and* scores highly. These rules are specific to keeping a LaTeX resume machine-readable while tailoring it.

## How ATS parsing actually works

- The ATS extracts the raw text layer of the PDF, splits it into sections by recognizable headings, and matches terms against the job's requirements. A text-based PDF compiled from LaTeX is parsed well — this is fine to submit. (Image-only/scanned PDFs are not; LaTeX output is never that.)
- Matching is largely **literal string matching**. "K8s" and "Kubernetes" are different tokens — include both forms if the JD uses one and the field commonly uses the other. Same for "CI/CD" vs "continuous integration."
- Ranking weights **exact matches of must-have skills**, recency, and frequency (within reason — stuffing is penalized by the human screen even when the ATS tolerates it).

## Keyword strategy

- **Mirror the JD's exact spelling and casing** for technologies: "PostgreSQL" not "Postgres" if the JD says PostgreSQL; "JavaScript" not "Javascript."
- **Spell out acronyms once, then use the acronym**: "Continuous Integration / Continuous Deployment (CI/CD)" the first time, "CI/CD" after. This captures both token forms.
- **Concentrate must-have skills in a dedicated Skills section** — the highest-signal, easiest-to-parse surface — and also weave them into experience bullets so they appear in context (parsers and humans both weight contextual use).
- **Match the role title.** If the user's last title was "Software Engineer II" and the target is "Backend Engineer," a summary line like "Backend engineer with N years…" creates a title match without falsifying the work history.

## Formatting rules that keep LaTeX parseable

These matter because some LaTeX constructs render beautifully but parse into garbled or out-of-order text:

- **Avoid multi-column layouts for body content.** Two-column resume templates frequently parse in the wrong reading order (the parser interleaves columns). A skills sidebar is the common offender. If the existing template is single-column, keep it that way. If it's two-column, don't introduce more columns — and prefer placing critical keywords in the main column.
- **Keep text out of headers/footers.** Many parsers ignore `\fancyhead`/`\fancyfoot` content. Don't put the name, contact info, or skills in a header or footer. Contact info belongs in the document body near the top.
- **Avoid tables for content the ATS must read.** `tabular` used purely for visual alignment of experience entries can scramble. Simple skills tables are usually okay, but if you're adding content, prefer lists or plain lines over new tables.
- **Use standard section headings**: "Experience" / "Work Experience," "Education," "Skills" / "Technical Skills," "Projects." Cute headings ("Where I've Made Dents") can prevent the parser from recognizing a section. If the template uses a nonstandard heading for a key section, consider normalizing it.
- **Avoid glyph/icon fonts for labels.** FontAwesome icons standing in for "email"/"phone"/"GitHub" labels parse as nothing or as garbage. Keep a text label alongside any icon, or use plain text.
- **No text inside images/`\includegraphics`.** Anything rasterized is invisible to the ATS.
- **Use a standard, embedded font.** LaTeX defaults are fine. Don't switch to an exotic font that may not embed a usable text layer.
- **Hyphenation and line breaks**: avoid manually hyphenating keywords across line breaks (a hard `\-` inside "Kuber-netes" can split the token). Let LaTeX handle spacing.

## What NOT to do

- Don't hide keywords as white-on-white text or tiny font to game the parser — modern ATS and recruiters detect this and it's an instant reject.
- Don't keyword-stuff a skills section with 60 technologies; relevance and credibility beat raw count, and the human screen punishes spray-and-pray.
- Don't change the document class or rebuild the template's styling. Edit content within the existing structure so the output still compiles and looks like the user's resume.

## Quick pre-submit checklist

- [ ] Every must-have JD technology the user can credibly claim appears in the Skills section, spelled as the JD spells it.
- [ ] Top JD keywords also appear in-context in experience bullets.
- [ ] Section headings are standard and recognizable.
- [ ] No critical info in headers/footers; single-column reading order is clean.
- [ ] Acronyms expanded once.
- [ ] Role title echoed in a summary line.
- [ ] Document still compiles with the original engine.
