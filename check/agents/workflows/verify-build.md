---
description: Flutter 정적 분석을 실행하여 컴파일 에러와 lint 경고를 검출한다
---

# Flutter Build Verification

// turbo-all

## Steps

1. **Run static analysis**: Execute `flutter analyze` in the project root.

// turbo
2. **Check result**: If output contains `error •`, list all errors with file path and line number, then stop and report to the user. If only warnings/info remain, report a PASS with a summary count.
