$password = Read-Host "Bitte Standardpasswort eingeben" -AsSecureString
$logFile = "C:\Lab\logs\testpwchange_log.txt"

Import-Csv "C:\Lab\data\testusers.csv" | ForEach-Object {

    $firstName = $_.FirstName
    $lastName = $_.LastName
    $username = $_.Username

    $displayName = "$firstName $lastName"

    try {
        Set-ADAccountPassword `
            -Identity $username `
            -NewPassword $password `
            -Reset `
            -ErrorAction Stop

        Set-ADUser `
            -Identity $username `
            -ChangePasswordAtLogon $true `
            -ErrorAction Stop

        Write-Host "[OK] Passwort gesetzt für: $displayName ($username)"
    }
    catch {
        Write-Host "[FEHLER] Passwort konnte nicht gesetzt werden für: $displayName ($username)"
        Write-Host "         Grund: $($_.Exception.Message)"
    }
}