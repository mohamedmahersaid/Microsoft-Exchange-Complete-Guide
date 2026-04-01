# Get-ExchangeServerHealth.ps1
# PowerShell script to perform health diagnostics on Exchange Server
# Author: mohamedmahersaid
# Date: 2026-04-01

# Load required modules (make sure to run as Administrator)
Import-Module ActiveDirectory
Import-Module ExchangeOnlineManagement

# Define the log file location
$logFile = "ExchangeHealthCheck_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# Function to log messages
function Log-Message {
    param (
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logEntry = "$timestamp [$Level] $Message"
    Add-Content -Path $logFile -Value $logEntry
    Write-Host $logEntry
}

# Function to check if a service is running
function Check-ServiceStatus {
    param (
        [string]$ServiceName
    )
    try {
        $service = Get-Service -Name $ServiceName -ErrorAction Stop
        if ($service.Status -eq 'Running') {
            Log-Message "Service $ServiceName is running." 
        } else {
            Log-Message "Service $ServiceName is NOT running!" "WARNING"
        }
    } catch {
        Log-Message "Failed to get service status for $ServiceName: $_" "ERROR"
    }
}

# Function to check mailbox database status
function Check-MailboxDatabaseStatus {
    try {
        $databases = Get-MailboxDatabase -Status
        foreach ($db in $databases) {
            if ($db.OperationalStatus -eq 'Healthy') {
                Log-Message "Database $($db.Name) is healthy." 
            } else {
                Log-Message "Database $($db.Name) is NOT healthy! Status: $($db.OperationalStatus)" "WARNING"
            }
        }
    } catch {
        Log-Message "Failed to check mailbox database status: $_" "ERROR"
    }
}

# Function to evaluate server performance
function Check-ServerPerformance {
    try {
        $cpuUsage = Get-Counter -Counter '\Processor(_Total)\% Processor Time'
        $memoryUsage = Get-Counter -Counter '\Memory\Available MBytes'
        Log-Message "CPU Usage: $($cpuUsage.CounterSamples[0].CookedValue)%"
        Log-Message "Available Memory: $($memoryUsage.CounterSamples[0].CookedValue) MB"
    } catch {
        Log-Message "Failed to evaluate server performance: $_" "ERROR"
    }
}

# Main script execution
Log-Message "Starting Exchange Server health check..."

# Check vital services
$servicesToCheck = @('MSExchangeIS', 'MSExchangeMDB', 'MSExchangeTransport')
foreach ($service in $servicesToCheck) {
    Check-ServiceStatus -ServiceName $service
}

# Check mailbox database status
Check-MailboxDatabaseStatus

# Check server performance
Check-ServerPerformance

Log-Message "Exchange Server health check completed."