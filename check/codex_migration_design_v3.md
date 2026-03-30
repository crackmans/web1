# Codex Migration Design v3

## Purpose

This document is the implementation design that Codex should follow when converting the uploaded legacy multi-agent markdown bundle into a Codex-friendly repository guidance set.

**Primary goal**
- Use the uploaded ZIP as source material.
- Produce a Codex-friendly structure centered on a root `AGENTS.md` plus reusable `skills/*/SKILL.md` packages.
- Preserve useful intent from the legacy bundle without preserving its runtime contract as the active operating model.

This is **not** a simple rename of `rules/orchestrator.md`.
It is a guided migration from a legacy orchestrator/planner/generator/evaluator layout into a Codex-native layout.

---

## Source Package Summary

### Current source layout

- `rules/orchestrator.md`
- `rules/planner.md`
- `rules/generator.md`
- `rules/evaluator.md`
- `skills/*/SKILL.md`
- `skills/scaffold-code/scripts/scaffold.dart`
- `skills/verify-conventions/scripts/verify_conventions.dart`
- `workflows/*.md`

### Key issues in the current package

1. The package is built around a **legacy multi-agent runtime contract** rather than Codex-native repository guidance.
2. `rules/orchestrator.md` behaves like a global entry instruction, but it contains:
   - references to `.agents/...`
   - planner/generator/evaluator delegation contracts
   - user approval gates written for a different runtime
3. Several skills and scripts are strongly **Flutter/Dart specific**.
4. Some workflows duplicate skill behavior and should be absorbed.
5. The two existing scripts are useful, but their current Dart implementation reduces portability.
6. The previous design version used YAML presets; that introduces an unnecessary parser dependency for Python helper scripts. Use **JSON presets** instead unless Codex has a compelling repo-specific reason to do otherwise.

---

## Working Output Convention

Codex should unpack the uploaded ZIP into a working folder and apply the migration there.

Recommended working root:

```text
migrated_bundle/
```

All active migrated files should live under that working root. If Codex also preserves raw originals for comparison, keep them clearly separated from the active migrated result.

---

## Target End State

### Target structure

```text
migrated_bundle/
  AGENTS.md
  skills/
    analyze-impact/
      SKILL.md
    manage-skills/
      SKILL.md
    merge-worktree/
      SKILL.md
    scaffold-code/
      SKILL.md
      scripts/
        scaffold.py
        presets/
          flutter.json
          react-native.json
          uno.json
    verify-architecture/
      SKILL.md
    verify-build/
      SKILL.md
    verify-conventions/
      SKILL.md
      scripts/
        verify_conventions.py
        presets/
          flutter.json
          react-native.json
          uno.json
    verify-design-compliance/
      SKILL.md
    verify-implementation/
      SKILL.md
  legacy/
    rules/
      planner.md
      generator.md
      evaluator.md
      orchestrator.md
    workflows/
      ...
    scripts/
      scaffold.dart
      verify_conventions.dart
```

### Important migration intent

- The old package should be **modernized**, not blindly preserved.
- The old rule files should not stay as the main operating contract.
- `AGENTS.md` becomes the top-level Codex guidance file.
- `skills/*` remain reusable skill packages.
- Scripts remain alive, but are migrated from Dart to Python for portability.
- Flutter remains supported, but only as one preset, not as the hardcoded default worldview.
- Preserve the old Dart scripts under `legacy/` for traceability if preservation is easy and low-cost.

---

## High-Level Decisions

### 1. `rules/orchestrator.md` -> root `AGENTS.md`

**Decision:** Rewrite and promote.

What to keep:
- read relevant docs before changing code
- keep docs in sync with code
- follow architecture before implementation
- follow conventions before introducing new patterns
- user/session language guidance
- concise repository-wide working rules

What to remove or rewrite:
- `.agents/...` path references
- `Planner / Generator / Evaluator` hard dependency
- legacy runtime wording such as `notify_user`
- instructions that assume a specific external orchestrator runtime
- Flutter-only assumptions unless explicitly moved into presets or examples

