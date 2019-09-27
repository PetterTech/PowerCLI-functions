function Get-VMAlarms
{
$VMs = Get-View -ViewType VirtualMachine -Property Name,OverallStatus,TriggeredAlarmstate
$FaultyVMs = $VMs | Where-Object {$_.OverallStatus -ne "Green"}

$progress = 1
$report = @()
if ($FaultyVMs -ne $null) {
    foreach ($FaultyVM in $FaultyVMs) {
            foreach ($TriggeredAlarm in $FaultyVM.TriggeredAlarmstate) {
                Write-Progress -Activity "Gathering alarms" -Status "Working on $($FaultyVM.Name)" -PercentComplete ($progress/$FaultyVMs.count*100) -Id 1 -ErrorAction SilentlyContinue
                $alarmID = $TriggeredAlarm.Alarm.ToString()
                $object = New-Object PSObject
                Add-Member -InputObject $object NoteProperty VM $FaultyVM.Name
                Add-Member -InputObject $object NoteProperty TriggeredAlarms ("$(Get-AlarmDefinition -Id $alarmID)")
                $report += $object
            }
        $progress++
        }
    }
Write-Progress -Activity "Gathering VM alarms" -Status "All done" -Completed -Id 1 -ErrorAction SilentlyContinue

$report | Where-Object {$_.TriggeredAlarms -ne ""}
        
<#
 .Synopsis
  Lists all triggered VM alarms that haven't been acknowledged
 .Description
  Outputs a list of VMs and the unacknowledged alarms they have triggered
 .Example
  Get-VMAlarms
  Outputs a list of VMs and the unacknowledged alarms they have triggered
 .Link
  http://cloud.kemta.net
 #>
}