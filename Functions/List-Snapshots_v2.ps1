function List-Snapshots {
$collection = @()
Write-Progress -Activity "Finding snapshots..." -Status "This will tak a while, please wait" -PercentComplete 20 -Id 1
$snapshots = Get-Snapshot -vm * 
Write-Progress -Activity "Finding snapshots..." -Status "Found all snapshots" -Completed -Id 1

$progress = 1
foreach ($snapshot in $snapshots) {
    Get-VIEvent -Start ($snapshot.Created).addminutes(-5) -Finish ($snapshot.Created).addminutes(5) -Entity $Snapshot.vm.name -Types info -maxsamples 20 | Where-Object {$_.FullFormattedMessage -like "*Create virtual machine snapshot*"} | ForEach-Object {
            Write-Progress -Activity "Finding snapshots" -Status "Working on $($_.Vm.Name)" -PercentComplete ($progress/$snapshots.count*100) -Id 1
            $object = New-Object PSObject
            Add-Member -InputObject $object NoteProperty VM $_.Vm.Name
            Add-Member -InputObject $object NoteProperty User $_.Username
            Add-Member -InputObject $object NoteProperty "Snapshot name" $Snapshot.Name
            Add-Member -InputObject $object NoteProperty "Snapshot description" $Snapshot.Description
            Add-Member -InputObject $object NoteProperty Size ([math]::Round($Snapshot.SizeGB))
            Add-Member -InputObject $object NoteProperty Time $_.CreatedTime
            $collection += $object
            }
    $progress++
    }

Write-Progress -Activity "Finding snapshots" -Status "All done" -Completed -Id 1
$collection
        
<#
 .Synopsis
  Lists snapshots in vCenter
 .Description
  List all snapshots in the entire vCenter
 .Example
  List-Snapshots
  Lists all snapshots in the vCenter
 .Link
  http://cloud.kemta.net
 #>
}
