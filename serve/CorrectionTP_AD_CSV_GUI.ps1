#Script de génération d'interface graphique dans le cadre d'un TP CESI

Add-Type -AssemblyName System.Windows.Forms

# Fonction pour afficher un message d'erreur
function Show-Error {
    param ([string]$Message)
    [System.Windows.Forms.MessageBox]::Show($Message, "Erreur", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}

# Création de la fenêtre principale
$form = New-Object System.Windows.Forms.Form
$form.Text = "Création d'utilisateurs Active Directory"
$form.Size = New-Object System.Drawing.Size(600, 620)
$form.StartPosition = "CenterScreen"

# Bouton pour sélectionner un fichier CSV
$btnSelectFile = New-Object System.Windows.Forms.Button
$btnSelectFile.Text = "Sélectionner un fichier CSV"
$btnSelectFile.Size = New-Object System.Drawing.Size(200, 30)
$btnSelectFile.Location = New-Object System.Drawing.Point(200, 220)
$form.Controls.Add($btnSelectFile)

# Tableau pour afficher le contenu du fichier CSV
$dataGrid = New-Object System.Windows.Forms.DataGridView
$dataGrid.Size = New-Object System.Drawing.Size(550, 250)
$dataGrid.Location = New-Object System.Drawing.Point(20, 270)
$form.Controls.Add($dataGrid)

# Bouton pour créer les utilisateurs
$btnCreateUsers = New-Object System.Windows.Forms.Button
$btnCreateUsers.Text = "Créer les utilisateurs"
$btnCreateUsers.Size = New-Object System.Drawing.Size(200, 30)
$btnCreateUsers.Location = New-Object System.Drawing.Point(200, 530)
$form.Controls.Add($btnCreateUsers)

# TextBox pour créer une OU
$txtBoxCreateOU = New-Object System.Windows.Forms.TextBox
$txtBoxCreateOU.Text = "Entrer nom OU"
$txtBoxCreateOU.Size = New-Object System.Drawing.Size(200, 50)
$txtBoxCreateOU.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($txtBoxCreateOU)

# Bouton pour créer l'OU
$btnCreateOU = New-Object System.Windows.Forms.Button
$btnCreateOU.Text = "Créer l'OU"
$btnCreateOU.Size = New-Object System.Drawing.Size(100, 20)
$btnCreateOU.Location = New-Object System.Drawing.Point(220, 20)
$form.Controls.Add($btnCreateOU)

# TextBox pour créer le groupe
$txtBoxCreateGrp = New-Object System.Windows.Forms.TextBox
$txtBoxCreateGrp.Text = "Entrer nom groupe"
$txtBoxCreateGrp.Size = New-Object System.Drawing.Size(200, 50)
$txtBoxCreateGrp.Location = New-Object System.Drawing.Point(20, 70)
$form.Controls.Add($txtBoxCreateGrp)

# Bouton pour créer le groupe
$btnCreateGrp = New-Object System.Windows.Forms.Button
$btnCreateGrp.Text = "Créer le groupe"
$btnCreateGrp.Size = New-Object System.Drawing.Size(100, 20)
$btnCreateGrp.Location = New-Object System.Drawing.Point(220, 70)
$form.Controls.Add($btnCreateGrp)

# Action pour créer l'OU
$btnCreateOU.Add_Click({
    #Récupération de la valeur saisie dans la textbox
    $ouName = $txtBoxCreateOU.Text
    #Si l'OU n'est pas saisie à la racine, il faut préciser le path. L'idéal serait d'indiquer cette valeur au début du script ou dans un fichier de configuration
    $ouRoot = 'OU=Annuaire,DC=cesi,DC=lan'
    Write-Host $ouName
    if ($ouName -eq 'Entrer nom OU') {
        Show-Error "Erreur nom OU"
        return
    }
        #Partie concerant la création de l'OU
        try {
            # La commande Write-Host n'est pas obligatoire et permet d'afficher la commande réalisée dans la console
            Write-Host "New-ADOrganizationalUnit $ouName -path $ouRoot -ProtectedFromAccidentalDeletion $false"
            New-ADOrganizationalUnit $ouName -path $ouRoot -ProtectedFromAccidentalDeletion $false 
        } catch {
            Show-Error "Erreur lors de la création de l'OU $ouName"
            break
        }

    [System.Windows.Forms.MessageBox]::Show("OU créée avec Succès !", "Succès", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})


# Action pour créer l'OU
$btnCreateGrp.Add_Click({
    #Récupération de la valeur saisie dans la textbox
    $GrpName = $txtBoxCreateGrp.Text
    #Emplacement ou créer les groupes. L'idéal serait d'indiquer cette valeur au début du script ou dans un fichier de configuration
    $ouRoot = 'OU=Groupes,OU=Annuaire,DC=cesi,DC=lan'
    if ($GrpName -eq 'Entrer nom groupe') {
        Show-Error "Erreur nom groupe"
        return
    }   
        #Partie concerant la création du groupe
        try {
            #La commande Write-Host n'est pas obligatoire et permet d'afficher la commande réalisée dans la console
            Write-Host  "New-ADGroup -Name $GrpName -GroupScope Global -DisplayName $GrpName -Path $ouRoot" 
        New-ADGroup -Name $GrpName -GroupScope Global -DisplayName $GrpName -Path $ouRoot   
        } catch {
            Show-Error "Erreur lors de la création du groupe $GrpName"
            break
        }
    

    [System.Windows.Forms.MessageBox]::Show("Groupe créée avec Succès !", "Succès", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})


# Action pour sélectionner un fichier
$btnSelectFile.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "CSV Files (*.csv)|*.csv"

    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            $global:csvData = Import-Csv -Path $openFileDialog.FileName -Delimiter ';' -Encoding UTF8
            $dataGrid.DataSource = [System.Collections.ArrayList]$csvData
        } catch {
            Show-Error "Erreur lors du chargement du fichier CSV : $_"
        }
    }
})


