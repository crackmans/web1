---
name: verify-design-compliance
description: Planner 설계서 대비 Generator 구현 충족도를 검증합니다. Evaluator가 검수 시 사용.
---

# verify-design-compliance

Planner 설계서에 명시된 항목이 Generator 산출물에 모두 구현되었는지 대조 검증합니다.

## When to Run

- Evaluator가 Generator 산출물을 검수할 때
- verify-implementation 통합 검증 시 (자동 포함)

## Workflow

### Step 1: 설계서 파싱
Planner 설계서의 다음 섹션을 파싱:
- 파일별 변경 명세 (NEW/MODIFY/DELETE 항목)
- 검수 기대 기준 (verify-design-compliance 체크리스트)

### Step 2: 항목별 검증

**NEW 파일**: 파일 존재 확인(내장 도구 `list_dir` 혹은 PowerShell `Get-ChildItem`), 명시된 클래스/메서드 존재 확인(내장 도구 `grep_search` 또는 `view_file`)
**MODIFY 파일**: 명시된 변경 사항 반영 확인
**DELETE 파일**: 삭제 확인, 잔여 import 확인(내장 도구 `grep_search`를 통해 의존성 검사)

### Step 3: 체크리스트 순회
설계서 검수 기대 기준의 verify-design-compliance 항목을 하나씩 확인

### Step 4: 결과 보고
항목별 PASS/FAIL 테이블 + 통과율 + 감점 계산

**PASS 기준**: 모든 항목 구현 확인

## Exceptions

1. 설계서에 선택사항으로 표기된 항목은 미구현 시 감점 없음
2. Generator가 설계서 보완을 요청한 항목은 평가 제외
3. 설계서 자체 오류는 Evaluator가 Orchestrator에게 보고

## Related Files

| File | Purpose |
|------|---------|
| (Planner 설계서) | 검증 기준 원본 |
| `docs/conventions.md` | 스켈레톤 필수 메서드 참조 |