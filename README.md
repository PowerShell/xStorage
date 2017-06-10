# xStorage

[![Build status](https://ci.appveyor.com/api/projects/status/1j95juvceu39ekm7/branch/master?svg=true)](https://ci.appveyor.com/project/PowerShell/xstorage/branch/master)
[![codecov](https://codecov.io/gh/PowerShell/xStorage/branch/master/graph/badge.svg)](https://codecov.io/gh/PowerShell/xStorage)

The **xStorage** module contains the following resources:

- **xMountImage**: used to mount or unmount an ISO/VHD disk image. It can be
    mounted as read-only (ISO, VHD, VHDx) or read/write (VHD, VHDx).
- **xDisk**: used to initialize, format and mount the partition as a drive letter.
- **xDiskAccessPath**: used to initialize, format and mount the partition to a
    folder access path.
- **xCDROM**: used to change the drive letter of the DVD or CDROM.  This resource
    ignores mounted ISOs.
- **xWaitForDisk** wait for a disk to become available.
- **xWaitForVolume** wait for a drive to be mounted and become available.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/)
or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any
additional questions or comments.

## Contributing

Please check out common DSC Resources [contributing guidelines](https://github.com/PowerShell/DscResource.Kit/blob/master/CONTRIBUTING.md).
