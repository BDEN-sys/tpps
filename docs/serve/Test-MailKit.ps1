Import-Module Send-MailKitMessage

#Serveur SMTP
$SMTPServer = "smtp.contoso.com"

#Port SMTP (par exemple 25, 465 ou 587)
$SMTPPort = 587

#Expéditeur
$SMTPSender = [MimeKit.MailboxAddress]"sender@contoso.com"

# Destinataire(s)
$SMTPRecipientList = [MimeKit.InternetAddressList]::new()
$SMTPRecipientList.Add([MimeKit.InternetAddress]"recipient@contoso.com")

#Identifiants SMTP 
$SMTPCredentials = Get-Credential -UserName "Username" -Message "Veuillez saisir le mot de Passe"

# Objet du mail 
$EmailSubject = "E-mail envoyé avec Send-MailKitMessage"

# Corps du mail
$EmailBody = "<h1>Démo Send-MailKitMessage</h1>"

# Envoyer l'e-mail
Send-MailKitMessage -SMTPServer $SMTPServer -Port $SMTPPort -From $SMTPSender -RecipientList $SMTPRecipientList `
                    -Subject $EmailSubject -HTMLBody $EmailBody -Credential $SMTPCredentials -UseSecureConnectionIfAvailable