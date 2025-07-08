#!/bin/bash

# Citrix ICA 파일 MIME 타입 설정 스크립트
# 이 스크립트는 .ica 파일이 Firefox 대신 Citrix Workspace로 열리도록 설정합니다

set -e

echo "=== Citrix ICA 파일 MIME 타입 설정 시작 ==="

# 1. MIME 패키지 디렉토리 생성
echo "1. MIME 패키지 디렉토리 생성..."
mkdir -p ~/.local/share/mime/packages

# 2. citrix-ica.xml 파일 생성
echo "2. Citrix ICA MIME 타입 정의 파일 생성..."
cat > ~/.local/share/mime/packages/citrix-ica.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="application/x-ica">
    <comment>Citrix ICA File</comment>
    <glob pattern="*.ica"/>
    <magic priority="80">
      <match type="string" offset="0" value="[Encoding]"/>
    </magic>
    <magic priority="80">
      <match type="string" offset="0" value="[WFClient]"/>
    </magic>
  </mime-type>
</mime-info>
EOF

# 3. MIME 데이터베이스 업데이트
echo "3. MIME 데이터베이스 업데이트..."
update-mime-database ~/.local/share/mime

# 4. Citrix Workspace 애플리케이션 확인
echo "4. Citrix Workspace 애플리케이션 확인..."
if [ -f "/usr/share/applications/citrix-wfica.desktop" ]; then
    echo "   ✓ Citrix Workspace 발견: citrix-wfica.desktop"
    CITRIX_DESKTOP="citrix-wfica.desktop"
elif [ -f "/usr/share/applications/citrix-workspace.desktop" ]; then
    echo "   ✓ Citrix Workspace 발견: citrix-workspace.desktop"
    CITRIX_DESKTOP="citrix-workspace.desktop"
else
    echo "   ⚠️  Citrix Workspace 애플리케이션을 찾을 수 없습니다!"
    echo "   다음 중 하나를 설치해주세요:"
    echo "   - Citrix Workspace App"
    echo "   - Citrix Receiver"
    exit 1
fi

# 5. 기본 애플리케이션 연결 설정
echo "5. 기본 애플리케이션 연결 설정..."
xdg-mime default "$CITRIX_DESKTOP" application/x-ica
xdg-mime default "$CITRIX_DESKTOP" application/x-wine-extension-ini

# 6. 설정 확인
echo "6. 설정 확인..."
ICA_DEFAULT=$(xdg-mime query default application/x-ica)
WINE_INI_DEFAULT=$(xdg-mime query default application/x-wine-extension-ini)

echo "   application/x-ica -> $ICA_DEFAULT"
echo "   application/x-wine-extension-ini -> $WINE_INI_DEFAULT"

# 7. 완료 메시지
echo ""
echo "=== 설정 완료 ==="
echo "이제 .ica 파일이 Citrix Workspace로 열립니다."
echo ""
echo "테스트 방법:"
echo "  xdg-open your_file.ica"
echo "또는 파일 관리자에서 .ica 파일을 더블클릭하세요."
echo ""
echo "문제가 있는 경우 다음 명령어로 확인하세요:"
echo "  file --mime-type your_file.ica"
echo "  xdg-mime query default application/x-ica"
