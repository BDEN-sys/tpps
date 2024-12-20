function Get-Mysql {
Param (
    [Parameter(Mandatory=$true,  Position=0)]
    [String]$server,
    [Parameter(Mandatory=$true,  Position=1)]
    [string]$port,
    [Parameter(Mandatory=$true,  Position=2)]
    [string]$user,
    [Parameter(Mandatory=$true,  Position=3)]
    [string]$password,
    [Parameter(Mandatory=$true,  Position=4)]
    [string]$bdd,
    [Parameter(Mandatory=$true,  Position=5)]
    [string]$requete
    )
[void] [system.reflection.Assembly]::LoadWithPartialName("MySql.Data")

# Création de l'instance, connexion à la base de données
#write-host "server=$server;port=$port;uid=$user;pwd=$password;database=$bdd;Pooling=False"
$mysql = New-Object MySql.Data.MySqlClient.MySqlConnection("server=$server;port=$port;uid=$user;pwd=$password;database=$bdd;Pooling=False")
$mysql.Open()


$ResultSql = New-Object Mysql.Data.MysqlClient.MySqlCommand($requete,$mysql)

# Création du data adapter et du dataset qui permettront de traiter les données
$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($ResultSql)
$dataSet = New-Object System.Data.DataSet
$dataAdapter.Fill($dataSet,"table")
$dataset.Tables["table"].Rows
$mysql.Close()
}