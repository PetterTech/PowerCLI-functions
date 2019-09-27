function Get-ESXiDomainIntegrationStatus
    {
        [CmdletBinding()] 
            Param (
                [Parameter(Position=0)][string]$VMHost = '*'
                  )

    Get-VMHostAuthentication -vmhost $VMHost | Select-Object VMhost,Domain,DomainMembershipStatus
        
<#
 .Synopsis
  Checks the domain integration for given esxi host
 .Description
  Checks the domain integration for given esxi host
 .Parameter VMHost
  The name of the vmhost to check
 .Example
  Get-ESXiDomainIntegrationStatus -VMHost esx01
  Checks the domain integration for esxi host names esx01
 .Link
  http://cloud.kemta.net
 #>
}