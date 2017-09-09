## Description

This is a PowerShell script for automation of routine tasks done after
fresh installations of Windows 10 and Windows Server 2016.

https://github.com/Disassembler0/Win10-Initial-Setup-Script

This script will execute and ApplyAll (default) and RestoreAll presets
for Windows OS type, e.g., WinServer2016-*All.preset.

## Usage

If you just want to run the ApplyAll preset:

    choco install -y win10-initial-setup-script

 or

    choco install -y win10-initial-setup-script --params "'/ApplyAll'"

Make sure your account is a member of *Administrators* group as the
script attempts to run with elevated privileges.

### Advanced usage

To supply a customized preset, you can either pass the function names
directly as parameters.

    choco install -y win10-initial-setup-script --params "'/EnableFirewall /EnableDefender'"

Or you can create a file where you write the function names (one
function name per line, no commas, whitespaces allowed, comments on
separate lines starting with `#`) and then pass the filename using
*/Custom* parameter.

Example of a preset file `mypreset.txt`:

    @"
    # Security tweaks
    EnableFirewall
    EnableDefender

    # UI tweaks
    ShowKnownExtensions
    ShowHiddenFiles
    "@ > C:/temp/mypreset.txt

Command using the preset file above:

    choco install -y win10-initial-setup-script --params "'/Custom:C:/temp/mypreset.txt'"
