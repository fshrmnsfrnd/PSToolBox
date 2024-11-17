function Get-DirSize {

    param(
        [Parameter(Position = 0)]
        [string]$Path = '.\',
        [switch]$SubDir,
        [switch]$Export,
        [string]$ExportPath = '.\',
        [switch]$help
    )
        
    if($help){
        Write-Host 'Help is coming'
        Write-Host "Verwendung: Dir-Size [-Path <Pfad>] [-SubDir] [-Export] [-ExportPath <ExportPfad>] [-help]"
        Write-Host "-Path: Pfad, der überprüft werden soll (Standard ist .\)."
        Write-Host "-SubDir: Optionaler Schalter, um Unterverzeichnisse einzubeziehen."
        Write-Host "-Export: Optionaler Schalter, um die Ausgabe in eine Datei zu exportieren."
        Write-Host "-ExportPath: Pfad, wo die Ausgabedatei gespeichert wird (Standard ist .\)."
        Write-Host "-help: Zeigt diese Hilfenachricht an."
        return
    }

    $data = @()

    if($SubDir){
        $Folders = Get-ChildItem $Path -Directory
        ForEach ($Folder in $Folders) {
            $Size = size -path $Folder
            $data += [PSCustomObject]@{
                Directory = $Folder.FullName
                SizeMB = $Size
            } 
        }
    }else{
        $Size = size -path $path
        $data += [PSCustomObject]@{
            Directory = $Path
            SizeMB = $Size
        }
    }

    $data

    if($Export){
        Export-Csv -InputObject $data -Path $ExportPath -Force
    }
}

function size ($path){
    $FolderSize = (Get-ChildItem $Path.FullName -Force -Recurse -ErrorAction SilentlyContinue | Measure-Object -ErrorAction SilentlyContinue -Property Length -Sum).Sum / 1MB
    $FolderSize = [Math]::Round($FolderSize, 2)
    return $FolderSize
}