function Set-Mysql {
Param (
    [Parameter(Mandatory=$true,  Position=0)]
    [String]$server,
    [Parameter(Mandatory=$true,  Position=1)]
    [string]$port,
    [Parameter(Mandatory=$true,  Position=2)]
    [string]$user,
    [Parameter(Mandatory=$false,  Position=3)]
    [string]$password,
    [Parameter(Mandatory=$false,  Position=4)]
    [string]$bdd,
    [Parameter(Mandatory=$true,  Position=5)]
    [string]$requete,
    [Parameter(Mandatory=$true,  Position=6)]
    [string]$dll)


$dll=(get-item $dll).FullName
try {[void][System.Reflection.Assembly]::LoadFrom($dll) } catch {Write-Host "Impossible de charger la DLL $dll " -ForegroundColor red;break}

# Création de l'instance, connexion à la base de données
#write-host "server=$server;port=$port;uid=$user;pwd=$password;database=$bdd;Pooling=False"
if ($password) {$cnx ="server=$server;port=$port;uid=$user;pwd=$password;database=$bdd;Pooling=False"}
else {$cnx ="server=$server;port=$port;uid=$user;Pooling=False"}
$mysql = New-Object MySql.Data.MySqlClient.MySqlConnection("$cnx")


try {
$mysql.Open()


$ResultSql = New-Object Mysql.Data.MysqlClient.MySqlCommand($requete,$mysql)
$ResultSql.ExecuteNonQuery()

$mysql.Close()}
catch {
Write-Host "Echec de la connexion : Détails de l'erreur ci-dessous :" -ForegroundColor Red
Write-Host "$($Error[0])" -ForegroundColor Red;break
 }

}
