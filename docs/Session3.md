# Session 3

## Gestion Active Directory avec Powershell

### Paramétrage du serveur

Nommer la machine virtuelle à l’aide de la commande Powershell suivante :

```powershell
Rename-Computer -NewName DC1 -force
```

Configurer la carte réseau comme indiqué ci-dessous avec Powershell :

Trouver l’id de la carte réseau local à l’aide de Powershell :

**Réponse (commande utilisée et id de la carte) :**

Pour configurer l’adresse IPv4, la passerelle et le masque de sous réseau :

```powershell
Get-NetAdapter -InterfaceIndex <id_carte_réseau> | 
New-NetIPAddress -IPAddress 192.168.10.12 -DefaultGateway 192.168.10.1 -PrefixLength 24
```

Que signifie le paramètre PrefixLength dans la commande précédente ?

**Réponse :**

Vérifier la prise en compte de la configuration :

```powershell
Get-NetAdapter -InterfaceIndex <id_carte_réseau> | Get-NetIPConfiguration
```

Tester la connexion avec le routeur :

```powershell
Test-Connection 192.168.10.12 -count 1
```

À quelle commande historique correspond la commande ci-dessous ?

**Réponse :**

Configurer le client DNS

```powershell
Get-NetAdapter -InterfaceIndex <id_carte_réseau> | Set-DnsClientServerAddress -ServerAddresses 192.168.10.12
```

### Installation du service d’annuaire Active Directory

Créer le domaine `cesi<id>.lan` à l’aide de Powershell :

Installation des outils de management et déploiement Active Directory :

```powershell
Install-WindowsFeature AD-Domain-Services,RSAT-ADDS-Tools
```

Comment vérifier les rôles et fonctionnalités installés à l’aide de la console Powershell :

**Réponse :**

Redémarrer le serveur :

```powershell
Restart-Computer
```

Pour installer Active Directory, lancer la commande Powershell suivante :

```powershell
Import-Module ADDSDeployment 
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "Win2012" `
   -DomainName "cesi.lan" -DomainNetbiosName "CESI" -ForestMode "Win2012" -InstallDns:$true `
   -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true `
   -SafeModeAdministratorPassword (ConvertTo-SecureString "P@ssword" -AsPlainText -Force)
