---
description: 현재 레포지토리에서 새로운 git worktree를 생성한다
---

# Create Git Worktree

새 기능이나 실험적 작업을 위해 git worktree를 생성합니다.

## Steps

1. **Determine branch name**: Ask the user for the branch name if not provided as an argument. Branch name should be descriptive and use kebab-case (e.g., `feat/mr-export`, `fix/grid-overflow`).

2. **Determine worktree path**: Resolve the worktree path as a sibling directory of the current repo root. Convention: `../flutter_pilot_<branch-slug>` where `<branch-slug>` is the branch name with `/` replaced by `_`.
   - Example: branch `feat/mr-export` → path `../flutter_pilot_feat_mr-export`

3. **Check for existing worktree**: Run `git worktree list` to ensure the target path and branch do not already exist.

// turbo
4. **Create the worktree**:
   ```bash
   git worktree add <path> -b <branch-name>
   ```

5. **Verify creation**: Run `git worktree list` and confirm the new entry appears.

6. **Report to user**:
   - Worktree path
   - Branch name
   - Reminder: use `/merge-worktree` to squash-merge back when done
   - Reminder: use `git worktree remove <path>` to clean up after merging
