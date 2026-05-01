---
description: Entity dictionary — acronyms, organizations, projects, and people referenced across notes and skills
type: moc
domain: knowledge
topics: [glossary, entities, acronyms]
---

# Glossary

> Single source of truth for named entities. Skills consult this to disambiguate references and route content.

## Acronyms

| Acronym | Expansion | Notes |
|---------|-----------|-------|
| TBD | To Be Determined | Placeholder example |

## Organizations

| Short | Full name | Domain | Notes |
|-------|-----------|--------|-------|
| Example Inc | Example Incorporated | example.com | Replace with real entries |

## Projects

| ID | Name | Status | Path |
|----|------|--------|------|
| project-x | Project X | active | `~/code/project-x` |

## People

(Move to `people.md` if the list grows beyond ~20 entries.)

| Name | Role | Affiliation | Notes |
|------|------|-------------|-------|

## Naming conventions

- Acronyms: ALL CAPS, alphabetical within section
- Orgs: prefer recognizable short form, link to full name
- Projects: kebab-case ID, match repo folder name
- One row = one entity, no aliases — use frontmatter `aliases: []` for that

## How skills use this

- `design-system` reads project IDs to scope token variants
- `design-review` cross-references project IDs with improvement roadmaps
- Custom skills can grep this file for entity disambiguation
