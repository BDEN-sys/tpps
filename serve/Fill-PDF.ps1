Param (
  
    [Parameter(Mandatory=$true,  Position=0)]
    [String]$formulaire,
    [Parameter(Mandatory=$true,  Position=1)]
    [String]$path,
    [Parameter(Mandatory=$true,  Position=2)]
    [String]$displayname,
    [Parameter(Mandatory=$true,  Position=3)]
    [String]$login,
    [Parameter(Mandatory=$true,  Position=4)]
    [String]$password,
    [Parameter(Mandatory=$true,  Position=5)]
    [String]$dll)

if (!(Test-Path $formulaire)) {Write-Host "Le formulaire est introuvable : $formulaire" -ForegroundColor Red;$error_stop=$true}
if (!(Test-Path $dll)) {Write-Host "La DLL itext est introuvable : $dll" -ForegroundColor Red;$error_stop=$true}
if (Get-Item $dll -Stream Zone.identifier -ErrorAction SilentlyContinue) {Write-host "la dll est bloquée !" -ForegroundColor Red ;$error_stop=$true}

if ($error_stop) {break}

#Chemin de la dll itextsharp
if (!(Test-Path $path)) {mkdir $path}

Write-host "`tCréation de la fiche utilisateur : $displayname"

#Chargement de la dll itextsharp
$dll = (Get-Item $dll).FullName
[void][System.Reflection.Assembly]::LoadFrom($dll)

#Chemin du formulaire à remplir (passé en paramètre)
$pdfTemplate = $formulaire
#Ouverture du formulaire
$pdfReader = New-Object iTextSharp.text.pdf.Pdfreader($pdfTemplate)

#Chemin du formulaire de destination
$newpdf="$path\$($login).pdf"
#Ouverture en écriture du formulaire de destination
$pdfstamper = New-Object iTextSharp.text.pdf.pdfStamper($pdfReader,[System.IO.File]::Create($newpdf))
#Chargement des champs de formulaire
[iTextSharp.text.pdf.acrofields]$pdfFormFields = $pdfstamper.AcroFields

#Remplissage des champs de formulaire
$null = $pdfFormFields.SetField("displayname", "$(($displayname).ToUpper())")
$null = $pdfFormFields.SetField("login", "$($login)")
$null = $pdfFormFields.SetField("password", "$($password)")


$pdfstamper.Close()
$pdfReader.Close()
