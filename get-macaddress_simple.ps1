function Get-MACAddress ($MAC)
    {
    Get-vm | Select Name,Folder,PowerState, @{N="Network";E={$_ | Get-networkAdapter | ? {$_.macaddress -eq $MAC}}} | Where {$_.Network-ne ""}
    }