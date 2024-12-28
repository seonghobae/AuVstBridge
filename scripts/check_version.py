#!/usr/bin/env python3
import re
import sys
from pathlib import Path


def get_version_from_readme():
    """README.md 파일에서 버전 정보를 추출합니다."""
    readme_path = Path(__file__).parent.parent / "README.md"
    if not readme_path.exists():
        print("ERROR: README.md 파일을 찾을 수 없습니다.")
        return None

    with open(readme_path, "r", encoding="utf-8") as f:
        content = f.read()
        version_match = re.search(
            r"\*\*Current version\*\*:\s*(\d+\.\d+\.\d+)", content
        )
        if version_match:
            return version_match.group(1)
    return None


def get_version_from_installer():
    """install.sh 파일에서 버전 정보를 추출합니다."""
    installer_path = Path(__file__).parent.parent / "install.sh"
    if not installer_path.exists():
        print("ERROR: install.sh 파일을 찾을 수 없습니다.")
        return None

    with open(installer_path, "r", encoding="utf-8") as f:
        content = f.read()
        version_match = re.search(r'VERSION="(\d+\.\d+\.\d+)"', content)
        if version_match:
            return version_match.group(1)
    return None


def main():
    readme_version = get_version_from_readme()
    installer_version = get_version_from_installer()

    if readme_version is None or installer_version is None:
        print("ERROR: 버전 정보를 찾을 수 없습니다.")
        sys.exit(1)

    if readme_version != installer_version:
        print(
            f"ERROR: 버전 불일치! README.md: {readme_version}, install.sh: {installer_version}"
        )
        sys.exit(1)

    print(f"SUCCESS: 버전이 일치합니다. (v{readme_version})")
    sys.exit(0)


if __name__ == "__main__":
    main()
