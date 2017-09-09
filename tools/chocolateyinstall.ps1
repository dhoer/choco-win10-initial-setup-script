$packageName    = $env:ChocolateyPackageName
$packageVersion = $env:ChocolateyPackageVersion
$url            = 'https://github.com/Disassembler0/Win10-Initial-Setup-Script/archive/2.7.zip'
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$checksum       = '801da854786017ac8d6b45d6f276db23b8fc12075550afa7fb267595bc628a33'
$checksumType   = 'sha256'

Install-ChocolateyZipPackage $packageName $url $toolsDir -checksum $checksum -checksumType $checksumType

$pp = Get-PackageParameters

$server = (Get-CimInstance Win32_OperatingSystem).caption -like '*server*'

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
