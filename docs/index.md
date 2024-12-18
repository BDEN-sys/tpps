# Session 1

## Commandes pour débuter

* Lister toutes les commandes de type « functions »

* Lister toutes les commandes se terminant par ‘path’.

* N'afficher que les exemples de l'aide pour la commande Get-Process

* Afficher de l'aide concernant For

## Comprendre un script

* Que fait ce script :

```powershell
Get-Command | Foreach { 
    Get-Help $_ -detailed |Out-File -FilePath C:\temp\$_.txt –Encoding ASCII
}
```

## Système de fichiers

* Lister tous les fichiers du répertoire C:\Windows\system32 et ses sous-répertoires dont la taille est supérieure ou égale à 10 Mo

* Copier seulement les sous-répertoires de l’arborescence (récursif) du répertoire 'program files' vers un répertoire de votre choix.

## Gestion système

* Récupérer tous les services arrêtés et envoyer le résultat dans un fichier.

* Lister tous les ids des mise à jour Microsoft et envoyer le résultat dans un fichier.

* Récupérer les processus utilisant au moins 100 Mo.

* Récupérer dans le journal d’événements 'Application' , toutes les entrées en erreur.