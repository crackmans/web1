# Codex Web 최종 한글 지시문

아래 업로드한 파일들을 함께 참고해서 작업해줘.

업로드 파일:
1. `agents.zip` — 원본 legacy 에이전트 번들
2. `codex_migration_design_v3.md` — 목표 구조와 마이그레이션 설계
3. `codex_migration_review_checklist_v2.md` — 작업 완료 후 자체 점검 기준

## 작업 목표

이 작업의 목적은 legacy 에이전트 번들을 Codex 친화적인 구조로 재편하는 것이다.

핵심 목표:
- `rules/orchestrator.md`를 단순 rename 하지 말고, Codex용 루트 `AGENTS.md`로 재설계할 것
- 기존 `skills/*`는 최대한 유지하되, Codex 기준에 맞게 구조와 문구를 정리할 것
- `skills/scaffold-code/scripts/scaffold.dart`
- `skills/verify-conventions/scripts/verify_conventions.dart`
  이 두 Dart 스크립트는 유지하지 말고, 범용화된 Python 스크립트로 교체할 것
- 교체 후에도 Flutter만이 아니라 React Native, Uno까지 고려할 수 있는 preset 기반 구조로 만들 것
- 다만 지원 수준을 과장하지 말고, 실제 구현 범위만 문서에 정직하게 적을 것
- 기존 `planner.md`, `generator.md`, `evaluator.md`는 1차 전환에서 active 메인 계약으로 유지하지 말고, 필요한 핵심 규칙만 흡수할 것
- legacy 파일은 삭제하지 말고 `legacy/` 또는 이에 준하는 명확한 보존 위치로 이동할 것

## 꼭 지켜야 할 원칙

1. 단순 파일명 변경으로 끝내지 말 것
2. 겉모양만 Codex 구조처럼 보이게 하지 말 것
3. 기존 Dart 스크립트를 그대로 둔 채 문서만 바꾸지 말 것
4. React Native / Uno 지원을 선언만 하지 말고, preset 또는 설정 구조로 실제 반영할 것
5. 구현하지 못한 부분은 문서에 지원 범위를 정직하게 명시할 것
6. 기존 문서 안의 `orchestrator.md` 참조, legacy runtime 표현, 기존 에이전트 시스템 전용 문구를 찾아 수정할 것
7. 결과물은 active 구조와 legacy 보존 구조가 명확히 분리되어야 함

## 기대 결과 구조

최종 결과는 대략 아래 방향을 따라야 한다.

- `AGENTS.md`  
  - 루트 메인 지침 문서
  - legacy `orchestrator.md`의 핵심 규칙을 Codex용으로 재작성한 문서

- `skills/.../SKILL.md`
  - 기존 skill들을 유지하되 Codex 기준에 맞게 문구와 호출 조건을 정리
  - optional scripts 구조를 활용 가능하게 유지

- `skills/scaffold-code/scripts/scaffold.py`
  - 기존 `scaffold.dart` 대체
  - preset 또는 config 기반 템플릿 생성 구조

- `skills/verify-conventions/scripts/verify_conventions.py`
  - 기존 `verify_conventions.dart` 대체
  - preset 또는 config 기반 규칙 검사 구조

- `presets/` 또는 이와 유사한 구조
  - 최소한 `flutter`, `react-native`, `uno` 관련 preset/config 샘플 포함

- `legacy/`
  - 기존 `rules/orchestrator.md`
  - 기존 `rules/planner.md`
  - 기존 `rules/generator.md`
  - 기존 `rules/evaluator.md`
  - 기존 Dart scripts
  - 그 외 더 이상 active 구조가 아닌 legacy 문서들

## 세부 작업 지시

1. 먼저 zip 내부 구조를 분석해서 현재 문서 간 참조 관계를 파악해라.
2. `orchestrator.md`를 기반으로 Codex용 `AGENTS.md`를 새로 작성해라.
3. `skills/*`는 유지하되, 설명과 사용 조건이 Codex skill 규칙에 맞게 정리해라.
4. `workflows/*`는 필요한 경우 관련 skill로 흡수하고, 흡수되지 않은 것은 legacy 또는 reference로 정리해라.
5. `scaffold.dart`, `verify_conventions.dart`는 Python으로 교체해라.
6. Python 스크립트는 특정 Flutter 프로젝트 하드코딩이 아니라 preset/config 기반으로 만들어라.
7. preset은 YAML보다 JSON을 우선 고려해라. 불필요한 의존성 추가를 피하는 것이 목표다.
8. `flutter`, `react-native`, `uno` preset 또는 예시 config를 포함해라.
9. active 문서들 안에 남아 있는 legacy 용어와 경로 참조를 수정해라.
10. 최종적으로 어떤 파일을 active로 두고 어떤 파일을 legacy로 보존했는지 명확히 정리해라.

## 산출물 요구사항

작업이 끝나면 아래 내용을 함께 보여줘.

1. 최종 폴더 구조
2. 새로 만든 `AGENTS.md` 요약
3. 변경된 skill 목록
4. `.dart`에서 `.py`로 교체된 파일 목록
5. 추가된 preset/config 파일 목록
6. legacy로 이동한 파일 목록
7. 아직 부분 지원 또는 미구현인 항목 목록
8. `codex_migration_review_checklist_v2.md` 기준 자체 점검 결과

## 중요한 주의사항

- rename만 해놓고 내용이 legacy 상태로 남아 있으면 실패다.
- 문서만 바꾸고 스크립트는 안 바꾸면 실패다.
- React Native / Uno를 문서에만 적고 실제 preset/config가 없으면 실패다.
- 구현 범위를 넘어서 지원한다고 쓰면 안 된다.
- 원본을 훼손하지 말고 legacy로 보존해라.
