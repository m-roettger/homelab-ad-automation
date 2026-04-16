$logFile = "C:\Lab\logs\testgroups_log.txt"

Import-Csv "C:\Lab\data\testusers.csv" | ForEach-Object {
    $username = $_.Username
    $department = $_.Department

    try {
        if ($department -eq "IT") {
            Add-ADGroupMember -Identity "GG_IT_Admins" -Members $username -ErrorAction Stop
        }
        elseif ($department -eq "HR") {
            Add-ADGroupMember -Identity "GG_HR_Users" -Members $username -ErrorAction Stop
        }
        elseif ($department -eq "Sales") {
            Add-ADGroupMember -Identity "GG_Sales_Users" -Members $username -ErrorAction Stop
        }

        $message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [INFO] $username → Gruppe basierend auf $department gesetzt"
        Write-Host $message
        Add-Content -Path $logFile -Value $message
    }
    catch {
        $errorMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [FEHLER] Gruppenzuweisung fehlgeschlagen für: $username"
        $errorDetail  = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Grund: $($_.Exception.Message)"

        Write-Host $errorMessage
        Write-Host $errorDetail

        Add-Content -Path $logFile -Value $errorMessage
        Add-Content -Path $logFile -Value $errorDetail
    }
}