# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal collection of Claude Code skills — reusable, invocable prompt modules that extend Claude Code's capabilities.

## Repository structure

```
skills/<skill-name>/      # skill source — SKILL.md and any supporting files
evals/<skill-name>/       # eval cases for the skill, kept separate from source
.claude/skills/<skill-name> -> ../../skills/<skill-name>   # symlink for Claude Code discovery
```

## Skill structure

Each skill lives in `skills/<skill-name>/` and requires a `SKILL.md`:

```yaml
---
name: <skill-name>
description: <one-line trigger description used by the model to decide when to invoke this skill>
---
```

The body is the full prompt the skill injects when invoked.

## Evals structure

Evals live in `evals/<skill-name>/evals.json`, separate from the skill source so they are not exposed via the `.claude/skills/` symlink. Schema:

```json
{
  "skill_name": "<name>",
  "evals": [
    {
      "id": 1,
      "prompt": "<user input>",
      "expected_output": "<what a good response looks like>",
      "files": [],
      "assertions": [
        { "id": "A1", "name": "<assertion-slug>", "description": "<what to check>" }
      ]
    }
  ]
}
```

## Making skills invocable

Claude Code auto-discovers skills under `.claude/skills/`. Each skill directory there is a symlink to its source in `skills/`. This keeps `skills/` as the single source of truth while satisfying Claude Code's discovery path. Because `evals/` is a separate top-level directory, it is never exposed through the symlink.

To wire up a new skill:

```bash
ln -s ../../skills/<skill-name> .claude/skills/<skill-name>
```

Once the symlink is in place, `/skill-name` is invocable immediately — no changes to `settings.json` needed.

## Running evals

Use the `skill-creator` skill (already enabled in `.claude/settings.json`) to run evals against a skill:

```
/skill-creator run evals for evals/prd-writer
```

The skill-creator plugin handles eval execution, scoring assertions, and reporting results.

## Installed plugins

`.claude/settings.json` enables:
- `skill-creator@claude-plugins-official` — create, modify, and eval skills

## The description field is load-bearing

The `description` in a skill's frontmatter is what the model reads to decide whether to invoke the skill. Write it to capture all the surface forms a user might use, including paraphrases, synonyms, and indirect phrasings. Vague descriptions cause missed triggers.