```

Redémarrer le serveur :

```powershell
Restart-Computer
```

### Vérification de l’installation d’Active Directory

Rester la configuration d’Active Directory avec la commande DCDIAG.exe

Tester la résolution de nom directe et inverse du nom FQDN de votre DC :

**Réponse :**

> En principe, il est conseillé de gérer son domaine AD depuis une console de type client. Dans cas les outils de gestion RSAT doivent être installés, dans le cas d’un DC, ils sont installés automatiquement. En dehors de cet exercice, il est vivement conseillé d’utiliser un poste de travail qui n'est pas un contrôleur de domaine pour administrer ActiveDirectory.
> Depuis Powershell v3, l’import d’un module dans la session courante est automatique :
Dans ce cas la commande implicite exécutée est **Import-module** ActiveDirectory lors du premier lancement de la commande ActiveDirectory.

* Créer une unité d'organistation (OU) nommée **Annuaire** (avec Powershell)

* Créer un utilisateur lambda avec une adresse mail et une ville à l’aide de la commande **New-Aduser**, puis lui ajouter un mot de passe. (dans l’OU Annuaire crée précédemment)

* Créer un deuxième utilisateur avec mot de passe à l’aide d’une seule ligne de commande

* Lister tous les comptes dont le mot de passe n’a pas été changé depuis un mois. (dans le cadre de ce TP, une heure suffira étant donné la date de création des comptes)

* À l’aide la commande précédente, forcer le changement de passe des comptes concernés

### Création d'utilisateurs depuis un fichier de type CSV

* À l’aide du fichier CSV fourni par le formateur, créez un grand nombre de comptes tel que :
  * Login : prenom.nom (limité à 20 caractères) sans accent
  * Mot de passe : nombre aléatoire de 8 caractères
    * Bonus : utilisation d'une fonction dédiée : [Generate-Password.ps1](https://tpps.bden.fr/serve/Generate-Password.ps1)
  * Email : `prenom.nom@votredomaine.xxx` (sans limitation de caractère)
  * Forcer le changement de mot de passe à la première ouverture de session
  * Créer l’utilisateur dans l’OU précédemment crée

Fichier CSV : [Lien](https://tpps.bden.fr/serve/BaseDonneesExempleCsv.csv)

Fonction : [Remove-Diacritics](https://tpps.bden.fr/serve/Remove-Diacritics.ps1)

### Création d'utilisateurs Active Directory depuis une base de données MySQL

#### Prérequis base de données MariaDB (Mysql)

* Installer MariaDB sur votre machine :
  * [mariadb-10.3.7-winx64.msi](https://drive.proton.me/urls/PKBTG6AJ6W#LQmQ2Xk7gMm4)
  * Choisir **UTF8** comme jeu de caractère

* Dans une console CMD.exe, se connecter au serveur MariaDB :

```cmd
mysql -u root -p 
```

* Créer la base de données à l'aide de la commande suivante :

```sql
CREATE DATABASE RH;
```

* Créer la table rh_users :

```sql
USE RH; 
CREATE TABLE rh_users (surname VARCHAR(100), givenname VARCHAR(100), city VARCHAR(100));
```

Charger le fichier CSV dans la table rh_users;

```sql
LOAD DATA LOCAL INFILE 'C:/TP/CSV/BaseDonneesExempleCsv.csv' INTO TABLE rh_users FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 LINES (surname, givenname,city); 
```

#### Création des utilisateurs depuis Mysql

* Supprimer tous les comptes Active Directory que vous avez créés précédemment.

A l'aide des scripts fournis, créer tous les comptes présents dans la BDD MySQL dans l’AD tel que :

* Login (samaccountname) : prenom.nom (limité à 20 caractères) sans accent (fonction Remove-Diacritics fournie)
* Login (UPN) : `prenom.nom@votredomaine.xxx` (sans limitation de caractère)
* Mot de passe : nombre aléatoire de 8 caractères
  * Bonus : utilisation d'une fonction dédiée : [Generate-Password.ps1](https://tpps.bden.fr/serve/Generate-Password.ps1)
* Email : `prenom.nom@votredomaine.xxx` (sans limitation de caractère)
* Forcer le changement de mot de passe à la première ouverture de session
* Créer l’utilisateur dans l’OU précédemment crée
* Créer les dossiers personnels des utilisateurs avec attribution des droits NTFS inhérents dans le dossier partagé : ```\\srv-data\home\<username>```, voir script **SetFolderPermission.ps1** pour les droits NTFS

Connecteur : [.Net Mysl](https://assets.bden.fr/tpps/mysql-connector-net-6.4.4.msi)
Fonction : [Get-Mysql](https://tpps.bden.fr/serve/Get-Mysql.ps1) Script : [SetFolderPermission](https://tpps.bden.fr/serve/SetFolderPermission.ps1)

* Remplacer le serveur de fichier hébergeant les répertoires personnels par ```\\srv-data2``` pour tous les utilisateurs créés préalablement.

* À l'aide de la fonction [Fill-PDF](https://tpps.bden.fr/serve/Fill-PDF.ps1), du fichier [Formulaire.pdf](https://tpps.bden.fr/serve/formulaire.pdf) et de la DLL [itextsharp.dll](https://assets.bden.fr/tpps/itextsharp.dll) générer un export pour chaque utilisateur de l'OU **Annuaire**.

* Simuler la transmission par mail de chaque export PDF vers l'utilisateur concerné. (Générer la commande "send-mailmessage" sous forme d'une chaine de caractère)

#### Création des utilisateurs via CSV et GUI

* Supprimer tous les comptes Active Directory que vous avez créés précédemment.

* Télécharger le script suivant [GUI-AD.ps1](https://tpps.bden.fr/serve/GUI-AD.ps1)

* Lancer le script suivant GUI-AD.ps1 - En principe une fenêtre vide doit s'afficher.

* Décommenter la partie "Bouton de sélection  d'un fichier CSV" et relancer le script. Observez l'ajout d'un bouton concernant l'import CSV.

* Décommenter la partie "Contenu du fichier CSV" et relancer le script. Cette fois une zone de contenu vide apparait.

* Décommenter la partie "Bouton pour créer les utilisateurs" et relancer le script. Observez l'ajout d'un bouton concernant la création des utilisateurs.

* Décommenter la partie "Action pour sélectionner un fichier" et relancer le script. Sélectionner le fichier CSV 'BaseDonneesExempleCsv.csv' et vérifier le résultat dans la zone de contenu.

* Décommenter la partie "Action pour créer les utilisateurs" et relancer le script. Effectuez les opérations suivantes :
  * Adapter cette partie pour afficher le nom, le prénom et la ville dans le shell lors d'un clic sur le bouton "Créer les utilisateurs".
  * Reprendre le script de la partie CSV et l'ajouter dans la partie action. Dans un premier temps, afficher seulement la commande en mode texte dans le shell : `"New-Aduser -samaccountname $login -name $name ..."`
  * Si les commandes New-Aduser semblent correctes, adapter cette partie du script pour créer les comptes.

* Adapter le script pour créer une OU depuis l'interface graphique.

* Adapter le script pour créer un groupe depuis l'interface graphique.

* Adapter le script pour vérifier si les comptes existent avant création.
