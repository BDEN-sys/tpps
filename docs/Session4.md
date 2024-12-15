# Session 4

## Utilisation de WMI

### Prérequis : 

* 3 machines Windows virtuelles nommées Client1, Client2, Client3. Les VMs doivent pouvoir communiquer avec la machine hôte. (NIC Bridged ou host-only)

* Démarrer les machines virtuelles créées précédemment et configurer le mot de passe : **P@ssword pour le compte administrateur – important pour la suite**

* Sur chaque VM, lancer la commande suivante pour autoriser WMI et DCOM distant :

	```netsh advfirewall firewall set rule group="Infrastructure de gestion Windows (WMI)" new enable=yes```

### WMI/CIM (Windows Management Instrumentation)

* Sur l’hôte hébergeant les VMs, lancer une console powershell, puis la commande suivante :

	````Get-WmiObject win32_bios -ComputerName client1 -Credential administrateur````

* À l’aide de la commande précédente, créer un script qui va interroger toutes les VMs à l’aide d’une boucle.

* Adapter votre script pour détecter le système d’exploitation

* Adapter le script pour afficher, le nom de la machine, le nom du système d’exploitation, sa version et son architecture (x64 ou x86).

* À l’aide de la classe WMI **win32_LogicalDisk**, afficher la taille et l’espace libre des partitions de votre hôte.

* Affiner la sortie de la commande précédente pour afficher en tableau les colonnes suivantes : Name,  Espace Libre (en GB) et taille (en GB). Garder ce script pour la prochaine partie.

	```Conseil : utiliser la syntaxe :```
	```@{label = <string> ; expression = {<script>}}```


## Envoi de message et HTML

* À l’aide de la commande **Send-Mailmessage, envoyez-vous un mail de test (adaptez les paramètres de la commande en fonction de votre fournisseur de messagerie : SSL ?, Port 25 ou 587…)

* À l’aide du script de la dernière partie (concernant Win32_LogicalDisk), envoyer la liste des partitions de vos 3 VMs à votre adresse mail.

* Répétez l’opération précédente en convertissant le retour du script en HTML.


 
