# Session 4

## Utilisation de WMI/CIM

### Prérequis

* 2 machines Windows virtuelles nommées Client1, Client2 jointes au domaine CESI.LAN
<!--
* Sur chaque VM, lancer la commande suivante pour autoriser WMI et DCOM distant :

   ```netsh advfirewall firewall set rule group="Infrastructure de gestion Windows (WMI)" new enable=yes```
-->
### WMI/CIM (Windows Management Instrumentation)

* Depuis le DC, lancer une console powershell, puis les commandes suivantes :

   ```powershell
   $CimSession = New-CimSession -ComputerName Client1 -Credential (Get-Credential)
   Get-CimInstance -CimSession $CimSession -ClassName Win32_Bios
   ```

* Adapter la commande précédente, pour interroger toutes les deux VMs (Client1 et 2)

* Adapter votre script pour détecter le système d’exploitation

* Adapter le script pour afficher, le nom de la machine, le nom du système d’exploitation, sa version et son architecture (x64 ou x86).

* À l’aide de la classe WMI **win32_LogicalDisk**, afficher la taille et l’espace libre des partitions.

* Affiner la sortie de la commande précédente pour afficher en tableau les colonnes suivantes : Name, Espace Libre (en GB) et taille (en GB). Garder ce script pour la prochaine partie.

   ```Conseil : utiliser la syntaxe :```
   ```@{label = <string> ; expression = {<script>}}```

## Envoi de message et HTML

* À l’aide de la commande **Send-Mailmessage**, envoyez-vous un mail de test (adaptez les paramètres de la commande en fonction de votre fournisseur de messagerie : SSL ?, Port 25 ou 587…)

* À l’aide du script de la dernière partie (concernant Win32_LogicalDisk), envoyer la liste des partitions de vos 3 VMs à votre adresse mail.

* Répétez l’opération précédente en convertissant le retour du script en HTML.
