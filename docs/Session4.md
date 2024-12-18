# Session 4

## Utilisation de WMI/CIM

### Prérequis

* 2 machines Windows virtuelles nommées Client1, Client2 (Windows 10 ou 11)

* Configurer les deux VMs Client 1 & 2 sur le switch virtuel de la VM DC1

* Configurer les IPs 192.168.10.21/24 et 192.168.10.22/24 sur les VMs client1 et client2 respectivement.

* Intégrer les VMs client1 et client2 au domaine CESI.LAN

* Sur le VMs client1 et client2, lancer la commande suivante dans une console Powershell : ```Enable-PSRemoting```

<!--
* Sur chaque VM, lancer la commande suivante pour autoriser WMI et DCOM distant :

   ```netsh advfirewall firewall set rule group="Infrastructure de gestion Windows (WMI)" new enable=yes```
-->
### WMI/CIM (Windows Management Instrumentation)

* Depuis le DC, lancer une console powershell
    * Tester la connectivité WSMAN avec la commande suivante :

      ```powershell
      Test-WSMan client1 #Puis client2

      #Si la connection WSMan fonctionne, le lignes suivantes seront affichées
      wsmid           : http://schemas.dmtf.org/wbem/wsman/identity/1/wsmanidentity.xsd
      ProtocolVersion : http://schemas.dmtf.org/wbem/wsman/1/wsman.xsd
      ProductVendor   : Microsoft Corporation
      ProductVersion  : OS: 0.0.0 SP: 0.0 Stack: 3.0
      ```

    * Obtenir les information de BIOS

      ```powershell
      $CimSession = New-CimSession -ComputerName Client1 -Credential (Get-Credential)
      Get-CimInstance -CimSession $CimSession -ClassName Win32_Bios
      ```
      
* Adapter la commande précédente pour :

    * interroger toutes les deux VMs (Client1 et 2)
    * détecter le système d’exploitation
    * afficher, le nom de la machine, le nom du système d’exploitation, sa version et son architecture (x64 ou x86).

* À l’aide de la classe WMI **win32_LogicalDisk**, afficher la taille et l’espace libre des partitions.

* Affiner la sortie de la commande précédente pour afficher en tableau les colonnes suivantes : Name, Espace Libre (en GB) et taille (en GB). Garder ce script pour la prochaine partie.

   ```Conseil : utiliser la syntaxe :```
   ```@{label = <string> ; expression = {<script>}}```

## Envoi de message et HTML

### Send-Mailmessage

* À l’aide de la commande **Send-Mailmessage**, envoyez-vous un mail de test (adaptez les paramètres de la commande en fonction de votre fournisseur de messagerie : SSL ?, Port 25 ou 587…)

* À l’aide du script de la dernière partie (concernant Win32_LogicalDisk), envoyer la liste des partitions de vos 2 VMs à votre adresse mail.

* Répétez l’opération précédente en convertissant le retour du script en HTML.

### Module MailKit

L'usage de la commande **Send-Mailmessage** est déprécié, dans les futures versions de Powershell, celle-ci ne sera plus prise en charge. En 2024, il n'y pas de commande native de remplacement. Microsoft recommande l'usage du Mailkit ```https://github.com/jstedfast/MailKit```

* Installer Mailkit sur le serveur DC1 à l'aide la commande ```Install-Module -Name "Send-MailKitMessage" -Scope AllUsers```

* Modifier le script [Test-MailKit.ps1](./serve/Test-MailKit.ps1) pour envoyer un mail