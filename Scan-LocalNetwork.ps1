function Scan-LocalNetwork {
    [CmdletBinding()]

    $MAC_ORG = Import-Csv -Delimiter ';' -Path $PSScriptRoot\MAC_Organization.csv

    $Computers = (arp.exe -a | Select-String "$SubNet.dynam") -replace ' +',',' | ConvertFrom-Csv -Header Computername,IPv4,MAC,x,Vendor | Select Computername,IPv4,MAC

    foreach ($Computer in $Computers) {
        # nslookup für den Computernamen
        $nslookupResult = nslookup $Computer.IPv4  | Select-String -Pattern "^Name:\s+([^\.]+).*$"
        if ($nslookupResult) {
            $Computer.Computername = $nslookupResult.Matches.Groups[1].Value
        }

        # MAC-Adresse von Format aa-00-bb-11-cc-22 zu AA00BB bearbeiten
        $MAC = $Computer.MAC -replace '-',''
        $MAC = $MAC.Substring(0, $MAC.Length - 6)
        $MAC = $MAC.ToUpper()

        # Organisation anhand der MAC-Adresse suchen
        $ORG = $MAC_ORG | Where-Object { $_.MAC -eq $MAC }

        # Falls die Organisation gefunden wurde, füge sie dem Computerobjekt hinzu
        if ($ORG -ne $null) {
            $Computer | Add-Member -MemberType NoteProperty -Name Organization -Value $ORG.Organization
        }else{
            $Computer | Add-Member -MemberType NoteProperty -Name Organization -Value "Unbekannt"
        }
    }

    # Zeige die Computerinformationen an
    $Computers
}