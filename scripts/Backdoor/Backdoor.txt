@echo off
chcp 65001 >nul
setlocal

set RESULT_DIR=%~dp0result
if not exist "%RESULT_DIR%" mkdir "%RESULT_DIR%"
set REPORT=%RESULT_DIR%\[2]Backdoor.txt

echo ===============================  > "%REPORT%"
echo [백도어 점검 리포트] %date% %time% >> "%REPORT%"
echo ===============================  >> "%REPORT%"
echo. >> "%REPORT%"

:: [1] 전체 LISTENING 포트 확인
echo [1] 전체 LISTENING 포트 확인 >> "%REPORT%"
netstat -ano | findstr LISTENING >> "%REPORT%"
echo. >> "%REPORT%"

:: [2] 의심 포트 점검
echo [2] 의심 포트 점검 >> "%REPORT%"
set found_port=0
for %%p in (5555 6666 6667 4444 12345 27374 31337 38317 8081) do (
    for /f "tokens=*" %%i in ('netstat -ano ^| findstr ":%%p"') do (
        echo --- 포트 %%p --- >> "%REPORT%"
        echo %%i >> "%REPORT%"
        set found_port=1
    )
)
if %found_port%==0 (
    echo 없음 >> "%REPORT%"
)
echo. >> "%REPORT%"

:: [3] 의심 포트 프로세스 매핑
echo [3] 의심 포트 프로세스 매핑 >> "%REPORT%"
set found_proc=0
for %%p in (5555 6666 6667 4444 12345 27374 31337 38317 8081) do (
    for /f "tokens=5" %%i in ('netstat -ano ^| findstr ":%%p"') do (
        echo 포트 %%p → PID %%i >> "%REPORT%"
        tasklist /FI "PID eq %%i" >> "%REPORT%"
        set found_proc=1
    )
)
if %found_proc%==0 (
    echo 없음 >> "%REPORT%"
)
echo. >> "%REPORT%"

:: [4] 조치 사항
echo [4] 조치 사항 >> "%REPORT%"
echo - 발견된 의심 포트에 대해 차단 정책 적용 필요 >> "%REPORT%"
echo - 관련 백도어 서비스 및 파일 확인 후 삭제 >> "%REPORT%"
echo - 방화벽/hosts.allow/deny 설정을 활용하여 접근 차단 가능 >> "%REPORT%"
echo. >> "%REPORT%"
echo =============================== >> "%REPORT%"
echo =============================== >> "%REPORT%"

echo 결과 저장: %REPORT%
endlocal
pause
