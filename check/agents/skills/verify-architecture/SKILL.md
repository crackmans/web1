---
name: verify-architecture
description: architecture.md 레이어 규칙과 파일 배치 규칙 준수 여부를 정적으로 검증합니다. Evaluator가 검수 시 사용.
---

# verify-architecture

`docs/architecture.md`의 레이어 규칙과 `docs/conventions.md` 섹션 2의 파일 배치 규칙 준수 여부를 검증합니다.

## When to Run

- Evaluator가 Generator 산출물을 검수할 때
- verify-implementation 통합 검증 시 (자동 포함)
- 아키텍처 변경 후 전체 검사 필요 시

## Workflow

### Step 1: 레이어 규칙 로드
`docs/architecture.md`에서 레이어 구조 파싱:
- data: 리포지토리, Mock 데이터
- domain: 비즈니스 모델
- presentation: Pages, Widgets
- shared: Constants, Extensions, Utilities, Common widgets

### Step 2: 파일 배치 검증
변경된 파일이 올바른 디렉토리에 배치되었는지 확인(내장 도구 `list_dir` 혹은 Windows PowerShell `Get-ChildItem` 권장).
conventions.md 섹션 2 Placement Decision Rules 대조:
- 2+ 화면 사용: presentation/widgets/common/
- 단일 화면: presentation/widgets/[feature]/
- 순수 데이터 구조: domain/models/
- 데이터 조회/필터링: data/repositories/
- 스타일 토큰: shared/constants/
- PlutoGrid 래퍼/오버레이: shared/widgets/

### Step 3: 레이어 의존성 방향 검증
허용 방향 (단방향):
- presentation -> domain (독립)
- presentation -> shared
- presentation -> data (리포지토리 호출)
- data -> domain (모델 참조)
- shared -> (독립, 다른 레이어 import 금지)
- domain -> (독립, 다른 레이어 import 금지)

금지 방향:
- domain -> presentation
- domain -> data
- shared -> presentation
- shared -> data

### Step 4: 결과 보고
파일 배치 PASS/FAIL + 레이어 의존성 PASS/FAIL + 위반 상세

## Exceptions

1. `shared/widgets/` 하위 파일은 presentation import 허용 (Flutter 위젯 기반)
2. `main.dart`는 모든 레이어 import 허용 (앱 진입점)
3. 테스트 파일(`test/`)은 레이어 규칙 적용 제외
4. Flutter SDK/외부 패키지 import는 검사 대상 아님

## Related Files

| File | Purpose |
|------|---------|
| `docs/architecture.md` | 레이어 구조 정의 |
| `docs/conventions.md` | 섹션 2: Layer-Path Mapping |