---
name: verify-build
description: Flutter static analysis (flutter analyze)를 실행하여 컴파일 에러와 lint 경고를 검출합니다. 코드 수정 후, PR 전, verify-implementation의 일환으로 사용.
---

# verify-build

이 스킬은 `flutter analyze`를 실행하여 정적 분석 결과를 검증합니다.

## When to Run

- 코드 파일을 추가/수정/삭제한 후
- `verify-implementation` 통합 검증 실행 시 (자동 포함)
- PR/커밋 전 최종 확인 시
- 빌드 에러가 의심될 때

## Workflow

### Step 1: 정적 분석 실행

```bash
flutter analyze
```

결과를 전체 캡처합니다.

**PASS 기준:** 출력 마지막 줄이 `No issues found!` 또는 `flutter analyze` 결과에 `error`가 0개인 경우.

**FAIL 기준:** `error:` 를 포함한 라인이 1개 이상 존재하는 경우.

### Step 2: 결과 파싱 및 분류

분석 결과를 다음 세 등급으로 분류합니다:

| 등급 | 키워드 | 처리 |
|------|--------|------|
| Error | `error •` | FAIL — 즉시 수정 필요 |
| Warning | `warning •` | 경고 — 수정 권장, 블로킹 안 함 |
| Info/Hint | `info •`, `hint •` | 참고 — 필요 시 수정 |

### Step 3: 결과 보고

```markdown
### verify-build 결과

| 등급 | 건수 |
|------|------|
| Error   | N |
| Warning | N |
| Info    | N |

**상태: PASS / FAIL**
```

**FAIL 시** 각 에러에 대해:
- 파일 경로 및 라인 번호
- 에러 메시지
- 수정 권장 사항 (가능한 경우 코드 예시 포함)

### Step 4: 에러 수정 및 재검증

FAIL인 경우:
1. 각 에러를 순서대로 수정
2. 수정 완료 후 `flutter analyze` 재실행
3. PASS가 될 때까지 반복

> [!IMPORTANT]
> `// ignore:` 주석으로 에러를 억제하는 것은 **금지**입니다 (`docs/conventions.md` Rule 8 참조).
> 반드시 근본 원인을 해결하세요.

## Exceptions

다음은 **FAIL이 아닙니다**:

1. **Warning/Info 단독** — `warning •`, `info •`, `hint •` 만 존재하고 `error •`가 없으면 PASS
2. **생성된 파일의 경고** — `.g.dart`, `.freezed.dart` 등 코드 제너레이터 산출물의 경고는 면제
3. **분석 자체 오류** — `flutter analyze` 명령 실행 실패 (SDK 환경 문제)는 스킬 실패로 처리하지 않고 사용자에게 환경 확인 요청

## Related Files

| File | Purpose |
|------|---------|
| `analysis_options.yaml` | Lint 규칙 설정 |
| `docs/conventions.md` | Rule 8: Package & Lint Guard |
| `pubspec.yaml` | 의존성 및 SDK 버전 |
