# Monitoring Script 

$logFile = "C:\Lab\logs\monitoring.log"

function Write-Log {
    param (
        [string]$message,
        [string]$level
    )

    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "$time - [$level] $message"

    Add-Content -Path $logFile -Value $entry

    if ($level -eq "OK") {
        Write-Host $entry -ForegroundColor Green
    }
    elseif ($level -eq "ERROR") {
        Write-Host $entry -ForegroundColor Red
    }
    else {
        Write-Host $entry -ForegroundColor Yellow
    }
}

Write-Host "=== System Check ==="

# 1. Domain Controller prüfen
$dc = "DC1.corp.lab"

if (Test-Connection -ComputerName $dc -Count 1 -Quiet) {
    Write-Log "Domain Controller erreichbar" "OK"
} else {
    Write-Log "Domain Controller nicht erreichbar" "ERROR"
}

# 2. DNS prüfen
try {
    Resolve-DnsName $dc -ErrorAction Stop | Out-Null
    Write-Log "DNS funktioniert" "OK"
}
catch {
    Write-Log "DNS Problem" "ERROR"
}

# 3. DHCP prüfen
try {
    $dhcp = Get-Service -Name "DHCPServer" -ErrorAction Stop

    if ($dhcp.Status -eq "Running") {
        Write-Log "DHCP läuft" "OK"
    }
    else {
        Write-Log "DHCP läuft nicht" "ERROR"
    }
}
catch {
    Write-Log "DHCP Dienst nicht gefunden" "WARN"
}

# 4. CPU-Auslastung prüfen
try {
    $cpu = Get-CimInstance Win32_Processor
    $cpuValue = [math]::Round(($cpu.LoadPercentage | Measure-Object -Average).Average, 2)

    if ($cpuValue -lt 80) {
        Write-Log "CPU-Auslastung: $cpuValue%" "OK"
    }
    else {
        Write-Log "CPU-Auslastung hoch: $cpuValue%" "WARN"
    }
}
catch {
    Write-Log "CPU-Wert konnte nicht ermittelt werden" "WARN"
}

# 5. RAM prüfen
try {
    $os = Get-CimInstance Win32_OperatingSystem
    $totalMemory = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    $freeMemory = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    $usedMemory = [math]::Round($totalMemory - $freeMemory, 2)

    if ($freeMemory -gt 0.5) {
        Write-Log "RAM genutzt: $usedMemory GB / Frei: $freeMemory GB" "OK"
    }
    else {
        Write-Log "Wenig freier RAM: $freeMemory GB" "WARN"
    }
}
catch {
    Write-Log "RAM-Werte konnten nicht ermittelt werden" "WARN"
}

# 6. Speicherplatz auf C: prüfen
try {
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $freeDisk = [math]::Round($disk.FreeSpace / 1GB, 2)
    $totalDisk = [math]::Round($disk.Size / 1GB, 2)

    if ($freeDisk -gt 5) {
        Write-Log "Freier Speicher auf C:: $freeDisk GB von $totalDisk GB" "OK"
    }
    else {
        Write-Log "Wenig freier Speicher auf C:: $freeDisk GB" "WARN"
    }
}
catch {
    Write-Log "Speicherplatz konnte nicht ermittelt werden" "WARN"
}