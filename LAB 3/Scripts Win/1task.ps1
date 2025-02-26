<#
    PowerShell script to schedule a periodic task

    Description:
    This script allows scheduling a task to run periodically on the system.
    The user specifies the task name, the script or application to execute,
    and the execution schedule.

    Usage Examples:
    Schedule a task to run daily at 14:30:
    - PS> .\schedule-task.ps1 -TaskName "BackupTask" -ScriptPath "C:\Scripts\backup.ps1" -Schedule "14:30:00"

    Schedule a task to run every 30 minutes:
    - PS> .\schedule-task.ps1 -TaskName "SyncTask" -ScriptPath "C:\Tools\sync.exe" -Schedule "30"

    Notes:
    - The schedule parameter accepts two formats:
        * "HH:mm:ss" → Runs daily at a specific time.
        * A number (e.g., "30") → Runs at an interval (in minutes).
    - If a task with the same name exists, it will be removed before registering a new one.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$TaskName,   # Unique name for the scheduled task
    
    [Parameter(Mandatory=$true)]
    [string]$ScriptPath, # Full path of the script or application to execute
    
    [Parameter(Mandatory=$true)]
    [string]$Schedule    # Cron-like format "HH:mm:ss" or interval in minutes
)

# Check if the task already exists
if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
    Write-Host "The task '$TaskName' already exists. Removing it..."
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

# Create the trigger based on time format
if ($Schedule -match "^\d{2}:\d{2}:\d{2}$") {
    $Trigger = New-ScheduledTaskTrigger -Daily -At $Schedule
} elseif ($Schedule -match "^\d+$") {
    $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes([int]$Schedule) -RepetitionInterval (New-TimeSpan -Minutes [int]$Schedule)
} else {
    Write-Host "Invalid schedule format. Use 'HH:mm:ss' for daily execution or a number for interval in minutes." -ForegroundColor Red
    exit 1
}

# Define the action
$Action = New-ScheduledTaskAction -Execute $ScriptPath

# Register the task
Register-ScheduledTask -TaskName $TaskName -Trigger $Trigger -Action $Action -Description "Scheduled task for $ScriptPath"

Write-Host "Task '$TaskName' has been successfully scheduled."
