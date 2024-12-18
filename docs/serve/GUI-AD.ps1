#Scripts à adapter à la création AD

Add-Type -AssemblyName System.Windows.Forms

# Fonction pour afficher un message d'erreur
function Show-Error {
    param ([string]$Message)
    [System.Windows.Forms.MessageBox]::Show($Message, "Erreur", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}


# Création de la fenêtre principale
$form = New-Object System.Windows.Forms.Form
$form.Text = "Création d'utilisateurs Active Directory"
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"


<#
# Bouton de sélection  d'un fichier CSV
$btnSelectFile = New-Object System.Windows.Forms.Button
$btnSelectFile.Text = "Sélectionner un fichier CSV"
$btnSelectFile.Size = New-Object System.Drawing.Size(200, 30)
$btnSelectFile.Location = New-Object System.Drawing.Point(200, 20)
$form.Controls.Add($btnSelectFile)
#>

<#
# Tableau pour afficher le contenu du fichier CSV
$dataGrid = New-Object System.Windows.Forms.DataGridView
$dataGrid.Size = New-Object System.Drawing.Size(550, 250)
$dataGrid.Location = New-Object System.Drawing.Point(20, 70)
$form.Controls.Add($dataGrid)
#>

<#
# Bouton pour créer les utilisateurs
$btnCreateUsers = New-Object System.Windows.Forms.Button
$btnCreateUsers.Text = "Créer les utilisateurs"
$btnCreateUsers.Size = New-Object System.Drawing.Size(200, 30)
$btnCreateUsers.Location = New-Object System.Drawing.Point(200, 330)
$form.Controls.Add($btnCreateUsers)
#>

<#
# Action pour sélectionner un fichier
$btnSelectFile.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "CSV Files (*.csv)|*.csv"

    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            $csvData = Import-Csv -Path $openFileDialog.FileName -Delimiter ';' -Encoding UTF8
            $dataGrid.DataSource = [System.Collections.ArrayList]$csvData
        } catch {
            Show-Error "Erreur lors du chargement du fichier CSV : $_"
        }
    }
})
#>

<#
# Action pour créer les utilisateurs
$btnCreateUsers.Add_Click({
    if (-not $csvData) {
        Show-Error "Veuillez charger un fichier CSV avant de continuer."
        return
    }

    #Création des comptes AD

    [System.Windows.Forms.MessageBox]::Show("Les utilisateurs créés avec succès !", "Succès", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})
#>

# Affichage de la fenêtre
[void]$form.ShowDialog()