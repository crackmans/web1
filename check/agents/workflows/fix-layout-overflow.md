---
description: 레이아웃 오버플로우 진단 및 해결 가이드
---
# 레이아웃 오버플로우 트러블슈팅

## 1. 원인 분석
Flutter에서 "OVERFLOWED BY X PIXELS" 경고는 주로 다음과 같은 원인으로 발생합니다:
- **고정 너비 타이트**: `SizedBox(width: 48)` 같은 고정 크기 내부에 내부 패딩, 텍스트, 아이콘이 꽉 차는 경우.
- **소수점(Subpixel) 렌더링**: 48.0 픽셀 공간에 48.2 픽셀짜리 위젯이 렌더링되면서 미세하게 오버플로우 발생.
- **가변 컨텐츠**: 동적으로 길이가 바뀌는 `Text` 등이 부모 영역을 벗어남.

## 2. 진단 및 해결 방법

### 🔍 1. 소수점 오버플로우 (0.x Pixels Overflow) 대응
주로 고정 크기 부모 내부에서 발생합니다.
- **해결책**: 부모 위젯의 고정 크기(`width` 또는 `height`)에 마진(여유 공간)을 넉넉히 줍니다. (예: `width: 48` -> `width: 56`)

### 🔍 2. 동적 텍스트/뷰 오버플로우 대응
- **해결책 1 (Flexible/Expanded)**: `Row`/`Column` 내부라면 자식 위젯을 `Expanded` 또는 `Flexible`로 감싸서 남은 가용 공간만 차지하도록 유도합니다.
- **해결책 2 (FittedBox)**: 텍스트가 줄어들어서라도 한 줄에 들어와야 한다면 `FittedBox(fit: BoxFit.scaleDown)`를 활용합니다.
```dart
FittedBox(
  fit: BoxFit.scaleDown,
  child: Text('Long Text Here...'),
)
```

## 3. 예외 조치 🚫
`SingleChildScrollView` 등으로 묶어서 억지로 오버플로우를 숨기는 것은 임시방편입니다. 근본적으로 고정 크기를 넓히거나 `Flexible` 구조로 설계하는 방향을 권장합니다.