### 2. `skills/*` remain as skills

**Decision:** Keep most skills, but rewrite them to be Codex-native.

Skills to keep:
- `analyze-impact`
- `manage-skills`
- `merge-worktree`
- `scaffold-code`
- `verify-architecture`
- `verify-build`
- `verify-conventions`
- `verify-design-compliance`
- `verify-implementation`

### 3. `workflows/*` should mostly be absorbed

**Decision:** Absorb duplicated workflows into skills or `AGENTS.md`.

Recommended handling:
- `workflows/verify-build.md` -> absorb into `skills/verify-build/SKILL.md`
- `workflows/worktree.md` -> absorb into `skills/merge-worktree/SKILL.md`
- `workflows/update-docs.md` -> absorb key rules into `AGENTS.md` unless it has strong reusable standalone value
- `workflows/fix-layout-overflow.md` -> keep only if it is still genuinely useful as a reusable, stack-specific troubleshooting playbook; otherwise archive it

### 4. `planner.md`, `generator.md`, `evaluator.md` are not first-class in v1 migration

**Decision:** Do not keep them as active top-level operating contracts in the first migration.

Handling:
- Extract useful guidance into `AGENTS.md` and relevant skills.
- Move originals into `legacy/`.
- Only reintroduce them later if the user explicitly wants Codex subagents mirroring the old multi-agent split.

---

## Explicit Decision About Existing `.dart` Scripts

Yes, the existing script files are part of the migration scope.
They are **not** being ignored.

### `skills/scaffold-code/scripts/scaffold.dart`

**Decision:** Replace with `scaffold.py`.

Reason:
- Current script is useful, but too tied to Dart/Flutter file layout.
- The current script hardcodes:
  - `lib/domain/models`
  - `lib/data/repositories`
  - `package:flutter_pilot/...`
  - support for `model|repository` only
- Python is better for cross-stack text/file automation in Codex environments.

Migration rule:
- Keep the skill.
- Replace the active script implementation with a Python version.
- Preserve the core purpose: generate boilerplate from conventions.
- Convert hardcoded rules into preset-driven behavior.
- Preserve the original Dart script under `legacy/scripts/` if possible.

### `skills/verify-conventions/scripts/verify_conventions.dart`

**Decision:** Replace with `verify_conventions.py`.

Reason:
- Current script is useful and should survive.
- Current logic is too tied to:
  - `lib/**/*.dart`
  - package import style `package:flutter_pilot/...`
  - Flutter/Dart-specific repository/model conventions
- The role itself is more general than the current implementation.

Migration rule:
- Keep the skill.
- Replace the active script implementation with a Python version.
- Split rules into reusable presets.
- Support Flutter, React Native, and Uno through per-stack presets.
- Preserve the original Dart script under `legacy/scripts/` if possible.

### Important note

Migrating scripts to Python does **not** mean Flutter / React Native / Uno projects stop being supported.
It only means the **automation helper scripts** become stack-agnostic.
The actual project build / lint / analyze commands should still use the native project tooling:
- Flutter -> `flutter ...`
- React Native -> `npm`, `yarn`, `pnpm`, Gradle, Metro, etc.
- Uno -> `dotnet ...`

---

## Preset-Based Script Strategy

### Why presets are required

The current scripts encode one architecture and one stack directly into the implementation.
That must be removed.

### Preset format

Use **JSON preset files** to avoid requiring extra Python dependencies.
Do not require PyYAML or another third-party parser just to run helper automation.

### Target approach

The new Python scripts should accept a preset argument, for example:

```bash
python skills/scaffold-code/scripts/scaffold.py --preset=flutter --type=model --name=User
python skills/scaffold-code/scripts/scaffold.py --preset=react-native --type=screen --name=SystemAccessLog
python skills/verify-conventions/scripts/verify_conventions.py --preset=uno
```

### Initial supported presets

- `flutter`
- `react-native`
- `uno`

### Preset responsibilities

