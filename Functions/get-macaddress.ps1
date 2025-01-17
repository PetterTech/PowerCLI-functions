function Get-MACAddress 
{
    [CmdletBinding()] 
        Param (
            [parameter(Mandatory=$True,ValueFromPipeline=$True)][Validatelength(17,17)][string]$MAC,
            [string]$Location = '*'
        )
        Get-VM -Location $Location | Select Name,Folder,PowerState, @{N="Network";E={$_ | Get-networkAdapter | ? {$_.macaddress -eq $MAC}}} | Where {$_.Network -ne ""}
<#
 .Synopsis
  Searches vCentre for the given MAC address
 .Description
  This function searches the entire vCentre, or the given folder,datasenter,cluster,vApp or ResourcePool for VMs using the given MAC address. VMs with the given MAC address will be listed with Name,Folder,PowerState and to which network adapter the MAC address is assigned
 .Parameter MACAddress
  The MAC address you want to search for. Use the following format: 00:00:00:00:00:00
 .Parameter Location
  If you want to narrow the search to a specific folder,datasenter,cluster,vApp or ResourcePool
 .Example
  Get-MACAddress 00:50:56:a4:04:ce
  Searches the entire vCentre for VMs with the mac address 00:50:56:a4:04:ce
 .Example
  Get-MACAddress 00:50:56:a4:04:ce -Location vApp01
  Searches the vApp called vApp01 for VMs with the mac address 00:50:56:a4:04:ce
 .Link
  http://cloud.kemta.net
 #>
}