# Versions

## Unreleased

- Added 'DscResourcesToExport' to manifest to improve information in
  PowerShell Gallery and removed wildcards from 'FunctionsToExport',
  'CmdletsToExport', 'VariablesToExport' and 'AliasesToExport' - fixes
  [Issue #192](https://github.com/PowerShell/StorageDsc/issues/192).
- Clean up module manifest to correct Author and Company - fixes
  [Issue #191](https://github.com/PowerShell/StorageDsc/issues/191).
- Fix a bug where the current state of NoDefaultDriveLetter is not handled.
  Added a refresh of the current partition information prior to checking state -fixes
  [Issue #145](https://github.com/PowerShell/StorageDsc/issues/145).

## 4.5.0.0

- Opt-in to Example publishing to PowerShell Gallery - fixes [Issue #186](https://github.com/PowerShell/StorageDsc/issues/186).
- DiskAccessPath:
  - Updated the resource to not assign a drive letter by default when adding
    a disk access path. Adding a Set-Partition -NoDefaultDriveLetter
    $NoDefaultDriveLetter block defaulting to true.
    When adding access paths the disks will no longer have
    drive letters automatically assigned on next reboot which is the desired
    behavior - Fixes [Issue #145](https://github.com/PowerShell/StorageDsc/issues/145).

## 4.4.0.0

- Refactored module folder structure to move resource to root folder of
  repository and remove test harness - fixes [Issue #169](https://github.com/PowerShell/StorageDsc/issues/169).
- Updated Examples to support deployment to PowerShell Gallery scripts.
- Removed limitation on using Pester 4.0.8 during AppVeyor CI.
- Moved the Code of Conduct text out of the README.md and into a
  CODE\_OF\_CONDUCT.md file.
- Explicitly removed extra hidden files from release package
- Disk:
  - Added minimum timetowate of 3s after new-partition using the while loop.
    The problem occurs when the partition is created and the format-volume
    is attempted before the volume has completed.
    There appears to be no property to determine if the partition is
    sufficiently ready to format and it will often format as a raw volume when
    the error occurs - fixes [Issue #85](https://github.com/PowerShell/StorageDsc/issues/85).

## 4.3.0.0

- WaitForDisk:
  - Added readonly-property isAvailable which shows the current state
    of the disk as a boolean - fixes [Issue #158](https://github.com/PowerShell/StorageDsc/issues/158).

## 4.2.0.0

- Disk:
  - Added `PartitionStyle` parameter - Fixes [Issue #137](https://github.com/PowerShell/StorageDsc/issues/37).
  - Changed MOF name from `MSFT_Disk` to `MSFTDSC_Disk` to remove conflict
    with Windows built-in CIM class - Fixes [Issue #167](https://github.com/PowerShell/StorageDsc/issues/167).
- Opt-in to Common Tests:
  - Common Tests - Validate Example Files To Be Published
  - Common Tests - Validate Markdown Links
  - Common Tests - Relative Path Length
- Added .VSCode settings for applying DSC PSSA rules - fixes [Issue #168](https://github.com/PowerShell/StorageDsc/issues/168).
- Disk:
  - Added 'defragsvc' service conflict known issue to README.MD - fixes
    [Issue #172](https://github.com/PowerShell/StorageDsc/issues/172).
- Corrected style violations in StorageDsc.Common module - fixes [Issue #153](https://github.com/PowerShell/StorageDsc/issues/153).
- Corrected style violations in StorageDsc.ResourceHelper module.

## 4.1.0.0

- Enabled PSSA rule violations to fail build - Fixes [Issue #149](https://github.com/PowerShell/StorageDsc/issues/149).
- Fixed markdown rule violations in CHANGELOG.MD.
- Disk:
  - Corrected message strings.
  - Added message when partition resize required but `AllowDestructive`
    parameter is not enabled.
  - Fix error when `Size` not specified and `AllowDestructive` is `$true`
    and partition can be expanded - Fixes [Issue #162](https://github.com/PowerShell/StorageDsc/issues/162).
  - Fix incorrect error displaying when newly created partition is not
    made Read/Write.
  - Change verbose messages to show warnings when a partition resize would
    have occured but the `AllowDestructive` flag is set to `$false`.

## 4.0.0.0

- BREAKING CHANGE:
  - Renamed xStorage to StorageDsc
  - Renamed MSFT_xDisk to MSFT_Disk
  - Renamed MSFT_xDiskAccessPath to MSFT_DiskAccessPath
  - Renamed MSFT_xMountImage to MSFT_MountImage
  - Renamed MSFT_xOpticalDiskDriveLetter to MSFT_OpticalDiskDriveLetter
  - Renamed MSFT_xWaitForDisk to MSFT_WaitForDisk
  - Renamed MSFT_xWaitForVolume to MSFT_WaitforVolume
  - Deleted xStorage folder under StorageDsc/Modules
  - See [Issue 129](https://github.com/PowerShell/xStorage/issues/129)

## 3.4.0.0

- xDisk:
  - Removed duplicate integration tests for Guid Disk Id type.
  - Added new contexts to integration tests improve clarity.
  - Fix bug when size not specified and disk partitioned and
    formatted but not assigned drive letter - See [Issue 103](https://github.com/PowerShell/xStorage/issues/103).
- xDiskAccessPath:
  - Added new contexts to integration tests improve clarity.
  - Fix bug when size not specified and disk partitioned and
    formatted but not assigned to path - See [Issue 103](https://github.com/PowerShell/xStorage/issues/103).

## 3.3.0.0

- Opted into common tests for Module and Script files - See [Issue 115](https://github.com/PowerShell/xStorage/issues/115).
- xDisk:
  - Added support for Guid Disk Id type - See [Issue 104](https://github.com/PowerShell/xStorage/issues/104).
  - Added parameter AllowDestructive - See [Issue 11](https://github.com/PowerShell/xStorage/issues/11).
  - Added parameter ClearDisk - See [Issue 50](https://github.com/PowerShell/xStorage/issues/50).
- xDiskAccessPath:
  - Added support for Guid Disk Id type - See [Issue 104](https://github.com/PowerShell/xStorage/issues/104).
- xWaitForDisk:
  - Added support for Guid Disk Id type - See [Issue 104](https://github.com/PowerShell/xStorage/issues/104).
- Added .markdownlint.json file to configure markdown rules to validate.
- Clean up Badge area in README.MD - See [Issue 110](https://github.com/PowerShell/xStorage/issues/110).
- Disabled MD013 rule checking to enable badge table.
- Added .github support files:
  - CONTRIBUTING.md
  - ISSUE_TEMPLATE.md
  - PULL_REQUEST_TEMPLATE.md
- Changed license year to 2017 and set company name to Microsoft
  Corporation in LICENSE.MD and module manifest - See [Issue 111](https://github.com/PowerShell/xStorage/issues/111).
- Set Visual Studio Code setting "powershell.codeFormatting.preset" to
  "custom" - See [Issue 108](https://github.com/PowerShell/xStorage/issues/108)
- Added `Documentation and Examples` section to Readme.md file - see
  [issue #116](https://github.com/PowerShell/xStorage/issues/116).
- Prevent unit tests from DSCResource.Tests from running during test
  execution - fixes [Issue #118](https://github.com/PowerShell/xStorage/issues/118).
- Updated tests to meet Pester V4 guidelines - fixes [Issue #120](https://github.com/PowerShell/xStorage/issues/120).

## 3.2.0.0

- xDisk:
  - Fix error message when new partition does not become writable before timeout.
  - Removed unneeded timeout initialization code.
- xDiskAccessPath:
  - Fix error message when new partition does not become writable before timeout.
  - Removed unneeded timeout initialization code.
  - Fix error when used on Windows Server 2012 R2 - See [Issue 102](https://github.com/PowerShell/xStorage/issues/102).
- Added the VS Code PowerShell extension formatting settings that cause PowerShell
  files to be formatted as per the DSC Resource kit style guidelines.
- Removed requirement on Hyper-V PowerShell module to execute integration tests.
- xMountImage:
  - Fix error when mounting VHD on Windows Server 2012 R2 - See [Issue 105](https://github.com/PowerShell/xStorage/issues/105)

## 3.1.0.0

- Added integration test to test for conflicts with other common resource kit modules.
- Prevented ResourceHelper and Common module cmdlets from being exported to resolve
  conflicts with other resource modules.

## 3.0.0.0

- Converted AppVeyor build process to use AppVeyor.psm1.
- Added support for auto generating wiki, help files, markdown linting
  and checking examples.
- Correct name of MSFT_xDiskAccessPath.tests.ps1.
- Move shared modules into Modules folder.
- Fixed unit tests.
- Removed support for WMI cmdlets.
- Opted in to Markdown and Example tests.
- Added CodeCov.io support.
- Removed requirement on using Pester 3.4.6 because Pester bug fixed in 4.0.3.
- Fixed unit tests for MSFT_xDiskAccessPath resource to be compatible with
  Pester 4.0.3.
- xDisk:
  - BREAKING CHANGE: Renamed parameter DiskNumber to DiskId to enable it to
    contain either DiskNumber or UniqueId - See [Issue 81](https://github.com/PowerShell/xStorage/issues/81).
  - Added DiskIdType parameter to enable specifying the type of identifer
    the DiskId parameter contains - See [Issue 81](https://github.com/PowerShell/xStorage/issues/81).
  - Changed to use xDiskAccessPath pattern to fix issue with Windows Server
    2016 - See [Issue 80](https://github.com/PowerShell/xStorage/issues/80).
  - Fixed style violations in xDisk.
  - Fixed issue when creating multiple partitions on a single disk with no size
    specified - See [Issue 86](https://github.com/PowerShell/xStorage/issues/86).
- xDiskAccessPath:
  - BREAKING CHANGE: Renamed parameter DiskNumber to DiskId to
    enable it to contain either DiskNumber or UniqueId - See [Issue 81](https://github.com/PowerShell/xStorage/issues/81).
  - Added DiskIdType parameter to enable specifying the type
    of identifer the DiskId parameter contains - See [Issue 81](https://github.com/PowerShell/xStorage/issues/81).
  - Fixed incorrect logging messages when changing volume label.
  - Fixed issue when creating multiple partitions on a single disk with no size
    specified - See [Issue 86](https://github.com/PowerShell/xStorage/issues/86).
- xWaitForDisk:
  - BREAKING CHANGE: Renamed parameter DiskNumber to DiskId to
    enable it to contain either DiskNumber or UniqueId - See [Issue 81](https://github.com/PowerShell/xStorage/issues/81).
  - Added DiskIdType parameter to enable specifying the type
    of identifer the DiskId parameter contains - See [Issue 81](https://github.com/PowerShell/xStorage/issues/81).

## 2.9.0.0

- Updated readme.md to remove markdown best practice rule violations.
- Updated readme.md to match DSCResources/DscResource.Template/README.md.
- xDiskAccessPath:
  - Fix bug when re-attaching disk after mount point removed or detatched.
  - Additional log entries added for improved diagnostics.
  - Additional integration tests added.
  - Improve timeout loop.
- Converted integration tests to use ```$TestDrive``` as working folder
  or ```temp``` folder when persistence across tests is required.
- Suppress ```PSUseShouldProcessForStateChangingFunctions``` rule violations in resources.
- Rename ```Test-AccessPath``` function to ```Assert-AccessPathValid```.
- Rename ```Test-DriveLetter``` function to ```Assert-DriveLetterValid```.
- Added ```CommonResourceHelper.psm1``` module (based on PSDscResources).
- Added ```CommonTestsHelper.psm1``` module  (based on PSDscResources).
- Converted all modules to load localization data using ```Get-LocalizedData```
  from CommonResourceHelper.
- Converted all exception calls and tests to use functions
  in ```CommonResourceHelper.psm1``` and ```CommonTestsHelper.psm1``` respectively.
- Fixed examples:
  - Sample_InitializeDataDisk.ps1
  - Sample_InitializeDataDiskWithAccessPath.ps1
  - Sample_xMountImage_DismountISO.ps1
- xDisk:
  - Improve timeout loop.

## 2.8.0.0

- added test for existing file system and no drive letter assignment to allow
  simple drive letter assignment in MSFT_xDisk.psm1
- added unit test for volume with existing partition and no drive letter
  assigned for MSFT_xDisk.psm1
- xMountImage: Fixed mounting disk images on Windows 10 Anniversary Edition
- Updated to meet HQRM guidelines.
- Moved all strings into localization files.
- Fixed examples to import xStorage module.
- Fixed Readme.md layout issues.
- xWaitForDisk:
  - Added support for setting DriveLetter parameter with or without colon.
  - MOF Class version updated to 1.0.0.0.
- xWaitForVolume:
  - Added new resource.
- StorageCommon:
  - Added helper function module.
  - Corrected name of unit tests file.
- xDisk:
  - Added validation of DriveLetter parameter.
  - Added support for setting DriveLetter parameter with or without colon.
  - Removed obfuscation of drive/partition errors by eliminating try/catch block.
  - Improved code commenting.
  - Reordered tests so they are in same order as module functions to ease creation.
  - Added FSFormat parameter to allow disk format to be specified.
  - Size or AllocationUnitSize mismatches no longer trigger Set-TargetResource
    because these values can't be changed (yet).
  - MOF Class version updated to 1.0.0.0.
  - Unit tests changed to match xDiskAccessPath methods.
  - Added additional unit tests to Get-TargetResource.
  - Fixed bug in Get-TargetResource when disk did not contain any partitions.
  - Added missing cmdletbinding() to functions.
- xMountImage (Breaking Change):
  - Removed Name parameter (Breaking Change)
  - Added validation of DriveLetter parameter.
  - Added support for setting DriveLetter parameter with or without colon.
  - MOF Class version updated to 1.0.0.0.
  - Enabled mounting of VHD/VHDx/VHDSet disk images.
  - Added StorageType and Access parameters to allow mounting VHD and VHDx disks
    as read/write.
- xDiskAccessPath:
  - Added new resource.
  - Added support for changing/setting volume label.

## 2.7.0.0

- Converted appveyor.yml to install Pester from PSGallery instead of from Chocolatey.

## 2.6.0.0

- MSFT_xDisk: Replaced Get-WmiObject with Get-CimInstance

## 2.5.0.0

- added test for existing file system to allow simple drive letter assignment in
  MSFT_xDisk.psm1
- modified Test verbose message to correctly reflect blocksize value in
  MSFT_xDisk.psm1 line 217
- added unit test for new volume with out existing partition for MSFT_xDisk.psm1
- Fixed error propagation

## 2.4.0.0

- Fixed bug where AllocationUnitSize was not used

## 2.3.0.0

- Added support for `AllocationUnitSize` in `xDisk`.

## 2.2.0.0

- Updated documentation: changed parameter name Count to RetryCount in
  xWaitForDisk resource

## 2.1.0.0

- Fixed encoding

## 2.0.0.0

- Breaking change: Added support for following properties: DriveLetter, Size,
  FSLabel. DriveLetter is a new key property.

## 1.0.0.0

This module was previously named **xDisk**, the version is regressing to a
"1.0.0.0" release with the addition of xMountImage.

- Initial release of xStorage module with following resources (contains
  resources from deprecated xDisk module):
- xDisk (from xDisk)
- xMountImage
- xWaitForDisk (from xDisk)
