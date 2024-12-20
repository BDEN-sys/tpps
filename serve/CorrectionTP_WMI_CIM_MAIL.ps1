#TP CIM/WMI

#Session CIM distante (WSMAN) 
$creds = Get-Credential -UserName 'CESI\administrateur' -Message 'Identifiant'
$CimSession = New-CimSession -ComputerName Client1,Client2 -Credential $creds 

Get-CimInstance -CimSession $CimSession -ClassName Win32_Bios

Get-CimInstance -CimSession $CimSession -ClassName Win32_OperatingSystem | Format-list PSComputername,caption,version,osarchitecture

$result = Get-CimInstance -CimSession $CimSession -ClassName Win32_logicaldisk | 
        Select-Object name, 
                      @{n="Espace libre";e={$_.freespace/1GB}},
                      @{n="Taille";e={$_.size/1GB}}

#Conversion HTML pour envoi dans le corps d'un mail
$html_body = $result | ConvertTo-Html -PreContent '<h2>Rapport taille des disques</h2>'


#Envoi de mail 

#Avec Send-MailMessage, déprécié avec Powershell 7.
#Send-MailMessage -SmtpServer smtp.domain.fr -UseSsl -Port 25 -From reporttp@domain.fr -to recipient@univ-rouen.fr -Body $html_body -BodyAsHtml -Subject "Test TP" -Encoding UTF8

#Utilisation de MailKit - Module Externe

#Installation Module à faire une fois
#Install-Module -Name "Send-MailKitMessage" -Scope AllUsers 

Import-Module Send-MailKitMessage

$SMTPServer = "smtp.domain.fr"
$SMTPPort = 587 #Port SMTP (par exemple 25, 465 ou 587)
$SMTPSender = [MimeKit.MailboxAddress]"reporttp@domain.fr" #Expéditeur

# Destinataire(s)
$SMTPRecipientList = [MimeKit.InternetAddressList]::new()
$SMTPRecipientList.Add([MimeKit.InternetAddress]"sender@domain.fr")

#Identifiants SMTP 
$SMTPCredentials = Get-Credential -UserName "username" -Message "Veuillez saisir le mot de Passe"

# Objet du mail 
$EmailSubject = "E-mail envoyé avec Send-MailKitMessage"

# Corps du mail
$EmailBody = $html_body | Out-String

# Envoyer l'e-mail
Send-MailKitMessage -SMTPServer $SMTPServer -Port $SMTPPort -From $SMTPSender -RecipientList $SMTPRecipientList `
                    -Subject $EmailSubject -HTMLBody $EmailBody -Credential $SMTPCredentials -UseSecureConnectionIfAvailable