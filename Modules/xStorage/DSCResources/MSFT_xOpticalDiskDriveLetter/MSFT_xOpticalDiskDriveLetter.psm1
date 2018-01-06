# Suppressed as per PSSA Rule Severity guidelines for unit/integration tests:
# https://github.com/PowerShell/DscResources/blob/master/PSSARuleSeverities.md
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
param ()

$modulePath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -ChildPath 'Modules'

# Import the Storage Common Modules
Import-Module -Name (Join-Path -Path $modulePath `
        -ChildPath (Join-Path -Path 'StorageDsc.Common' `
            -ChildPath 'StorageDsc.Common.psm1'))

# Import the Storage Resource Helper Module
Import-Module -Name (Join-Path -Path $modulePath `
        -ChildPath (Join-Path -Path 'StorageDsc.ResourceHelper' `
            -ChildPath 'StorageDsc.ResourceHelper.psm1'))

# Import Localization Strings
$localizedData = Get-LocalizedData `
    -ResourceName 'MSFT_xOpticalDiskDriveLetter' `
    -ResourcePath (Split-Path -Parent $Script:MyInvocation.MyCommand.Path)

<#
    .SYNOPSIS
    This helper function returns the current drive letter assigned to the optical disk.
#>
function Get-OpticalDiskDriveLetter
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
    )

    <#
        The Caption and DeviceID properties are checked to avoid mounted ISO images in Windows 2012+ and Windows 10.
        The device ID is required because a CD/DVD in a Hyper-V virtual machine has the same caption as a mounted ISO.

        Example DeviceID for a virtual drive in a Hyper-V VM - SCSI\CDROM&VEN_MSFT&PROD_VIRTUAL_DVD-ROM\000006
        Example DeviceID for a mounted ISO   in a Hyper-V VM - SCSI\CDROM&VEN_MSFT&PROD_VIRTUAL_DVD-ROM\2&1F4ADFFE&0&000002
    #>
    $driveLetter = (Get-CimInstance -ClassName Win32_CDROMDrive | Where-Object {
            -not (
                $_.Caption -eq 'Microsoft Virtual DVD-ROM' -and
                ($_.DeviceID.Split('\')[-1]).Length -gt 10
            )
        }
    ).Drive

    return $driveLetter
}

<#
    .SYNOPSIS
    Returns the current drive letter assigned to the optical disk.

    .PARAMETER IsSingleInstance
    Specifies the resource is a single instance, the value must be 'Yes'.

    .PARAMETER DriveLetter
    Specifies the drive letter to assign to the optical disk. Can be a
    single letter, optionally followed by a colon.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DriveLetter
    )

    # Allow use of drive letter without colon
    $DriveLetter = Assert-DriveLetterValid -DriveLetter $DriveLetter -Colon

    Write-Verbose -Message ( @(
            "$($MyInvocation.MyCommand): "
            $($localizedData.UsingGetCimInstanceToFetchDriveLetter)
        ) -join '' )

    $currentDriveLetter = Get-OpticalDiskDriveLetter

    if (-not $currentDriveLetter)
    {
        Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                $($localizedData.NoOpticalDiskDrive)
            ) -join '' )

        $Ensure = 'Present'
    }
    else
    {
        # Check if $driveletter is the location of the optical disk
        if ($currentDriveLetter -eq $DriveLetter)
        {
            Write-Verbose -Message ( @(
                    "$($MyInvocation.MyCommand): "
                    $($localizedData.OpticalDriveSetAsRequested -f $DriveLetter)
                ) -join '' )

            $Ensure = 'Present'
        }
        else
        {
            Write-Verbose -Message ( @(
                    "$($MyInvocation.MyCommand): "
                    $($localizedData.OpticalDriveNotSetAsRequested -f $currentDriveLetter, $DriveLetter)
                ) -join '' )

            $Ensure = 'Absent'
        }
    }

    $returnValue = @{
        IsSingleInstance = 'Yes'
        DriveLetter      = $currentDriveLetter
        Ensure           = $Ensure
    }

    return $returnValue
} # Get-TargetResource

