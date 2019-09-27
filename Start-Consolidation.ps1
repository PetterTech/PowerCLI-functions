function Start-Consolidation
{
    [CmdletBinding()] 
        Param (
            [string]$Location = '*',
            [switch]$ListOnly
              )

        $VMs = Get-VM -Location $Location | Where-Object {$_.Extensiondata.Runtime.ConsolidationNeeded} 

        if ($ListOnly) {
              $VMs
              }

        else {
            $VMs | ForEach-Object {
                Write-Host "Starting disk consolidation on $_.Name"
                $_.ExtensionData.ConsolidateVMDisks()
                Write-Host "Finished disk consolidation on $_.Name"
                                  }
              }
        
<#
 .Synopsis
  Searches vCentre for VMs in need of disk consolidation and starts disk consolidation
 .Description
  This function searches the entire vCentre, or the given folder,datasenter,cluster,vApp or ResourcePool for VMs that is in need of disk consolidation. It will then start disk consolidation on those that need it
 .Parameter Location
  If you want to narrow the search to a specific folder,datasenter,cluster,vApp or ResourcePool
 .Example
  Start-Consolidation
  Searches the entire vCentre for VMs that need consolidation and starts consolidating them
 .Example
  Start-Consolidation -Location vApp01
  Searches through vApp01 for VMs that need consolidation and starts consolidation on them
 .Link
  http://cloud.kemta.net
 #>
 }