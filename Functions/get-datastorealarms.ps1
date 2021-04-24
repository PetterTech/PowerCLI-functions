function Get-DatastoreAlarms
{
$Datastores = Get-View -ViewType Datastore -Property Name,OverallStatus,TriggeredAlarmstate
$FaultyDatastores = $Datastores | Where-Object {$_.TriggeredAlarmState -ne "{}"}

$progress = 1
$report = @()
if ($FaultyDatastores -ne $null) {
    foreach ($FaultyDatastore in $FaultyDatastores) {
        foreach ($TriggeredAlarm in $FaultyDatastore.TriggeredAlarmstate) {
            Write-Progress -Activity "Gathering alarms" -Status "Working on $($FaultyDatastore.Name)" -PercentComplete ($progress/$FaultyDatastores.count*100) -Id 1 -ErrorAction SilentlyContinue
            $entity = $TriggeredAlarm.Entity.ToString()
            $alarmID = $TriggeredAlarm.Alarm.ToString()
            $object = New-Object PSObject
            Add-Member -InputObject $object NoteProperty Datastore $FaultyDatastore.Name
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
  Lists all triggered Cluster alarms that haven't been acknowledged
 .Description
  Outputs a list of Cluster and the unacknowledged alarms they have triggered
 .Example
  Get-VMHostAlarms
  Outputs a list of Cluster and the unacknowledged alarms they have triggered
 .Link
  http://cloud.kemta.net
 #>
}