<#
    .SYNOPSIS
    Sets the drive letter of the optical disk.

    .PARAMETER IsSingleInstance
    Specifies the resource is a single instance, the value must be 'Yes'.

    .PARAMETER DriveLetter
    Specifies the drive letter to assign to the optical disk. Can be a
    single letter, optionally followed by a colon.

    .PARAMETER Ensure
    Determines whether the setting should be applied or removed.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DriveLetter,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present'
    )

    # Allow use of drive letter without colon
    $DriveLetter = Assert-DriveLetterValid -DriveLetter $DriveLetter -Colon

    $currentDriveLetter = Get-OpticalDiskDriveLetter

    if ($currentDriveLetter -eq $DriveLetter -and $Ensure -eq 'Present')
    {
        return
    }

    # Assuming a drive letter is found
    if ($currentDriveLetter)
    {
        Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                $($localizedData.AttemptingToSetDriveLetter -f $currentDriveLetter, $DriveLetter)
            ) -join '' )

        # If $Ensure -eq Absent this will remove the drive letter from the optical disk
        if ($Ensure -eq 'Absent')
        {
            $DriveLetter = $null
        }

        Get-CimInstance -ClassName Win32_Volume -Filter "DriveLetter = '$currentDriveLetter'" |
            Set-CimInstance -Property @{ DriveLetter = $DriveLetter }
    }
    else
    {
        Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                $($localizedData.NoOpticalDiskDrive)
            ) -join '' )
    }
} # Set-TargetResource

<#
    .SYNOPSIS
    Tests the optical disk letter is set as expected

    .PARAMETER IsSingleInstance
    Specifies the resource is a single instance, the value must be 'Yes'.

    .PARAMETER DriveLetter
    Specifies the drive letter to assign to the optical disk. Can be a
    single letter, optionally followed by a colon.

    .PARAMETER Ensure
    Determines whether the setting should be applied or removed.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        # specify the drive letter as a single letter, optionally include the colon
        [Parameter(Mandatory = $true)]
        [System.String]
        $DriveLetter,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present'
    )

    # Allow use of drive letter without colon
    $DriveLetter = Assert-DriveLetterValid -DriveLetter $DriveLetter -Colon

    # Is there an optical disk?
    $opticalDrive = Get-CimInstance -ClassName Win32_CDROMDrive -Property Id

    # What type of drive is attached to $driveletter
    $volumeDriveType = Get-CimInstance `
        -ClassName Win32_Volume `
        -Filter "DriveLetter = '$DriveLetter'" `
        -Property DriveType

    # Check there is an optical disk
    if ($opticalDrive)
    {
        Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                $($localizedData.OpticalDiskDriveFound -f $opticaDrive.id)
            ) -join '' )

        if ($volumeDriveType.DriveType -eq 5)
        {
            Write-Verbose -Message ( @(
                    "$($MyInvocation.MyCommand): "
                    $($localizedData.DriveLetterVolumeType -f $driveletter, $volumeDriveType.DriveType)
                ) -join '' )

            $result = $true
        }
        else
        {
            Write-Warning -Message ( @(
                    "$($MyInvocation.MyCommand): "
                    $($localizedData.DriveLetterExistsButNotOptical -f $driveletter)
                ) -join '' )

            $result = $false
        }

        # Return false if the drive letter specified is an optical disk resource & $Ensure -eq 'Absent'
        if ($Ensure -eq 'Absent')
        {
            $result = -not $result
        }
    }
    else
    {
        # Return false if there is no optical disk - can't set what isn't there!
        Write-Warning -Message ( @(
                "$($MyInvocation.MyCommand): "
                $($localizedData.NoOpticalDiskDrive)
            ) -join '' )

        $result = $false
    }

    return $result
}

Export-ModuleMember -Function *-TargetResource
