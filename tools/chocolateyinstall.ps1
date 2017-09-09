$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pp       = Get-PackageParameters
$server   = (Get-CimInstance Win32_OperatingSystem).caption -like '*server*'

. $toolsDir\tweaks.ps1

if (($pp["applyall"] -eq $null -or $pp["applyall"] -eq '') -and ($pp["restoreall"] -eq $null -or $pp["restoreall"] -eq '') -and ($pp["custom"] -eq $null -or $pp["custom"] -eq '')) { $pp["applyall"] = $true }

if ($pp["restoreall"] -eq $true) {
  if ($server) {
    $presetFile = "$toolsDir\WinServer2016-RestoreAll.preset"
  } else {
    $presetFile = "$toolsDir\Win10-RestoreAll.preset"
  }
  $tweaks = Get-Content $presetFile -ErrorAction Stop | ForEach { $_.Trim() } | Where { $_ -ne "" -and $_[0] -ne "#" }
  $tweaks | ForEach { Invoke-Expression $_ }
}

if ($pp["applyall"] -eq $true) {
  if ($server) {
    $presetFile = "$toolsDir\WinServer2016-ApplyAll.preset"
  } else {
    $presetFile = "$toolsDir\Win10-ApplyAll.preset"
  }
  $tweaks = Get-Content $presetFile -ErrorAction Stop | ForEach { $_.Trim() } | Where { $_ -ne "" -and $_[0] -ne "#" }
  $tweaks | ForEach { Invoke-Expression $_ }
}

if ($pp["custom"] -ne $null -and $pp["custom"] -ne '') {
  $tweaks = Get-Content $pp["custom"] -ErrorAction Stop | ForEach { $_.Trim() } | Where { $_ -ne "" -and $_[0] -ne "#" }
  $tweaks | ForEach { Invoke-Expression $_ }
}

$tweaks = $pp.keys
foreach ($tweak in $tweaks) {
  if ($tweak -ne 'restoreall' -and $tweak -ne 'applyall' -and $tweak -ne 'custom') {
     Invoke-Expression $tweak
  }
}
