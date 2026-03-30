---
name: analyze-impact
description: 변경 영향도를 분석하여 영향받는 파일/레이어/의존성을 자동 도출합니다. Planner가 설계서 작성 전에 사용.
---

# analyze-impact

사용자 요청에 대해 어떤 파일/레이어/컴포넌트가 영향을 받는지 자동 분석합니다.

## When to Run

- Planner가 설계서 작성을 시작하기 전
- 기존 기능 수정 요청의 영향 범위 파악 시
- 리팩토링 전 의존성 그래프 확인 시

## Workflow

### Step 1: 디렉토리 구조 파악
`docs/architecture.md`에서 레이어 구조(data/domain/presentation/shared) 파싱

### Step 2: 관련 파일 탐색
요청 키워드(모델명, 화면명 등)로 `lib/` 내 관련 파일 탐색:
`grep_search` 도구 또는 PowerShell `Select-String -Pattern "keyword" -Path "lib\*" -Recurse` 사용

### Step 3: import 의존성 추적
발견된 파일의 import 문을 파싱하여 상위 의존 파일 도출:
`grep_search` 도구 또는 PowerShell `Select-String -Pattern "import.*target_file" -Path "lib\*" -Recurse` 사용

### Step 4: 컴포넌트 영향 확인
`docs/components.md` 참조하여 재사용 위젯 영향 범위 확인

### Step 5: 결과 보고
- 직접 영향 파일 (레이어, 파일, 영향 유형)
- 간접 영향 파일 (import 의존 경로)
- 레이어별 요약 (data/domain/presentation/shared 각 N개)

## Exceptions

1. `test/` 파일은 영향 범위에서 제외
2. `docs/` 파일은 영향 범위에서 제외
3. 생성된 파일(`.g.dart`, `.freezed.dart`)은 제외

## Related Files

| File | Purpose |
|------|---------|
| `docs/architecture.md` | 레이어 구조 정의 |
| `docs/components.md` | 위젯 인벤토리 |
| `docs/conventions.md` | 파일 배치 규칙 (섹션 2) |