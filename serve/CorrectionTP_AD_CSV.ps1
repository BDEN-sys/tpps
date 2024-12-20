. C:\scripts\Remove-Diacritics.ps1

$csv = Import-Csv C:\scripts\BaseDonneesExempleCsv.csv -Delimiter ';' -Encoding UTF8
$ou = 'OU=Annuaire,DC=cesi,DC=lan'
$csv | ForEach-Object {

    $prenom = $_.givenname
    $nom = $_.surname
    $name = "$nom $prenom"
    $city = $_.city
    $login = Remove-Diacritics "$prenom.$nom".tolower()
    $mail = $login + '@cesi.lan'
    if ($login.Length -gt 20) {$login = $login.Substring(0,20)}
    $password = Get-Random -Minimum 1000000 -Maximum 99999999
    $password = '@!a' + $password
    new-aduser -name $name -SamAccountName $login -UserPrincipalName $mail -GivenName $prenom -Surname $nom -path $ou -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -Enabled 1 -City $city

}