
# Function to display running processes
function Show-Processes {
    Write-Host "Proceso(s) ejecutandose:"
    $processes = Get-Process | Group-Object -Property ProcessName
    $processes | ForEach-Object {
        $processName = $_.Name
        $count = $_.Count
        $sampleProcess = $_.Group | Select-Object -First 1
        $cpuUsage = [math]::round($sampleProcess.CPU, 2)
        $memoryUsage = [math]::round($sampleProcess.WorkingSet / 1MB, 2)
        
        # Create custom object to display in table format
        [PSCustomObject]@{
            ProcessName    = "($count) $processName"  # Reordered to show count first
            CPUUsage       = "$cpuUsage%"
            MemoryUsageMB  = "$memoryUsage MB"
        }
    } | Format-Table -AutoSize
}



# Function to search for a process by name
function Search-Process {
    $processName = Read-Host "Enter the name of the process to search for"
    $process = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($process) {
        $process | Select-Object `
        Id, `
        Name, `
        @{Name="Handles";Expression={$_.Handles}}, `
        @{Name="NPM (KB)";Expression={[math]::round($_.NonPagedSystemMemorySize / 1KB, 2)}}, `
        @{Name="PM (KB)";Expression={[math]::round($_.PagedMemorySize / 1KB, 2)}}, `
        @{Name="Memory Usage (MB)";Expression={[math]::round($_.WorkingSet / 1MB, 2)}}, `
        @{Name="CPU Usage(%)";Expression={[math]::round($_.CPU, 2)}} | `
        Format-Table -AutoSize

        #$process | Format-Table -AutoSize

    } else {
        Write-Host "ERROR | No process found with the name: $processName" -ForegroundColor Red
    }
}


# Function to kill a running process
function Kill-Process {
    $processId = Read-Host "Enter the process ID to kill"
    try {
        Stop-Process -Id $processId -Force
        Write-Host "Process with ID $processId has been terminated."
    }
    catch {
        Write-Host "ERROR | Failed to terminate process with ID '$processId'" -ForegroundColor Red
    }
}

# Function to Restart a running process
function Restart-Process {
    $processId = Read-Host "Enter the process ID to restart"

    try {
        # Get process information
        $process = Get-Process -Id $processId -ErrorAction Stop
        $processName = $process.Name
        $processPath = $process.Path  # Get the full path of the executable

        Stop-Process -Id $processId -Force -ErrorAction Stop  # Stop the process
        Start-Sleep -Seconds 2  # Wait a moment before restarting

        # Check if the process path was retrieved
        if ($processPath) {  # Start process from its full path
            Start-Process -FilePath $processPath  
        } else {  # Try starting it by name if no path is available
            Start-Process -Name $processName  
        }

        Write-Host "Process $processName with ID $processId has been restarted."
    }
    catch {
        Write-Host "ERROR | Failed to restart process with ID '$processId'" -ForegroundColor Red
    }
}




# Main menu function
function Show-Menu {
    do {
        Clear-Host
        Write-Host "====================================="
        Write-Host "      Process PowerShell Script      "
        Write-Host "-------------------------------------"
        Write-Host "   1. Show running processes"
        Write-Host "   2. Search for a process"
        Write-Host "   3. Kill a running process"
        Write-Host "   4. Restart a running process"
        Write-Host "   5. Exit"
        Write-Host "====================================="

        $selection = Read-Host "Enter the number of your choice"

        switch ($selection) {
            1 { Show-Processes }
            2 { Search-Process }
            3 { Kill-Process }
            4 { Restart-Process }
            5 { Write-Host "Exiting..."; exit }
            default { Write-Host "Invalid selection. Please try again." }
        }

        Read-Host "Press Enter to return to the menu"
    } while ($true)
}

# Start the menu
Show-Menu