Each preset should define values such as:
- source roots
- default output directories
- file extensions
- naming patterns
- import or namespace rules
- allowed directory conventions
- optional required implementation patterns
- supported scaffold entity types, if applicable

### Support honesty requirement

Do **not** fake cross-stack parity.
If `verify-conventions` supports all three presets but `scaffold-code` only fully supports one stack initially, document that honestly in `SKILL.md` and in the migration summary.

### Minimum acceptable support

#### `verify-conventions`
Minimum migration expectation:
- real preset/config support for `flutter`, `react-native`, and `uno`
- no hardcoded single-package worldview in the core script

#### `scaffold-code`
Minimum migration expectation:
- preserve current Flutter-equivalent core utility
- use presets/config instead of hardcoding
- document stack/type support honestly
- partial support for React Native or Uno is acceptable **only if** clearly marked as partial and not falsely advertised as feature-complete

---

## New Root `AGENTS.md` Draft

Codex should create a new root `AGENTS.md` using this structure.

```md
# AGENTS.md

## Scope
This file defines repository-wide instructions for Codex.
Apply these rules before using repository-local skills.

## Start-of-Work Rules
- Read relevant docs before editing code.
- Identify architecture, conventions, dependencies, and active tasks first.
- Prefer small, verifiable changes.
- Do not introduce architecture changes silently.

## Documentation Rules
- Keep architecture, dependency, model, and task docs in sync after verified implementation.
- Do not update docs prematurely during unverified exploratory work.
- If a rule changes, update the relevant docs before or together with the implementation.

## Architecture Rules
- Follow the repository's documented architecture.
- If architecture is unclear, infer carefully from existing code and document the assumption.
- If architecture must change, surface it explicitly and request approval when required by repository policy.

## Convention Rules
- Follow existing naming, file placement, and import conventions.
- Prefer automated verification through repository skills where available.
- Avoid introducing one-off patterns when an existing pattern already exists.

## Change Management Rules
- Prefer reusing existing files, components, and structures over adding parallel variants.
- Keep changes localized unless a broader refactor is explicitly requested.
- Preserve working behavior on unaffected platforms and flows.

## Language Rules
- Internal project documentation: English unless the repository explicitly requires otherwise.
- User-facing chat responses: follow the active user/session language preference. For this migration workflow, default to Korean unless explicitly overridden.

## Skill Usage Guidance
Use repository skills when they provide a more reliable workflow than ad hoc editing.
Typical skill categories include:
- impact analysis
- scaffolding
- architecture verification
- build verification
- convention verification
- implementation verification
- worktree merge support

## Legacy Note
This repository was migrated from a legacy orchestrator/planner/generator/evaluator layout.
Treat any files under `legacy/` as reference material, not as active top-level operating contracts.
```

### AGENTS draft intent

This draft should stay:
- short enough to be a true root contract
- broad enough to guide most work
- free of legacy runtime assumptions
- free of Flutter-only worldview unless the repository itself is truly Flutter-only

---

## Skill Rewrite Rules

### Common rewrite rules for all skills

1. Remove references to:
   - `.agents/...`
   - `orchestrator.md`
   - `planner.md`, `generator.md`, `evaluator.md` as active runtime dependencies
   - `notify_user`
   - any legacy runtime-specific control protocol

2. Rewrite each skill so it explains:
   - when to use it
   - required inputs
   - expected outputs
   - any scripts/assets it uses
   - stack assumptions, if any
   - whether support is full or partial when relevant

3. If a skill is stack-specific, mark it clearly.
4. If a skill can be generalized, prefer a preset or configuration model.

### Specific rewrite notes

#### `scaffold-code`
- Keep as a reusable generation skill.
- Update `SKILL.md` so the documented supported entity types match actual implementation.
- If only some entity types are implemented initially, state that clearly.
- Do not claim support for model/repository/page/widget unless the script truly supports them.

#### `verify-conventions`
- Keep as an automated verification skill.
- Move hardcoded rules into preset files or a config-driven rule layer.
- Do not assume only one package name or import style unless the preset says so.

