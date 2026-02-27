@echo off
cd /d "%~dp0"

echo =========================
echo Select Release Type
echo =========================
echo 1. supermajor
echo 2. major
echo 3. minor
echo 4. miniminor
echo 5. hotfix
echo 6. build
echo 7. skip version change
echo.

set /p choice=Enter number (1-7):

if "%choice%"=="1" set type=supermajor
if "%choice%"=="2" set type=major
if "%choice%"=="3" set type=minor
if "%choice%"=="4" set type=miniminor
if "%choice%"=="5" set type=hotfix
if "%choice%"=="6" set type=build
if "%choice%"=="7" set type=skip

if not defined type (
    echo Invalid selection.
    pause
    exit /b
)

py version_bump.py %type%
if errorlevel 1 goto error

echo Cleaning dist...
if exist dist rmdir /s /q dist

echo Building...
py -m build || goto error

echo Uploading...
py -m twine upload -r pypi dist\* || goto error

echo.
echo ===== RELEASE COMPLETE =====
pause
exit /b

:error
echo.
echo !!! ERROR OCCURRED !!!
pause
exit /b 1