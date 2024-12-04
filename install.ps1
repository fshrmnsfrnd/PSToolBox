$path = 'C:\Program Files\WindowsPowerShell\Modules\'

Copy-Item -Path $PSScriptRoot -Destination $path -Force -Recurse

while (-Not (Test-Path -Path $path)) {
    Start-Sleep -Milliseconds 500
}

try {
    Import-Module -Name pstoolbox -Global
} catch {
    Write-Error "Fehler beim Importieren des Moduls: $_"
}