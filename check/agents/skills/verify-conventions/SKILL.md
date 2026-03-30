---
name: verify-conventions
description: 코딩 라인(conventions.md)에 따른 멱등성 및 코드 품질 검사를 자동 수행합니다. 새 파일 추가나 수정 시 반드시 작업 마지막에 이 스킬을 실행하세요.
---

# verify-conventions

이 스킬은 `docs/conventions.md`에 정의된 멱등성 코딩 규칙이 준수되었는지 자동으로 검사합니다.

## 언제 사용하나요?
- 코딩 작업을 수행한 후 (새로운 화면, 위젯, 도메인 모델, 리포지토리 등을 생성하거나 수정했을 때)
- 사용자에게 결과물이나 PR/Walkthrough를 보고하기 **직전** 

## 실행 방법
```bash
dart run .agents/skills/verify-conventions/scripts/verify_conventions.dart
```

## 주요 검사 항목
1. **Naming & Paths**: `lib/` 하위 파일 이름이 전부 소문자 `snake_case`인지 점검
2. **Model Skeletons**: `domain/models/` 내 도메인 모델들이 필수 메서드(`copyWith`, `==`, `hashCode`, `toString`)를 올바르게 구현했는지 점검
3. **Repository Skeletons**: `data/repositories/` 내 파일들이 명시된 Singleton 패턴 뼈대를 따르는지 점검
4. **Imports**: 금지된 상대 경로(`../`) 임포트 사용 여부 점검

> [!IMPORTANT]
> 스크립트 실행 후 `[Error]`가 발생하면, 즉시 에러 메시지를 기반으로 코드를 수정하고 **성공할 때까지 재실행**하세요.
