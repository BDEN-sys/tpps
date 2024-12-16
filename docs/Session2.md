# Session 2

## Les fournisseurs

### Variables d'environnement

* Récupérer dans une variable le contenu de la variable d'environnement **computername**

* Créer une variable d'environnement nommée **login** et affecter lui la valeur **paul.atreides**

### Registre

* Retrouver le chemin complet de la clé **Winlogon** dans le registre (HKEY Current User)

* À l’aide du chemin de registre suivant, extraire les versions et les services pack des Framework .net installés  :
```HKLM\software\microsoft\Net Framework setup\ndp```

* À l’aide du chemin de registre suivant, activer le bureau à distance de votre machine : ```HKLM\SYSTEM\currentcontrolset\control\terminal server\fdenytsconnections```

* À l’aide du chemin de registre suivant, lister toutes les clés usb connectés à votre machine hôte : ```HKLM\SYSTEM\CurrentControlSet\Enum\USBSTOR```

## Formatage de l'affichage

* Afficher toutes les propriétés de la commande ```Get-Process```

* Puis choisir de n'afficher que les propriétés **ID, Name et WorkingSet**

## Système de fichiers

* Afficher les extensions de fichiers présentes dans le répertoire **c:\Windows** de manière unique et dans l'ordre alphabétique (exclure les extensions ‘vides’)

* Créer un fichier nommée **date.log** et reculer sa date de création d'un mois.

## Gestion système

* Afficher le nombre de services arrêtés et démarrés en **seule ligne de commande**

* Afficher tous les processus fabricant (Microsoft, AMD, Intel, etc..) et trier en ordre décroissant leurs nombres.

* Vérifier la présence d’une erreur disque dans les journaux d’évènements (id event 7)

## Statistiques, manipulation de texte, conversion en objet

* Mesurer le nombre de lignes, de mots et caractères d'un fichier texte

* Créer une variable nommée **chaine** avec la valeur **Paul Atreides** et effectuer les opérations suivantes :
  * Convertir les majuscules en minuscule
  * Remplacer l'espace par un point
  * Ajouter le suffixe **@cesi.fr**
  * Extraire le prénom et le nom de la chaine

<!--* Transformer le retour de la commande ```netstat.exe``` en objet -->

## Conditions

* Proposer à l’utilisateur de choisir un chiffre en 1 et 5 et afficher lui le chiffre choisi en toutes lettres

## Créer une boucle

* Créer une boucle visuelle avec la commande Write-Progress (Barre de progression)

## Services WEB

* À l'aide de l'URL suivante, récupérer l'ip publique de votre connexion Internet et stocker le résultat dans une variable :
```https://api.ipify.org?format=json```

* À l'aide de l'URL suivante, récupérer la liste des communes correspondant au code postal de votre choix :
```https://geo.api.gouv.fr/communes?codePostal=<code postal>```
