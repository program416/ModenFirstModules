@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ===========================================
echo   PyPI Release Script (Syntax Fixed)
echo ===========================================

:: 1. 필수 도구 확인
py -m pip install --upgrade pip build twine >nul 2>&1

:: 2. 버전 레벨 선택
echo Select Release Type:
echo 1. supermajor / 2. major / 3. minor / 4. miniminor / 5. hotfix / 6. build / 7. skip
set /p choice=Enter number (1-7): 

if "%choice%"=="1" set "vtype=supermajor"
if "%choice%"=="2" set "vtype=major"
if "%choice%"=="3" set "vtype=minor"
if "%choice%"=="4" set "vtype=miniminor"
if "%choice%"=="5" set "vtype=hotfix"
if "%choice%"=="6" set "vtype=build"
if "%choice%"=="7" set "vtype=skip"

if "%vtype%"=="" (echo Invalid selection. & pause & exit /b)

:: 3. 버전 업데이트 및 빌드
if not "%vtype%"=="skip" (
    echo [1/3] Updating version...
    (
    echo import re, sys
    echo try:
    echo     with open("pyproject.toml", "r", encoding="utf-8"^) as f: content = f.read(^)
    echo     match = re.search(r'version\s*=\s*"([\d\.]+)"', content^)
    echo     if not match: sys.exit(1^)
    echo     old_v = match.group(1^)
    echo     parts = old_v.split("."^)
    echo     while len(parts^) ^< 6: parts.append("0"^)
    echo     p = [int(x^) for x in parts]
    echo     lv = {"supermajor":0, "major":1, "minor":2, "miniminor":3, "hotfix":4, "build":5}["%vtype%"]
    echo     p[lv] += 1
    echo     for i in range(lv + 1, 6^): p[i] = 0
    echo     new_v = ".".join(map(str, p^)^)
    echo     new_c = re.sub(r'version\s*=\s*"[\d\.]+"', f'version = "{new_v}"', content^)
    echo     with open("pyproject.toml", "w", encoding="utf-8"^) as f: f.write(new_c^)
    echo     print(f"Success: {old_v} -> {new_v}"^)
    echo except Exception as e: print(e^); sys.exit(1^)
    ) > temp_v.py
    py temp_v.py
    if errorlevel 1 (del temp_v.py & pause & exit /b)
    del temp_v.py
)

echo [2/3] Building package...
if exist dist rmdir /s /q dist
py -m build
if errorlevel 1 (echo Build failed! & pause & exit /b)

:: 4. 파이썬 업로드 (Syntax Error 해결 버전)
echo [3/3] Uploading to PyPI...
set "TOKEN_PATH=D:\.Leo\secret\PyPIToken.txt"

(
echo import subprocess, os, sys
echo try:
echo     with open(r'%TOKEN_PATH%', 'r', encoding='utf-8'^) as f:
echo         token = f.read(^).strip(^).replace('\ufeff', ''^)
echo     my_env = os.environ.copy(^)
echo     my_env['TWINE_USERNAME'] = '__token__'
echo     my_env['TWINE_PASSWORD'] = token
echo     cmd = ['py', '-m', 'twine', 'upload', 'dist/*']
echo     proc = subprocess.run(cmd, env=my_env^)
echo     sys.exit(proc.returncode^)
echo except Exception as e:
echo     print(e^)
echo     sys.exit(1^)
) > temp_upload.py

py temp_upload.py
if errorlevel 1 (
    echo [ERROR] Upload failed! 
    del temp_upload.py
    pause
    exit /b
)
del temp_upload.py

echo.
echo ===========================================
echo   🎉 RELEASE COMPLETE!
echo ===========================================
pause