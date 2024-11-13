# Collect username and domain from the user 
$username = Read-Host -Prompt "Username" 
$domain = Read-Host -Prompt "Domain" 

# Retrieve user properties from Active Directory 
$user = Get-ADUser -Identity $username -Server $domain -Properties Enabled, LastBadPasswordAttempt, LockedOut, GivenName, "msDS-UserPasswordExpiryTimeComputed", PasswordExpired, extensionAttribute10

# Display last bad password attempt 
if ($user.LastBadPasswordAttempt) { 
Write-Host "`nLast bad password attempt: $($user.LastBadPasswordAttempt)" 
} else { Write-Host "`nNo bad password attempts found." }

# Check if the account is locked, and unlock if necessary 
if ($user.LockedOut) {
Write-Host "Account is Locked Out." 
Unlock-ADAccount -Identity $username -Server $domain 
Write-Host "$($user.GivenName) should be unlocked now.`n" 
} else { Write-Host "Account is not Locked.`n" } 

# Check if the account is enabled 
if ($user.Enabled) { 
Write-Host "Account is Enabled.`n" 
} else { Write-Host "Account is Disabled and will need to be re-enabled.`n" }

# Check if the password is expired or display the expiration date 
if ($user.PasswordExpired) { 
Write-Host "Password is Expired and must be changed.`n" 
} else { 
$passwordExpires = [datetime]::FromFileTime($user."msDS-UserPasswordExpiryTimeComputed") 
Write-Host "Password will expire on $passwordExpires. `n" 
} 

# Pause for user input before exiting 
Read-Host -Prompt "Press Enter to Continue.."
