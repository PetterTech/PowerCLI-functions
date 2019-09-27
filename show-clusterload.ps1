function Show-ClusterLoad {
    [CmdletBinding()] 
        Param (
            [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)][Alias('Name')][string]$Cluster
            )
    begin {
        function Show-PercentageGraph {
         [CmdletBinding()] 
             Param (
             [Parameter(Mandatory=$True)][int]$percent,
             [int]$maxSize=40
             )
        
          if ($percent -gt 100) { $percent = 100 }

          $warningThreshold = 70 # percent
          $alertThreshold = 89 # percent

          [string]$g = [char]9632 #this is the graph character, use [char]9608 for full square character
            if ($percent -lt 10) { write-host -nonewline "0$percent [ " } else { write-host -nonewline "$percent [ " }

            for ($i=1; $i -le ($barValue = ([math]::floor($percent * $maxSize / 100)));$i++) {
                if ($i -le ($warningThreshold * $maxSize / 100)) { write-host -nonewline -foregroundcolor darkgreen $g }
                elseif ($i -le ($alertThreshold * $maxSize / 100)) { write-host -nonewline -foregroundcolor yellow $g }
                else { write-host -nonewline -foregroundcolor red $g }
            }
            for ($i=1; $i -le ($traitValue = $maxSize - $barValue);$i++) { write-host -nonewline "-" }
            write-host -nonewline " ]"
            }
    }
    
    process {
        Write-Host $cluster        
        $VMHosts = Get-VMHost -Location $Cluster -ErrorAction Stop
        foreach ($VMHost in $VMHosts) {
            if ($VMHost -eq $NULL) {
                Write-Host "$($cluster) is empty"
                }
                
            else {
                $object = New-Object PSObject
                Add-Member -InputObject $object NoteProperty VMHost $VMHost.Name
                Add-Member -InputObject $object NoteProperty MemUsage ([math]::round(($VMHost.MemoryUsageGB/$VMHost.MemoryTotalGB)*100))
                Add-Member -InputObject $object NoteProperty CpuUsage ([math]::round(($VMHost.CpuUsageMhz/$VMHost.CpuTotalMhz)*100))
                Write-Host -nonewline `t "$($VMHost.Name): "
                Write-Host -nonewline `t"Cpu: "
                Show-PercentageGraph $object.CpuUsage
                Write-Host -nonewline `t"Mem: "
                Show-PercentageGraph $object.MemUsage
                Write-Host ""
                }
        }
}            
<#
 .Synopsis
  Shows the cpu and mem usage for given cluster
 .Description
  Show a graph per vmhost in the given cluster(s) for cpu and ram
 .Example
  Show-ClusterLoad cluster1
  Show a graph per vmhost in the given cluster(s) for cpu and ram
 .Link
  http://cloud.kemta.net
 #>
}