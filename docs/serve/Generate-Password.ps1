function Get-Password {
Param(
[Parameter(Mandatory=$false,  Position=3)][AllowEmptyString()]
[Int]$length)

    $length = 12
    # Liste des caracteres
    $lstCarSpecial = @("`#", "`@", "?", "_", "`%", "!", "/", "+")
    $alphabetMAJ = [char[]]([int][char]'A'..[int][char]'Z')
    $alphabetMIN = [char[]]([int][char]'a'..[int][char]'z')

    #Choix du caracteres special
    $special_char = $lstCarSpecial[(Get-Random -Maximum  ([array]$LstCarSpecial).count)]

    #Choix majuscule
    $maj_char = $alphabetMAJ[(Get-Random -Maximum  ([array]$alphabetMAJ).count)]

    # Longueur max du mot de passe
    $max=10
    if ($length) {$max = $length}      
    [string]$pwd = $null
    1..($max-2) | ForEach-Object {
         #Choix majuscule
        $pwd = "$pwd" + $alphabetMIN[(Get-Random -Maximum  ([array]$alphabetMIN).count)]

    }  
    
    $pwd_array = ($special_char + $maj_char + $pwd).ToCharArray()
    $pwd = $null
    0..($pwd_array.count -1) | ForEach-Object {
        $pwd = "$pwd" + $pwd_array[(Get-Random -Maximum  ([array]$pwd_array).count)]
    }
    $pwd 


    }

