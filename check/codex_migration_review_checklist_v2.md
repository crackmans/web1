# Codex Migration Review Checklist v2

Use this checklist **after Codex Web finishes the migration**.
Its purpose is to verify that the result follows the intent of:
- `agents.zip`
- `codex_migration_design_v3.md`
- `codex_web_execution_prompt_v2.md`

This checklist is for human review.
It is **not** the implementation contract itself.

---

## Review Goal

The migration is successful only if the output is:
- Codex-friendly
- internally consistent
- no longer dependent on the legacy orchestrator runtime
- still useful for Flutter
- expanded realistically for React Native and Uno through presets/configuration
- honest about any partial support

---

## Pass / Fail Summary

Mark each item as:
- `PASS`
- `PARTIAL`
- `FAIL`
- `N/A`

A good result should have:
- no critical `FAIL` in sections 1 through 6
- at most minor `PARTIAL` items in sections 7 through 9

Critical failures include:
- no migrated root `AGENTS.md`
- `rules/orchestrator.md` still acting as the main contract
- active Dart scripts left in place without Python replacements
- obvious broken internal references after rename/move
- hardcoded Flutter worldview still left in core reusable scripts
- fake React Native or Uno support claimed without real preset/config logic
- YAML preset dependency added without a good reason

---

## 1. Root Contract Review

### 1.1 Root AGENTS existence
- [ ] `AGENTS.md` exists at the migrated output root.
- [ ] `AGENTS.md` is the active main contract.
- [ ] `rules/orchestrator.md` is not still functioning as the active top-level instruction file.

### 1.2 AGENTS scope quality
- [ ] `AGENTS.md` is repository-wide and concise.
- [ ] It focuses on global rules rather than dumping every workflow into one file.
- [ ] It explains the relationship between `AGENTS.md` and `skills/*/SKILL.md` clearly.

### 1.3 Legacy wording removal
- [ ] No active `.agents/...` path references remain in the new main contract unless intentionally archived.
- [ ] Legacy wording like `notify_user` is removed or rewritten.
- [ ] Hard dependency wording for `planner.md`, `generator.md`, `evaluator.md` is removed from the active contract.

### 1.4 Preserved intent
- [ ] Useful high-level behavior from `orchestrator.md` is preserved.
- [ ] The new `AGENTS.md` still instructs the agent to read relevant docs before code changes.
- [ ] The new `AGENTS.md` still emphasizes architecture/conventions/docs sync.

---

## 2. Skill Structure Review

### 2.1 Required skills still exist
- [ ] `skills/analyze-impact/SKILL.md`
- [ ] `skills/manage-skills/SKILL.md`
- [ ] `skills/merge-worktree/SKILL.md`
- [ ] `skills/scaffold-code/SKILL.md`
- [ ] `skills/verify-architecture/SKILL.md`
- [ ] `skills/verify-build/SKILL.md`
- [ ] `skills/verify-conventions/SKILL.md`
- [ ] `skills/verify-design-compliance/SKILL.md`
- [ ] `skills/verify-implementation/SKILL.md`

### 2.2 Skill document quality
For each skill, verify:
- [ ] It says when to use the skill.
- [ ] It says what inputs are needed.
- [ ] It says what outputs/deliverables are expected.
- [ ] It does not promise capabilities that do not exist.
- [ ] It no longer depends on the legacy orchestrator runtime wording.
- [ ] It states partial support honestly where relevant.

### 2.3 Internal consistency
- [ ] File paths mentioned in `SKILL.md` files match real files.
- [ ] Script names in `SKILL.md` match the actual script filenames.
- [ ] Any preset/config paths mentioned in `SKILL.md` match real files.

---

## 3. Script Migration Review

### 3.1 Active Dart scripts removed from active path
- [ ] `skills/scaffold-code/scripts/scaffold.dart` is no longer the active implementation.
- [ ] `skills/verify-conventions/scripts/verify_conventions.dart` is no longer the active implementation.
- [ ] If old Dart files are preserved, they live under `legacy/` or another clearly archived location.

### 3.2 Python replacements exist
- [ ] `skills/scaffold-code/scripts/scaffold.py` exists.
- [ ] `skills/verify-conventions/scripts/verify_conventions.py` exists.

### 3.3 Python replacement quality
- [ ] The new Python scripts keep the core purpose of the original Dart scripts.
- [ ] Functionality is not silently deleted.
- [ ] Argument handling or configuration is documented.
- [ ] The scripts are not locked to a single Flutter package name or one hardcoded repo path.
- [ ] The scripts use standard-library parsing unless a non-stdlib dependency is clearly justified.

### 3.4 Core portability
- [ ] Core script logic does not assume only `lib/**/*.dart`.
- [ ] Core script logic does not assume only `package:flutter_pilot/...` imports.
- [ ] Core script logic is configurable through presets/settings rather than embedded constants.

---

## 4. Preset Review

### 4.1 Preset files exist
- [ ] Flutter preset exists.
- [ ] React Native preset exists.
- [ ] Uno preset exists.

Suggested locations:
- `skills/scaffold-code/scripts/presets/*.json`
- `skills/verify-conventions/scripts/presets/*.json`

