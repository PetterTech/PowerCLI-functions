function Get-DeadLunPath
{
    $VMHosts = Get-View -ViewType HostSystem -Property Name,Config.StorageDevice.MultipathInfo.Lun
    $VMHostsWithDeadLunPaths = @()
    $report = @()
    
    $progress = 1
    foreach ($VMHost in $VMHosts) {
        Write-Progress -Activity "Finding hosts with dead lun paths" -Status "Checking $($VMHost.Name)" -PercentComplete ($progress/$VMHosts.count*100) -ErrorAction SilentlyContinue
        if (($VMHost | select -ExpandProperty config | select -ExpandProperty storagedevice | select -ExpandProperty multipathinfo | select -ExpandProperty lun  | select -ExpandProperty path | where {$_.pathstate -eq "dead"}).count -ge "") {
            $VMHostsWithDeadLunPaths += $VMHost
            }
    $progress++
    }
    Write-Progress -Activity "Finding hosts with dead lun paths" -Status "All done" -Completed -ErrorAction SilentlyContinue

    $progress = 1
    foreach ($VMHostWithDeadLunPaths in $VMHostsWithDeadLunPaths) {
        Write-Progress -Activity "Finding dead lun paths on hosts" -Status "Working on $($VMHostWithDeadLunPaths.Name)" -PercentComplete ($progress/$VMHostsWithDeadLunPaths.count*100) -id 1 -ErrorAction SilentlyContinue
        $object = @()
        $progress2 = 1
        foreach ($DeadLunPath in $VMHostWithDeadLunPaths | select -ExpandProperty config | select -ExpandProperty storagedevice | select -ExpandProperty multipathinfo | select -ExpandProperty lun  | select -ExpandProperty path | where {$_.pathstate -eq "dead"}) {
            Write-Progress -Activity "Adding dead lun paths to collection" -Status "Working on $($DeadLunPath.Name)" -PercentComplete ($progress2/$VMHostsWithDeadLunPaths.count*100) -Id 2 -ParentId 1 -ErrorAction SilentlyContinue
            $object2 = New-Object PSObject
            Add-Member -InputObject $object2 NoteProperty VMHost $VMHostWithDeadLunPaths.Name
            Add-Member -InputObject $object2 NoteProperty State $DeadLunPath.PathState
            Add-Member -InputObject $object2 NoteProperty LunPath $DeadLunPath.Name
            Add-Member -InputObject $object2 NoteProperty Adapter ($DeadLunPath.Adapter).SubString(13)
            $object += $object2
            $progress2++
            }
        $report += $object
        $progress++
        }
    Write-Progress -Activity "Adding dead lun paths to collection" -Status "All done" -Completed -Id 2 -ParentId 1 -ErrorAction SilentlyContinue
    Write-Progress -Activity "Finding dead lun paths on hosts" -Status "All done" -Completed -Id 1 -ErrorAction SilentlyContinue
    $report      
<#
 .Synopsis
  Lists all dead lun paths
 .Description
  Outputs a list of VMHosts who have dead lun paths
 .Example
  Get-DeadLunPath
  Outputs a list of VMHosts who have dead lun paths
 .Link
  http://cloud.kemta.net
 #>
}