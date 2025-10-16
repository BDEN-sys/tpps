$symbols = '!@#$%^&*'.ToCharArray()
#Non compatible Powershell 5
#$characterList = 'a'..'z' + 'A'..'Z' + '0'..'9' + $symbols
$minAZ =  [char[]](97..122) 
$majAZ =  [char[]](65..90) 
$characterList = $minAZ + $majAZ + '0'..'9' + $symbols


function GeneratePassword {
    param(
        [Parameter(Mandatory = $false)]
        [ValidateRange(12, 256)]
        [int] 
        $length = 14,
        [Parameter(Mandatory = $false)][switch]$AsSecureString
    )
    
    do {
        $password = ""
        for ($i = 0; $i -lt $length; $i++) {
            $randomIndex = Get-Random -Minimum 0 -Maximum $characterList.Length
            #Non compatible PS7
            #$randomIndex = [System.Security.Cryptography.RandomNumberGenerator]::GetInt32(0, $characterList.Length)
            $password += $characterList[$randomIndex]
        }

        [int]$hasLowerChar = $password -cmatch '[a-z]'
        [int]$hasUpperChar = $password -cmatch '[A-Z]'
        [int]$hasDigit = $password -match '[0-9]'
        [int]$hasSymbol = $password.IndexOfAny($symbols) -ne -1

    }
    until (($hasLowerChar + $hasUpperChar + $hasDigit + $hasSymbol) -ge 4)
    
    if ($AsSecureString) {
        $password = $password | ConvertTo-SecureString -AsPlainText
    } 
    $password
}