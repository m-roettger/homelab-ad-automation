$logFile = "C:\Lab\logs\testimport_log.txt"

Import-Csv "C:\Lab\data\testusers.csv" | ForEach-Object {

    $firstName = $_.FirstName
    $lastName = $_.LastName
    $department = $_.Department
    $username = $_.Username

    $displayName = "$firstName $lastName"
    $upn = "$username@corp.lab"
    $password = ConvertTo-SecureString "Password123!" -AsPlainText -Force
    $ouPath = "OU=$department,OU=CorpUsers_TEST,DC=corp,DC=lab"

    $existingUser = Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue

    if ($existingUser) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $message = "$timestamp [INFO] Benutzer existiert bereits: $displayName ($username)"

        Write-Host $message
        Add-Content -Path $logFile -Value $message
    }
    else {
        try {
            New-ADUser `
                -Name $displayName `
                -GivenName $firstName `
                -Surname $lastName `
                -SamAccountName $username `
                -UserPrincipalName $upn `
                -Path $ouPath `
                -AccountPassword $password `
                -Enabled $true `
                -ErrorAction Stop

            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $message = "$timestamp [OK] Benutzer erstellt: $displayName ($username) in $department"

            Write-Host $message
            Add-Content -Path $logFile -Value $message
        }
        catch {
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $errorMessage = "$timestamp [FEHLER] Benutzer $displayName ($username) konnte nicht erstellt werden"
            $errorDetail = "$timestamp Grund: $($_.Exception.Message)"

            Write-Host $errorMessage
            Write-Host $errorDetail

            Add-Content -Path $logFile -Value $errorMessage
            Add-Content -Path $logFile -Value $errorDetail
        }
    }
}