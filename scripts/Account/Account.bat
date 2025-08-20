@echo off
chcp 65001 >nul
setlocal

:: 현재 bat 파일 경로 기준으로 result 폴더 지정
set "BASE=%~dp0"
set "RESULT=%BASE%result"

if not exist "%RESULT%" mkdir "%RESULT%"

set "REPORT=%RESULT%\[1]Account.txt"

:: 헤더
powershell -NoProfile -Command ^
  "'===============================', '[계정 점검 리포트] %DATE% %TIME%', '===============================', '' | Out-File -LiteralPath '%REPORT%' -Encoding UTF8"

:: 1) 전체 계정
powershell -NoProfile -Command ^
  "'[1] 현재 시스템의 모든 로컬 계정', '----------------------------------------' | Out-File -LiteralPath '%REPORT%' -Encoding UTF8 -Append; Get-LocalUser | Select-Object Name,Enabled,PasswordRequired,SID | Format-Table -AutoSize | Out-String | Out-File -LiteralPath '%REPORT%' -Encoding UTF8 -Append; '' | Out-File -LiteralPath '%REPORT%' -Encoding UTF8 -Append"

:: 2) '$' 포함 계정
powershell -NoProfile -Command ^
  "'[2] $ 문자가 포함된 계정', '----------------------------------------' | Out-File -LiteralPath '%REPORT%' -Encoding UTF8 -Append; $a = Get-LocalUser | Where-Object { $_.Name -like '*$*' } | Select-Object -Expand Name; if ($a) { $a | Out-File -LiteralPath '%REPORT%' -Encoding UTF8 -Append } else { '없음' | Out-File -LiteralPath '%REPORT%' -Encoding UTF8 -Append }; '' | Out-File -LiteralPath '%REPORT%' -Encoding UTF8 -Append"

:: 3) 패스워드 미설정 계정
powershell -NoProfile -Command ^
  "'[3] 패스워드가 설정되지 않은 계정 (PasswordRequired=FALSE)', '----------------------------------------' | Out-File -LiteralPath '%REPORT%' -Encoding UTF8 -Append; $b = Get-LocalUser | Where-Object { $_.PasswordRequired -eq $false } | Select-Object -Expand Name; if ($b) { $b | Out-File -LiteralPath '%REPORT%' -Encoding UTF8 -Append } else { '없음' | Out-File -LiteralPath '%REPORT%' -Encoding UTF8 -Append }; '' | Out-File -LiteralPath '%REPORT%' -Encoding UTF8 -Append"

echo [완료] 결과 파일 생성됨: %REPORT%
pause
endlocal
