function List-Snapshots
{
    [CmdletBinding()] 
        Param (
            [Parameter(Position=0)][string]$Location = '*'
              )

        Get-VM -Location $Location | Get-Snapshot | Select VM,Name,Description,@{N="SizeGB";E={@([math]::Round($_.SizeGB))}},Created           
        
<#
 .Synopsis
  Lists snapshots in vCenter
 .Description
  List all snapshots in the entire vCenter or in given location
 .Parameter Location
  Used to set which Datacenter, folder, cluster etc. to look in
 .Example
  List-Snapshots
  Lists all snapshots in the vCenter
 .Example
  List-Snapshots -Location Folder1
  Lists all snapshots on VMs in Folder1
 .Link
  http://cloud.kemta.net
 #>
}