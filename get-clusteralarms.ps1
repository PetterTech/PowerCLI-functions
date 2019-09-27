function Get-ClusterAlarms
{
$Clusters = Get-View -ViewType ComputeResource -Property Name,OverallStatus,TriggeredAlarmstate
$FaultyClusters = $Clusters | Where-Object {$_.TriggeredAlarmState -ne "{}"}
$report = @()
$progress = 1
if ($FaultyClusters -ne $NULL) {
    foreach ($FaultyCluster in $FaultyClusters) {
        foreach ($TriggeredAlarm in $FaultyCluster.TriggeredAlarmstate) {
            Write-Progress -Activity "Gathering alarms" -Status "Working on $($FaultyCluster.Name)" -PercentComplete ($progress/$FaultyClusters.count*100) -Id 1 -ErrorAction SilentlyContinue
            $entity = $TriggeredAlarm.Entity.ToString()
            $alarmID = $TriggeredAlarm.Alarm.ToString()
            if ($entity -like "ClusterComputeResource-*") {
                $entityName = $FaultyCluster.Name
                $type = "Cluster"
                }
            elseif ($entity -like "HostSystem-host*") {
                $entityName = (Get-View -ViewType HostSystem -Property Name | Where-Object {$_.MoRef -eq $entity}).Name
                $type = "VMHost"
                }
            elseif ($entity -like "VirtualMachine-vm*") {
                $entityName = (Get-View -ViewType VirtualMachine -Property Name | Where-Object {$_.MoRef -eq $entity}).Name
                $type = "VM"
                }
            $object = New-Object PSObject
            Add-Member -InputObject $object NoteProperty Cluster $FaultyCluster.Name
            Add-Member -InputObject $object NoteProperty Entity $entityName
            Add-Member -InputObject $object NoteProperty Type $type
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