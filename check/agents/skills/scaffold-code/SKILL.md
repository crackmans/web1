---
name: scaffold-code
description: conventions.md 템플릿 기반 보일러플레이트 코드를 자동 생성합니다. Generator가 새 파일 생성 시 사용.
---

# scaffold-code

`docs/conventions.md` 섹션 3의 코드 스켈레톤 템플릿에 따라 보일러플레이트를 자동 생성합니다.

## When to Run

- Generator가 새 파일(NEW)을 생성할 때
- 기존 패턴과 일치하는 정형 코드가 필요할 때

## Hybrid Approach

이 스킬은 **하이브리드** 방식을 사용합니다:

### Script Mode (정형 데이터)
DB 스키마와 1:1 매칭되는 단순 Model, JSON 직렬화 등:
`dart run .agents/skills/scaffold-code/scripts/scaffold.dart --type=model --name=ClassName --fields=id:String,name:String`

### LLM Mode (구조적 설계)
여러 파일에 걸친 수정, 프로젝트 고유 아키텍처 준수 필요 시:
`docs/conventions.md` 섹션 3 템플릿을 참조하여 LLM 기반 생성

## Supported Types

| Type | Template | conventions.md 섹션 |
|------|----------|-------------------|
| model | Domain Model | 3a |
| repository | Repository (Singleton) | 3b |
| page | StatefulWidget Page | 3c |
| widget | StatelessWidget | 3d |

## Workflow

### Step 1: 유형 판별
Planner 설계서의 파일별 변경 명세에서 파일 유형 판별

### Step 2: 모드 결정
- 단순 모델/리포지토리 -> Script Mode
- 복잡한 페이지/위젯 -> LLM Mode

### Step 3: 생성
- Script Mode: scaffold.dart 실행
- LLM Mode: conventions.md 템플릿 참조

### Step 4: 검증
- 파일명 snake_case
- 클래스명 PascalCase
- import 순서 (Dart SDK -> Flutter -> External -> Internal)

## Exceptions

1. 기존 파일 수정(MODIFY)에는 사용하지 않음 - 신규 파일(NEW)에만
2. 테스트 파일에는 적용하지 않음
3. shared/widgets/ 하위 파일은 LLM Mode 권장

## Related Files

| File | Purpose |
|------|---------|
| `docs/conventions.md` | 섹션 3: 코드 스켈레톤 템플릿 |
| `docs/architecture.md` | 레이어별 파일 배치 규칙 |