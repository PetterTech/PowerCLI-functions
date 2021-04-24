function Get-ISOMounts
{
    [CmdletBinding()] 
        Param (
            [switch]$Dismount
              )
        $VMs = Get-View -ViewType virtualmachine -Property name,Config.Hardware.Device
        $VMsWithISO = @()
        $progress = 1
        foreach ($VM in $VMs) {
            Write-Progress -Activity "Checking if VMs have ISOs mounted" -Status "Working on $($VM.name)" -PercentComplete ($progress/$VMs.count*100) -Id 1 -ErrorAction SilentlyContinue
            if (($VM | select -ExpandProperty config | select -ExpandProperty hardware | select -ExpandProperty device | select -ExpandProperty deviceinfo | where {$_.Summary -like "ISO*"}) -ne $NULL) {
                $object = New-Object PSObject
                Add-Member -InputObject $object NoteProperty VM $VM.Name
                Add-Member -InputObject $object NoteProperty "ISO mounted" (($VM | select -ExpandProperty config | select -ExpandProperty hardware | select -ExpandProperty device | select -ExpandProperty deviceinfo | where {$_.Summary -like "ISO*"}).Summary).Substring(4)
                $VMsWithISO += $object
                $object
            $progress++
            }
        }
        Write-Progress -Activity "Checking if VMs have ISOs mounted" -Status "All done" -Completed -Id 1 -ErrorAction SilentlyContinue
        
        if ($Dismount)
            {
            Write-Verbose "Starting to dismount ISOs"
            $progress = 1
            foreach ($VM in $VMsWithISO) {
                Write-Progress -Activity "Dismounting ISOs" -Status "Working on $($VM.vm)" -PercentComplete ($progress/$VMsWithISO.count*100) -Id 1 -ErrorAction SilentlyContinue
                Get-CDDrive -VM $VM.vm | Set-CDDrive -NoMedia -Confirm:$False | out-null
                }
            Write-Progress -Activity "Dismounting ISOs" -Status "All done" -Completed -Id 1 -ErrorAction SilentlyContinue
            $progress++
            }

<#
 .Synopsis
  Lists all VMs with ISOs mounted, can also dismount them
 .Description
  Lists all VMs with ISOs mounted. If the switch -Dismount is present all mounted ISOs will be dismounted
 .Example
  Get-ISOMounts
  Lists all mounted ISOs in the vCenter
 .Example
  Get-Snapshots -Dismount
  Lists all mounted ISOs on VMs in the vCenter and then dismounts them
 .Link
  http://cloud.kemta.net
 #>
}