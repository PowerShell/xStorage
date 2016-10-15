<#
.Synopsis
The Get-TargetResource function is used to fetch the status of file specified in DestinationPath on the target machine.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
		[parameter(Mandatory = $true)]
        [System.String]
        $FriendlyName,

        [System.String]
        $NewFriendlyName,

	    [System.UInt32]
		$NumberOfDisks = 0,

        [System.UInt64]
        $DriveSize = 0,

		[ValidateSet('Present','Absent')]
		[System.String]
        $Ensureure
    )

	#Check storagepool
	Write-Verbose "Getting info for storagepool $($FriendlyName)."
	$StoragePoolResult = Get-StoragePool -FriendlyName $FriendlyName
	$DiskResult = $StoragePoolResult | Get-PhysicalDisk

	If ($StoragePoolResult){
		$returnValue = @{
			FriendlyName = [System.String]$FriendlyName
			DriveSize = [System.UInt64]($DiskResult[0].Size/1024/1024/1024)
			NumberOfDisks = [System.UInt32]$DiskResult.Count
			Ensure = 'Present'
		}
	}
	Else{
		$returnValue = @{
			FriendlyName = [System.String]$FriendlyName
			DriveSize = [System.UInt64]0
			NumberOfDisks = [System.UInt32]0
			Ensure = 'Absent'
		}
	}

    $returnValue
}

<#
.Synopsis
The Get-TargetResource function is used to fetch the status of file specified in DestinationPath on the target machine.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
		[parameter(Mandatory = $true)]
        [System.String]
        $FriendlyName,

        [System.String]
        $NewFriendlyName,

	    [System.UInt32]
		$NumberOfDisks = 0,

        [System.UInt64]
        $DriveSize = 0,

		[ValidateSet('Present','Absent')]
		[System.String]
        $Ensure
    )
 
    Write-Verbose 'Creating Storage Pool'

	#Check of storagepool already exists
	$CheckStoragePool = Get-TargetResource @PSBoundParameters

	If (($Ensure -ieq 'Present') -and ($CheckStoragePool.Ensure -ieq 'Absent')) {#No storagepool found, create one
		#Check of enough disks are available
		If ((Get-PhysicalDisk -CanPool $true).Count -lt $NumberOfDisks) {
			Throw 'Not enough disks available.'
		}

		If ($DriveSize -ne 0) {
			$Disks = Get-PhysicalDisk -CanPool $true | Where-Object {$_.Size/1024/1024/1024 -eq $DriveSize}
		}
		If ($NumberOfDisks -ne 0) {
			$Disks = Get-PhysicalDisk -CanPool $true|Select-Object -First $NumberOfDisks
		}
		If (($NumberOfDisks -ne 0) -and ($DriveSize -ne 0)) {
			#Select the number of disks to be member of the designated pool
			$Disks = Get-PhysicalDisk -CanPool $true | Where-Object {$_.Size/1024/1024/1024 -eq $DriveSize} | Where-Object {$_.Size/1024/1024/1024 -eq $DriveSize}
		}

    	New-StoragePool -FriendlyName $FriendlyName `
                    	-StorageSubSystemUniqueId (Get-StorageSubSystem -Model 'Windows Storage').uniqueID `
                    	-PhysicalDisks $Disks
 	}
	If (($Ensure -ieq 'Present') -and ($CheckStoragePool.Ensure -ieq 'Present')) {#storagepool found, try to adjust
		#Only expansion is supported right now..
		If ($NumberOfDisks -gt $CheckStoragePool.NumberOfDisks) {
			$ExtraNumberOfDisks = $NumberOfDisks - $CheckStoragePool.NumberOfDisks
			If ($DriveSize -ne 0) {
				$Disks = Get-PhysicalDisk -CanPool $true | Where-Object {$_.Size/1024/1024/1024 -eq $DriveSize} |Select-Object -First $ExtraNumberOfDisks
			}
			Else{
				$Disks = Get-PhysicalDisk -CanPool $true|Select-Object -First $ExtraNumberOfDisks
			}

			Add-PhysicalDisk -PhysicalDisks $Disks -StoragePoolFriendlyName $Name
		}

		If ($NewFriendlyName) {
			Set-StoragePool -FriendlyName $FriendlyName `
							-NewFriendlyName $NewFriendlyName
		}

	}

	If (($Ensure -ieq 'Absent') -and ($CheckStoragePool.Ensure -ieq 'Present')) {#Removal requested
		#Your wish is our command....destroy the storagepool
		$SP = Get-StoragePool -FriendlyName $FriendlyName
		$VD = $SP|Get-VirtualDisk -ErrorAction SilentlyContinue
		$PT = $VD|Get-Partition -ErrorAction SilentlyContinue

		If ($SP.IsReadOnly -eq $true){$SP|Set-StoragePool -IsReadOnly $false}
		If ($PT){$PT|Remove-Partition -Confirm:$false}
		If ($VD){$VD|Remove-VirtualDisk -Confirm:$false}
		$SP|Remove-StoragePool -Confirm:$false
	}
}



function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
		[parameter(Mandatory = $true)]
        [System.String]
        $FriendlyName,

        [System.String]
        $NewFriendlyName,

	    [System.UInt32]
		$NumberOfDisks = 0,

        [System.UInt64]
        $DriveSize = 0,

		[ValidateSet('Present','Absent')]
		[System.String]
        $Ensure
    )

	#Check of storagepool already exists
	$CheckStoragePool = Get-TargetResource @PSBoundParameters

	If (($Ensure -ieq 'Present') -and ($CheckStoragePool.Ensure -ieq 'Absent')) {Return $false} #No storagepool found
		
	If (($NewFriendlyName) -and ($CheckStoragePool.Ensure -ieq 'Present')) {Return $false} #Rename requested
	
	If (($Ensure -ieq 'Present') -and ($CheckStoragePool.Ensure -ieq 'Present')){
		If ($NumberOfDisks -gt $CheckStoragePool.NumberOfDisks) {Return $false} # Disk expansion requested
		If ($NewFriendlyName) {Return $false} #Rename requested
	}

	If (($Ensure -ieq 'Absent') -and ($CheckStoragePool.Ensure -ieq 'Present')) {Return $false} #Removal requested

	Return $true
}


Export-ModuleMember -Function *-TargetResource

