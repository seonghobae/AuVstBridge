#!/bin/bash

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}AU-VST-Bridge 제거를 시작합니다...${NC}\n"

# 시스템 및 사용자 플러그인 디렉토리 정의
SYSTEM_PLUGINS_DIR="/Library/Audio/Plug-Ins/Components"
USER_PLUGINS_DIR="$HOME/Library/Audio/Plug-Ins/Components"

# 제거할 위치 선택
echo -e "${YELLOW}제거할 위치를 선택하세요:${NC}"
echo "1) 시스템 전체 (관리자 권한 필요) - $SYSTEM_PLUGINS_DIR"
echo "2) 현재 사용자만 - $USER_PLUGINS_DIR"
read -p "선택 (1 또는 2): " CHOICE

# 선택한 디렉토리 설정
if [ "$CHOICE" = "1" ]; then
    TARGET_DIR="$SYSTEM_PLUGINS_DIR"
    # 관리자 권한 확인
    if [ "$(id -u)" != "0" ]; then
        echo -e "${RED}시스템 전체 제거를 위해서는 관리자 권한이 필요합니다.${NC}"
        echo "sudo를 사용하여 다시 실행해주세요."
        exit 1
    fi
else
    TARGET_DIR="$USER_PLUGINS_DIR"
fi

# 플러그인이 존재하는지 확인
if [ ! -d "$TARGET_DIR/AU-VST-Bridge.component" ]; then
    echo -e "${RED}선택한 위치에서 AU-VST-Bridge를 찾을 수 없습니다.${NC}"
    exit 1
fi

# 플러그인 제거
echo "AU-VST-Bridge를 제거하는 중..."
rm -rf "$TARGET_DIR/AU-VST-Bridge.component"

# 제거 확인
if [ ! -d "$TARGET_DIR/AU-VST-Bridge.component" ]; then
    echo -e "${GREEN}AU-VST-Bridge가 성공적으로 제거되었습니다!${NC}"
else
    echo -e "${RED}제거 중 오류가 발생했습니다.${NC}"
    exit 1
fi

echo -e "\n${YELLOW}주의: 변경사항을 적용하려면 컴퓨터를 재시작하는 것을 권장합니다.${NC}" 