### 4.2 Preset usefulness
Each preset should define enough information to make the scripts reusable.
Check whether presets include items such as:
- [ ] source roots
- [ ] output directories
- [ ] file extensions
- [ ] naming rules
- [ ] import or namespace rules
- [ ] optional checks or supported generation types

### 4.3 Preset honesty
- [ ] Flutter support still exists.
- [ ] React Native support is not fake or placeholder-only unless explicitly documented as partial.
- [ ] Uno support is not fake or placeholder-only unless explicitly documented as partial.
- [ ] If any preset is partial, the related `SKILL.md` and migration summary say so clearly.

### 4.4 Preset format portability
- [ ] Presets use JSON, or another format is clearly justified.
- [ ] No unnecessary YAML parser dependency was introduced just for preset loading.

---

## 5. Workflow Handling Review

### 5.1 Expected absorptions happened
- [ ] `workflows/verify-build.md` has been absorbed into `skills/verify-build/SKILL.md`, or there is a clear reason why it remains separate.
- [ ] `workflows/worktree.md` has been absorbed into `skills/merge-worktree/SKILL.md`, or there is a clear reason why it remains separate.

### 5.2 Optional workflow decisions are sensible
- [ ] `workflows/update-docs.md` is either absorbed sensibly or preserved with clear distinct value.
- [ ] `workflows/fix-layout-overflow.md` is preserved only if it is still genuinely useful as a reusable troubleshooting guide.

### 5.3 No confusing duplication
- [ ] The same workflow is not duplicated across AGENTS, SKILL, and legacy files without explanation.
- [ ] Active guidance and archived legacy guidance are easy to distinguish.

---

## 6. Legacy Preservation Review

### 6.1 Legacy files are archived, not active
- [ ] If `planner.md`, `generator.md`, `evaluator.md`, or `orchestrator.md` are preserved, they are under `legacy/` or another clearly archived location.
- [ ] Archived files are not referenced as active dependencies from `AGENTS.md`.
- [ ] Original Dart helper scripts are archived if preservation was promised.

### 6.2 Original intent remains traceable
- [ ] The migration summary explains what was preserved from the legacy files.
- [ ] The result is not a destructive rewrite with no trace of the original intent.

---

## 7. Stack Support Review

### 7.1 Flutter support
- [ ] Flutter remains supported in presets and/or guidance.
- [ ] Flutter support is no longer the hardcoded worldview of every reusable tool.

### 7.2 React Native support
- [ ] React Native is represented in presets/configuration.
- [ ] Support is realistic and not just a file name with no mapped directories/rules.
- [ ] If scaffold support is partial, that is clearly documented.

### 7.3 Uno support
- [ ] Uno is represented in presets/configuration.
- [ ] Support is realistic and not just a file name with no mapped directories/rules.
- [ ] If scaffold support is partial, that is clearly documented.

### 7.4 Native tool usage preserved
- [ ] Build/analyze/test guidance still uses the native stack tools where appropriate.
- [ ] Python is used only for helper automation, not as a fake replacement for Flutter / Node / dotnet tooling.

---

## 8. Reference and Path Integrity Review

### 8.1 File references
- [ ] No broken file references remain after rename/move operations.
- [ ] No `SKILL.md` refers to files that do not exist.
- [ ] No active file still points to obsolete Dart script names if Python replacements now exist.

### 8.2 Folder integrity
- [ ] The final tree is understandable.
- [ ] Active files and archived files are clearly separated.
- [ ] Presets live in the locations described by the documentation.

---

## 9. Migration Summary Review

### 9.1 Summary completeness
- [ ] Codex provided a final file tree.
- [ ] Codex explained what changed and why.
- [ ] Codex identified which legacy parts were absorbed, archived, or rewritten.
- [ ] Codex disclosed intentionally partial support.

### 9.2 Honesty
- [ ] Partial implementations are disclosed honestly.
- [ ] Missing capabilities are not hidden.
- [ ] Any tradeoffs are explained.

---

## Suggested Quick Inspection Order

Use this order when reviewing the result:

1. Open migrated root `AGENTS.md`
2. Check whether `rules/orchestrator.md` still acts as the main contract
3. Open `skills/scaffold-code/SKILL.md`
4. Open `skills/scaffold-code/scripts/scaffold.py`
5. Open `skills/verify-conventions/SKILL.md`
6. Open `skills/verify-conventions/scripts/verify_conventions.py`
7. Check preset files for `flutter`, `react-native`, `uno`
8. Review absorbed workflow handling
9. Review archived `legacy/` contents
10. Read the migration summary

---

## Fast Failure Signals

If any of these happen, treat the migration as failed until corrected:

- There is no migrated root `AGENTS.md`.
- `rules/orchestrator.md` is still the main operating contract.
- The `.dart` scripts are still the active script implementations.
- Python replacements do not exist.
- `verify-conventions` lacks real preset support for React Native and Uno.
- Internal references still point to moved/deleted files.
- The result still assumes Flutter everywhere in core reusable logic.
- YAML was introduced for presets without a clear reason.

---

## Reviewer Notes

Use this space to record findings.
