function Get-VMHostAlarms
{
$VMHosts = Get-View -ViewType HostSystem -Property Name,OverallStatus,TriggeredAlarmstate
$FaultyVMHosts = $VMHosts | Where-Object {$_.TriggeredAlarmState -ne "{}"}

$progress = 1
$report = @()
if ($FaultyVMHosts -ne $null) {
    foreach ($FaultyVMHost in $FaultyVMHosts) {
        foreach ($TriggeredAlarm in $FaultyVMHost.TriggeredAlarmstate) {
            Write-Progress -Activity "Gathering alarms" -Status "Working on $($FaultyVMHost.Name)" -PercentComplete ($progress/$FaultyVMHosts.count*100) -Id 1 -ErrorAction SilentlyContinue
            $alarmID = $TriggeredAlarm.Alarm.ToString()
            $object = New-Object PSObject
            Add-Member -InputObject $object NoteProperty VMHost $FaultyVMHost.Name
            Add-Member -InputObject $object NoteProperty TriggeredAlarms ("$(Get-AlarmDefinition -Id $alarmID)")
            $report += $object
            }
        $progress++
        }
    }
Write-Progress -Activity "Gathering alarms" -Status "All done" -Completed -Id 1 -ErrorAction SilentlyContinue

$report | Where-Object {$_.TriggeredAlarms -ne ""}
        
<#
 .Synopsis
  Lists all triggered VMHost alarms that haven't been acknowledged
 .Description
  Outputs a list of VMHosts and the unacknowledged alarms they have triggered
 .Example
  Get-VMHostAlarms
  Outputs a list of VMHosts and the unacknowledged alarms they have triggered
 .Link
  http://cloud.kemta.net
 #>
}