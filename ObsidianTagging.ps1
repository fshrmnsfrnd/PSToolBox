clear

# Variablen
$ordnerPfad = "C:\Users\nicon\TestObsidian\"
$uberschriften = @()

$alldata = Get-ChildItem -Path "$ordnerpfad\Schule" -Filter "*.md" -Recurse
$alldata = $alldata | Where-Object { $_.Name -notmatch "excalidraw|\.pdf|drawing" }

# Überschriften sammeln
foreach ($currentfile in $alldata) {
    $content = Get-Content $currentfile.FullName

    foreach ($zeile in $content) {
    $inCodeblock = $false
    
        if ($zeile -match '\s*```') {
            $inCodeblock = -not $inCodeblock # Toggle the flag to enter or leave code block
            continue
        }
        
        if ($inCodeblock) {
            continue
        }

        # Prüfen, ob die Zeile mit # beginnt
        if ($zeile -notmatch '\[\[*\]\]' -and $zeile -notmatch '\$.*\$' -and $zeile -notmatch 'Aufgabe'){
            # Entferne # und führende Leerzeichen
            $zeile = $zeile -replace "^\s*#+\s*", ""
            
            $uberschriftObjekt = [PSCustomObject]@{
                Dateiname = $currentfile.FullName -replace ".md", ""   # Nur der Dateiname ohne ".md"
                Uberschrift = $zeile
            }
            
            $uberschriften += $uberschriftObjekt
        }
    }
}

# Durchlaufe erneut alle Dateien, um Überschriften zu ersetzen
foreach($currentfile in $alldata){
    $inhalt = Get-Content $currentfile.FullName

    # Flag, das anzeigt, ob wir uns in einem Codeblock befinden
    $inCodeblock = $false

    # Jede Zeile in der Datei durchgehen
    for($i = 0; $i -lt $inhalt.Length; $i++){
        $zeile = $inhalt[$i]

        # Wenn die Zeile mit # beginnt, überspringen
        if ($zeile -match "^\s*#") {
            continue
        }
        
        #Codeblock skippen
        $codeblock = '\s*```'
        if ($zeile -match $codeblock) {
            $inCodeblock = -not $inCodeblock # Toggle the flag to enter or leave code block
            continue
        }
        if ($inCodeblock) {
            continue
        }
       

        if ($zeile -notmatch '\[\[*\]\]' -and $zeile -notmatch '\$.*\$' -and $zeile -notmatch '^\s*#' -and $zeile -notmatch 'Aufgabe'){
        Write-Host "1"
            # Jede Überschrift durchgehen und prüfen, ob sie im Text vorkommt
            foreach($uberschrift in $uberschriften){
                if ($zeile -match [regex]::Escape($uberschrift.uberschrift)){
                    # Format für den Ersatztext
                    $ersatzText = "[[$($uberschrift.Dateiname)#$($uberschrift.uberschrift)|$($uberschrift.uberschrift)]]"
                    # Text in der Zeile ersetzen
                    $zeile = $zeile -replace [regex]::Escape($uberschrift.uberschrift), $ersatzText
                    Write-Host "Ersatztext: "
                    Write-Host $ersatzText
                }
            }
            
            # Aktualisierte Zeile zurück in den Inhalt der Datei schreiben
            $inhalt[$i] = $zeile
        }
    }
    # Set-Content -Path $currentfile.FullName -Value $inhalt -Encoding UTF8
}

