function List-ISOMounts
{
    [CmdletBinding()] 
        Param (
            [string]$Location = '*',
            [switch]$Dismount
              )

        $VMs = Get-VM -Location $Location

        if ($Dismount)
            {
            Write-Host "VMs with mounted ISOs:" -ForegroundColor Green
            $VMs | Get-CDDrive | select @{N="VM";E="Parent"},IsoPath | where {$_.IsoPath -ne $null}

            Write-Host ""
            Write-Host "Starting to dismount ISOs" -ForegroundColor Green
            Get-VM -Location $Location | Get-CDDrive | where {$_.IsoPath -ne $null} | Set-CDDrive -NoMedia -Confirm:$False
            }

        else
            {
            Write-Host "VMs with mounted ISOs:"
            $VMs | Get-CDDrive | select @{N="VM";E="Parent"},IsoPath | where {$_.IsoPath -ne $null}
            }
        
<#
 .Synopsis
  Lists all VMs with ISOs mounted, can also dismount them
 .Description
  Lists all VMs with ISOs mounted. If the switch -Dismount is present all mounted ISOs will be dismounted
 .Parameter Location
  Used to set which Datacenter, folder, cluster etc. to look in
 .Example
  List-ISOMounts
  Lists all mounted ISOs in the vCenter
 .Example
  List-Snapshots -Location Folder1
  Lists all mounted ISOs on VMs in Folder1
 .Example
  List-Snapshots -Dismount
  Lists all mounted ISOs on VMs in the vCenter and then dismounts them
 .Link
  http://cloud.kemta.net
 #>
}