#### `verify-build`
- Change from Flutter-only phrasing to preset or repository-command phrasing.
- The skill may define native build commands per stack.
- Do not pretend one command works for all stacks.

#### `verify-implementation`
- Keep as a meta verification skill.
- It can orchestrate multiple verify skills, but not via old Evaluator runtime language.
- Rewrite it as a repository skill that produces an integrated verification report.

#### `manage-skills`
- Keep the intent, but remove references to editing `orchestrator.md` specifically.
- It should refer to `AGENTS.md` and repository-local skills.
- Focus on drift detection, gap detection, and metadata consistency.

---

## Script Migration Rules

### Replace Dart scripts with Python scripts

#### `scaffold-code`
Replace active file:
- `skills/scaffold-code/scripts/scaffold.dart`

With active file:
- `skills/scaffold-code/scripts/scaffold.py`
- `skills/scaffold-code/scripts/presets/*.json`

#### `verify-conventions`
Replace active file:
- `skills/verify-conventions/scripts/verify_conventions.dart`

With active file:
- `skills/verify-conventions/scripts/verify_conventions.py`
- `skills/verify-conventions/scripts/presets/*.json`

### Portability rules

The Python versions should:
- run from repository root
- accept arguments cleanly
- print clear success/error messages
- exit non-zero on failure
- avoid stack-specific hardcoding in core logic
- use the Python standard library where practical

### Non-dependency preference

Prefer standard-library Python for these helper scripts.
Avoid adding third-party dependencies unless there is a strong implementation reason and the migration summary explains it.

---

## Legacy Preservation Rules

If preserving the old material is useful, move it under a `legacy/` folder.
Do not leave old rule files as active top-level instructions once `AGENTS.md` exists.

Suggested handling:
- `rules/orchestrator.md` -> `legacy/rules/orchestrator.md`
- `rules/planner.md` -> `legacy/rules/planner.md`
- `rules/generator.md` -> `legacy/rules/generator.md`
- `rules/evaluator.md` -> `legacy/rules/evaluator.md`
- original Dart scripts -> `legacy/scripts/`
- `workflows/*` -> either absorb or move to `legacy/workflows/`

---

## Codex Execution Instructions

When applying this migration, Codex should:

1. Inspect the uploaded source bundle.
2. Create a working folder for the migrated output.
3. Create a root `AGENTS.md` using the draft and intent in this design.
4. Rewrite each `skills/*/SKILL.md` to remove legacy runtime assumptions.
5. Replace the two active Dart scripts with Python equivalents.
6. Introduce preset-based configuration for stack-sensitive behavior using JSON presets.
7. Absorb or archive redundant workflows.
8. Move planner/generator/evaluator/orchestrator files out of the active top-level contract.
9. Preserve useful content, but prioritize a clean Codex-native result over literal translation.

### Migration priority order

1. root `AGENTS.md`
2. `verify-conventions`
3. `scaffold-code`
4. `verify-build`
5. `verify-implementation`
6. remaining skills
7. legacy archiving / workflow cleanup

---

## Non-Goals

Codex should **not**:
- blindly rename `orchestrator.md` to `AGENTS.md` and stop there
- keep legacy runtime control language unchanged
- keep Flutter-only hardcoding in supposedly reusable skills
- delete scripts without replacing their utility
- claim support for entity types or stacks that the migrated scripts do not actually support
- add a YAML parser dependency just to load preset files

---

## Success Criteria

The migration is successful if:

1. There is a clean root `AGENTS.md`.
2. Skills are readable and useful without the old runtime.
3. The two former Dart helper scripts have active Python replacements.
4. Flutter remains supported.
5. `verify-conventions` has real preset/config support for Flutter, React Native, and Uno.
6. `scaffold-code` preserves useful generation behavior and documents any partial stack/type support honestly.
7. Redundant workflows are reduced.
8. Legacy files no longer act as the active main contract.
9. Internal references are updated consistently.
