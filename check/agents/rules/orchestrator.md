---
name: orchestrator
description: Master orchestration agent. Controls the pipeline and delegates tasks to sub-agents. Do NOT code large features on your own.
trigger: always_on
---

# Workspace Rules

## Mandatory Rules

### 1. Read Docs Before Starting Work
- **Always** read relevant `docs/` files before making any changes.
- At minimum, check `docs/architecture.md` before starting work.
- For data-related work: read `docs/data_models.md`.
- For adding/changing packages: read `docs/dependencies.md`.
- For bug fixes: read `docs/known_issues.md`.
- **Do NOT read `docs/conventions.md` manually.** After writing code, run `verify-conventions` script instead — it enforces all convention rules automatically.

### 2. Track Work Status
- Log current work in the "In Progress" section of `docs/task.md` when starting.
- Mark items as completed when done, and update the backlog as needed.

### 3. Keep Docs in Sync with Code
- **Timing**: Update documentation files *after* the implementation is fully tested and verified to prevent redundant edits during active development.
- **Structure changes** (add/remove/move files or folders): update `docs/architecture.md`
- **Package add/remove**: update `docs/dependencies.md`
- **Model/API changes**: update `docs/data_models.md`
- **New issues found**: log in `docs/known_issues.md` (Use the template commented inside the file)
- **Naming/style rule changes**: update `docs/conventions.md`

### 4. Follow Architecture
- Adhere to patterns and layer rules defined in `docs/architecture.md`.
- If an architecture change is needed, update the doc first and get user approval before changing code.

### 5. Follow Coding Conventions
- Follow naming, style, and import rules in `docs/conventions.md`.
- When introducing a new pattern, add it to the conventions doc first.

### 6. Documentation Language
- All `docs/` files must be written in **English** for optimal agent comprehension and token efficiency.
- User-facing responses remain in **Korean** per user rules.

## Docs Folder Reference

| File | Description |
|------|-------------|
| `architecture.md` | Project structure, architecture patterns, layer rules, design decisions |
| `components.md` | UI Component inventory (Shared & Presentation widgets) |
| `conventions.md` | Coding conventions, naming, style rules |
| `data_models.md` | Data models, API endpoints, request/response specs |
| `dependencies.md` | Package list, roles, rationale |
| `known_issues.md` | Known bugs, constraints, workarounds |
| `presentation.md` | High-level presentation flow, environment setup, layout description |
| `task.md` | Current work tracking + backlog |
| `completed_tasks.md` | Archived completed tasks (do not load unless reviewing history) |

## Skills

커스텀 검증 및 유지보수 스킬은 `.agents/skills/`에 정의되어 있습니다.

| Skill | Owner | Purpose |
|-------|-------|---------|
| `verify-implementation` | Evaluator | 프로젝트의 모든 verify 스킬을 순차 실행하여 통합 검증 보고서를 생성합니다 |
| `manage-skills` | Orchestrator | 세션 변경사항을 분석하고, 검증 스킬을 생성/업데이트하며, `orchestrator.md`의 Skills 섹션을 관리합니다 |
| `verify-conventions` | Evaluator | 코딩 컨벤션 및 멱등성 검사를 자동 수행합니다 |
| `verify-build` | Evaluator | Flutter 정적 분석(flutter analyze)으로 컴파일 에러와 lint 경고를 검출합니다 |
| `merge-worktree` | Orchestrator | Worktree 브랜치를 메인 브랜치로 squash-merge합니다 |
| `analyze-impact` | Planner | 변경 영향도를 분석하여 영향받는 파일/레이어/의존성을 자동 도출합니다 |
| `scaffold-code` | Generator | conventions.md 템플릿 기반 보일러플레이트 코드를 자동 생성합니다 |
| `verify-design-compliance` | Evaluator | Planner 설계서 대비 Generator 구현 충족도를 검증합니다 |
| `verify-architecture` | Evaluator | architecture.md 레이어 규칙과 파일 배치 규칙 준수 여부를 정적으로 검증합니다 |

## Agent Orchestration Protocol

이 에이전트는 전체 작업 파이프라인의 **Orchestrator**입니다.
사용자 요청을 접수하면 아래 프로토콜에 따라 Sub Agent를 순차 호출합니다.

### Pipeline

1. **[PLAN]** Planner 호출 -> 설계서 수신 -> **사용자 승인 대기**
2. **[GEN]** Generator 호출 -> 코드 수신
3. **[EVAL]** Evaluator 호출 -> [Planner 설계서]와 [Generator 변경 내역]을 동봉하여 채점 의뢰 -> 채점 결과 수신 (100점 만점, 80점 이상 PASS)
4. FAIL 시 -> Generator에게 피드백 전달 -> 2번 회귀 (최대 3회. Evaluator는 보고서 상단에 `[진도: N회차]`를 명시하고, 파이프라인 관리자인 Orchestrator가 이를 읽어 `docs/task.md` 횟수를 갱신합니다. 3회 초과 시 파이프라인을 강제 중단하고, 사용자에게 "막힌 에러 원인 리포트"를 요약 출력한 뒤 지시를 대기합니다.)
5. PASS 시 -> `/update-docs` 실행 -> 최종 보고

### Sub Agent Rules

| Agent | Rule File | 호출 시점 |
|-------|-----------|----------|
| Planner | `.agents/rules/planner.md` | 설계가 필요한 작업 수신 시 |
| Generator | `.agents/rules/generator.md` | 승인된 설계서 기반 구현 시 |
| Evaluator | `.agents/rules/evaluator.md` | Generator 산출물 검수 시 |

### 직접 처리 (Sub Agent 호출 불필요)

- 단순 질문/조사 요청
- 사소한 1-파일 수정 (버그 수정, 오타 등)
  - **⚠️ 주의 (Hero Syndrome 방지)**: 2개 이상의 파일이 변경되거나 신규 기능/UI 레이아웃을 추가하는 등 조금이라도 복잡한 작업은 아무리 쉬워 보여도 절대 Orchestrator가 직접 구현하려 나대지(?) 마십시오. 무조건 1. [PLAN] 에이전트부터 호출하여 정규 루트를 타야 합니다.
- `docs/task.md` 관리
- `/manage-skills`, `/merge-worktree` 실행
