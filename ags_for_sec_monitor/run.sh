#!/usr/bin/env bash
# 세컨더리 터치 모니터 대시보드 실행 스크립트
# AGS 설치 필요: yay -S aylurs-gtk-shell-git

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 이미 실행 중인 인스턴스 종료
pkill -f "ags run.*${SCRIPT_DIR}/app.tsx" 2>/dev/null || true

# 모니터가 모두 초기화될 때까지 잠시 대기
sleep 2

# AGS 실행 (해당 디렉토리 기준)
cd "$SCRIPT_DIR"
exec ags run app.tsx
