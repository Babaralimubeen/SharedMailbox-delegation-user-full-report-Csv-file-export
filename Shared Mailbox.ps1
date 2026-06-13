# Shared Mailbox
$mail = "Digi_ME@DigitalandProspects.onmicrosoft.com"

# Collect Full Access permissions
$FullAccess = Get-MailboxPermission $mail |
Where-Object {
    $_.AccessRights -contains "FullAccess" -and
    $_.User -notlike "NT AUTHORITY*"
} |
Select-Object @{
        Name = "Mailbox"
        Expression = { $mail }
    }, @{
        Name = "AccessType"
        Expression = { "FullAccess" }
    }, @{
        Name = "User"
        Expression = { $_.User }
    }

# Collect Send As permissions
$SendAs = Get-RecipientPermission $mail |
Where-Object {
    $_.AccessRights -contains "SendAs" -and
    $_.Trustee -notlike "NT AUTHORITY*"
} |
Select-Object @{
        Name = "Mailbox"
        Expression = { $mail }
    }, @{
        Name = "AccessType"
        Expression = { "SendAs" }
    }, @{
        Name = "User"
        Expression = { $_.Trustee }
    }

# Collect Send on Behalf permissions
$SendOnBehalf = (Get-Mailbox $mail).GrantSendOnBehalfTo |
Select-Object @{
        Name = "Mailbox"
        Expression = { $mail }
    }, @{
        Name = "AccessType"
        Expression = { "SendOnBehalf" }
    }, @{
        Name = "User"
        Expression = { $_ }
    }

# Combine all results
$Results = $FullAccess + $SendAs + $SendOnBehalf

# Export to CSV
$OutputFile = "$env:USERPROFILE\Documents\SharedMailbox_Delegation.csv"

$Results | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host "Report exported successfully to:"
Write-Host $OutputFile -ForegroundColor Green