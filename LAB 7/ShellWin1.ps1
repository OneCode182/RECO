ShellWin.ps1

function Show-NetworkMenu {
    Clear-Host
    Write-Host "======= NETWORK TOOLS MENU ======="
    Write-Host "1. Show network interfaces (Get-NetIPConfiguration)"
    Write-Host "2. Show routing table (Get-NetRoute)"
    Write-Host "3. Show active TCP connections (Get-NetTCPConnection)"
    Write-Host "4. Show network adapter statistics (Get-NetAdapterStatistics)"
    Write-Host "5. Show IP address configuration (ipconfig)"
    Write-Host "6. Check if a port is open and which process is using it"
    Write-Host "7. Exit"
    Write-Host "=================================="
}

function Run-NetworkCommand {
    param ([int]$option)

    switch ($option) {
        1 {
            Write-Host "`n--- Network Interfaces ---"
            Get-NetIPConfiguration | Format-Table
        }
        2 {
            Write-Host "`n--- Routing Table ---"
            Get-NetRoute | Format-Table
        }
        3 {
            Write-Host "`n--- Active TCP Connections ---"
            Get-NetTCPConnection | Format-Table
        }
        4 {
            Write-Host "`n--- Network Adapter Statistics ---"
            Get-NetAdapterStatistics | Format-Table
        }
        5 {
            Write-Host "`n--- IP Configuration ---"
            ipconfig /all
        }
        6 {
            $port = Read-Host "Enter the port number to check"
            Check-Port -Port $port
        }
        7 {
            Write-Host "Exiting..."
            Exit
        }
        default {
            Write-Host "Invalid option. Try again."
        }
    }
}

function Check-Port {
    param ([int]$Port)

    $connection = Get-NetTCPConnection -State Listen | Where-Object { $_.LocalPort -eq $Port }

    if ($connection) {
        Write-Host "`nYES: Port $Port is open."
        $pid = $connection.OwningProcess
        $process = Get-Process -Id $pid -ErrorAction SilentlyContinue
        if ($process) {
            Write-Host "Service/Process using port: $($process.ProcessName)"
        } else {
            Write-Host "Could not identify the process."
        }
    } else {
        Write-Host "`nNO: Port $Port is not open."
    }
}

# Main loop
do {
    Show-NetworkMenu
    $choice = Read-Host "`nSelect an option (1-7)"
    Run-NetworkCommand -option $choice
    Write-Host "`nPress any key to continue..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
} while ($true)
