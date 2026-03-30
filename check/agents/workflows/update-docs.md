---
description: Sync project docs in the docs/ folder with the current codebase
---

# Update Docs Workflow

Synchronize all `docs/` files with the current state of the codebase.

## Steps

1. **Scan project structure**: Check the full directory tree and compare against the structure section in `docs/architecture.md`.

2. **Update architecture.md**: Verify directory structure, layer rules, and architecture patterns match the current code. Update any discrepancies.

3. **Update components.md**: Scan the common and presentation widgets to keep the UI component inventory updated.

4. **Update conventions.md**: Review naming patterns, import order, and code style currently used in the codebase. Sync with the doc.

5. **Update data_models.md**: Scan model classes in `lib/` and compare against the doc. Reflect any changed fields or new models.

6. **Update dependencies.md**: Read `pubspec.yaml` and compare the current dependency list with the doc. Sync.

// turbo
7. **Review known_issues.md**: Check if any issues have been resolved and update their status.

8. **Update presentation.md**: Ensure high-level presentation flows and layouts align with new screens or major UI refactoring.

9. **Clean up task.md**: Tidy completed tasks and refresh the backlog.