# Action pour créer les utilisateurs
$btnCreateUsers.Add_Click({
    if (-not $csvData) {
        Show-Error "Veuillez charger un fichier CSV avant de continuer."
        return
    }
    #Création des utilisateurs 
    $ou = 'OU=Annuaire,DC=cesi,DC=lan'

    foreach ($row in $csvData) {
        $prenom = $row.givenname
        $nom = $row.surname
        $cn = $nom + ' ' + $prenom
        $cn = Remove-Diacritics $cn
        $login = $prenom + '.' + $nom
        $login = $login.ToLower()
        $login = Remove-Diacritics $login
        $mail = $login + '@cesi.lan'
        if ($login.Length -gt 20) {
            $login = $login.Substring(0,20)
        }
        $password = Get-Random -Minimum 10000000 -Maximum 90000000
        $password = 'A@!' + $pwd 
        $city = $row.city

        #Ici on test si les utilisateurs existent 
        $CheckUser = $null
        try {
            $CheckUser = get-aduser -Identity $login -ErrorAction SilentlyContinue
        } catch {
        }
        #Si l'utilisateur n'existe pas 
        if (!($CheckUser)) {
            try {
                Write-Host "Création utilisateur : $login"
                New-ADUser -Name $cn `
                   -GivenName $prenom `
                   -Surname $nom `
                   -SamAccountName $login `
                   -UserPrincipalName $mail `
                   -DisplayName $cn `
                   -ChangePasswordAtLogon $true `
                   -City $city `
                   -Path $ou `
                   -Enabled $true  `
                   -AccountPassword (ConvertTo-SecureString -String $password -AsPlainText -Force)
            } catch {
                Show-Error "Erreur lors de la création de l'utilisateur $($row.UserPrincipalName) : $_"
            }
        } else { 
        Write-Host "Utilisateur : $login existe ! " -ForegroundColor Yellow
        }
    }
    

    [System.Windows.Forms.MessageBox]::Show("Utilisateurs créés avec succès !", "Succès", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})


# Affichage de la fenêtre
[void]$form.ShowDialog()