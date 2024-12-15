function Save-Credentials {
    Param (
    [Parameter(Mandatory=$true,  Position=0)]
    [String]$username,
    [Parameter(Mandatory=$true,  Position=1)]
    [String]$path_credential,
    [Parameter(Mandatory=$true,  Position=2)]
    [String]$message)

#Vérifie si le fichier contenant le mot de passe chiffré est présent
    if (!(Test-Path $path_credential)) { # Non présent : demande le mot de passe et l'enregistre dans un fichier chiffré.
        $null = New-Item $path_credential -Force -ItemType file
        $credential = Get-Credential -UserName $username -Message $message
        $credential.Password | ConvertFrom-SecureString | Set-Content $path_credential
        $credential = $null
        }     
   #Utilise les credentials stocké dans le fichier chiffré.
    $password = Get-Content $path_credential| ConvertTo-SecureString 
    $credential = New-Object System.Management.Automation.PsCredential($username,$password)
    $credential
}
