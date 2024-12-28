#!/bin/bash

# 오류 발생 시 스크립트 중단
set -e

# 현재 디렉토리 저장
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 의존성 URL 정의
VST3SDK_URL="https://github.com/steinbergmedia/vst3sdk.git"
JUCE_URL="https://github.com/juce-framework/JUCE.git"

# 정보 출력 함수
info() {
    echo "[INFO] $1"
}

# 오류 출력 함수
error() {
    echo "[ERROR] $1"
    exit 1
}

# macOS 버전 확인
info "AU-VST-Bridge 설치를 시작합니다..."
info "macOS 버전을 확인합니다..."
if ! sw_vers -productVersion > /dev/null 2>&1; then
    error "macOS 버전을 확인할 수 없습니다."
fi

MACOS_VERSION=$(sw_vers -productVersion)
info "macOS 버전 ${MACOS_VERSION} 확인됨"

# Homebrew 설치 확인 및 설치
info "Homebrew 설정을 확인합니다..."
if ! command -v brew >/dev/null 2>&1; then
    info "Homebrew를 설치합니다..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Homebrew PATH 설정
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi
info "Homebrew 설정 완료"

# 필요한 의존성 설치
info "필요한 의존성을 설치합니다..."
brew install git cmake ninja pkg-config curl
info "의존성 설치 완료"

# Git 서브모듈 초기화
info "Git 서브모듈을 초기화합니다..."
cd "$SCRIPT_DIR"
if [ ! -d "Dependencies/vst3sdk" ]; then
    mkdir -p Dependencies
    git clone --recursive "$VST3SDK_URL" Dependencies/vst3sdk
else
    cd Dependencies/vst3sdk
    git pull
    git submodule update --init --recursive
    cd "$SCRIPT_DIR"
fi

if [ ! -d "Dependencies/JUCE" ]; then
    git clone --recursive "$JUCE_URL" Dependencies/JUCE
else
    cd Dependencies/JUCE
    git pull
    git submodule update --init --recursive
    cd "$SCRIPT_DIR"
fi
info "Git 서브모듈 초기화 완료"

# 빌드 캐시 정리
info "빌드 캐시를 정리합니다..."
rm -rf build
rm -rf "$HOME/Library/Caches/au-vst-bridge"
rm -rf "$HOME/Library/Developer/Xcode/DerivedData/AU-VST-Bridge-*"
info "캐시 정리 완료"

# JUCE 프로젝트 빌드
info "JUCE 프로젝트를 빌드합니다..."
info "CMake 설정을 구성합니다..."
mkdir -p build
cd build
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64"

info "프로젝트를 빌드합니다..."
ninja

# 플러그인 디렉토리 생성
info "플러그인 디렉토리를 준비합니다..."
COMPONENTS_DIR="$HOME/Library/Audio/Plug-Ins/Components"
VST3_DIR="$HOME/Library/Audio/Plug-Ins/VST3"

mkdir -p "$COMPONENTS_DIR"
mkdir -p "$VST3_DIR"

# 기존 플러그인 제거
rm -rf "$COMPONENTS_DIR/AU-VST-Bridge.component"
rm -rf "$VST3_DIR/AU-VST-Bridge.vst3"

# 플러그인 설치
info "플러그인을 설치합니다..."
if [ -d "AU-VST-Bridge_artefacts/Release/AU/AU-VST-Bridge.component" ]; then
    cp -r "AU-VST-Bridge_artefacts/Release/AU/AU-VST-Bridge.component" "$COMPONENTS_DIR/"
    info "AU 플러그인이 설치되었습니다: $COMPONENTS_DIR/AU-VST-Bridge.component"
else
    error "AU-VST-Bridge.component��� 찾을 수 없습니다."
fi

if [ -d "AU-VST-Bridge_artefacts/Release/VST3/AU-VST-Bridge.vst3" ]; then
    cp -r "AU-VST-Bridge_artefacts/Release/VST3/AU-VST-Bridge.vst3" "$VST3_DIR/"
    info "VST3 플러그인이 설치되었습니다: $VST3_DIR/AU-VST-Bridge.vst3"
else
    error "AU-VST-Bridge.vst3를 찾을 수 없습니다."
fi

info "설치가 완료되었습니다!" 