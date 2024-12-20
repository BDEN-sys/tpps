#Dot sourcing des fonction utilisées dans le script
. C:\TP\fonctions\Remove-Diacritics.ps1
. C:\TP\fonctions\Get-Mysql.ps1

#Ou de destination des utilisateurs
$ou = 'OU=Annuaire,DC=cesi,DC=lan'

#Dossier réseau répertoires utilisateurs
$path_homedrive = '\\dc1\home\'
$letter_homedrive = 'U:'

#Récupération des utilisateurs à créer depuis Mysql
$result_sql = Get-Mysql -server localhost -port 3306 -user root -password root -bdd rh -requete 'select * from users;'

#Parcours des utilisateurs récupérés
$result_sql | ForEach-Object {

    $prenom = $_.givenname
    $nom = $_.surname
    $name = "$nom $prenom"
    $city = $_.city

    #Suppression des accents et passage en minuscule
    $login = Remove-Diacritics "$prenom.$nom".tolower()
    $mail = $login + '@cesi.lan'
    $homepath = $path_homedrive + $login

    #Si login > à 20, extraction de 20 caractères depuis le début
    if ($login.Length -gt 20) {$login = $login.Substring(0,20)}

    #Génération du mot de passe 
    $password = Get-Random -Minimum 1000000 -Maximum 99999999
    $password = "@A!$password"

    #Création de l'utilisateur
    new-aduser -name $name -SamAccountName $login -UserPrincipalName $mail -GivenName $prenom -Surname $nom -path $ou -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -Enabled 1 -City $city -HomeDirectory $homepath -HomeDrive $letter_homedrive
    
    #Création du lecteur personnel et ajout des droits
    C:\tp\scripts\SetFolderPermission.ps1 -Path $homepath -Access CESI\$login -Permission FullControl
    
    #Génération d'un PDF contenant les informations sur l'utilisateur
    C:\TP\scripts\Fill-PDF.ps1 -formulaire C:\TP\formulaire.pdf -path C:\TP\PDF -dll C:\TP\bin\itextsharp.dll -displayname $name -login $login -password $password
}

#Simulation envoi de message vers l'utilisateur avec PDF en PJ
$cred = Get-Credential -UserName baptiste.deneuve@outlook.com -Message 'Log MSG'
Send-MailMessage -Attachments C:\TP\PDF\alain.sapience.pdf -Body 'Bonjour, Bienvenue' -From  baptiste.deneuve@outlook.com  -To baptiste.deneuve@outlook.com -SmtpServer smtp.office365.com -Credential $cred -UseSsl -Port 587