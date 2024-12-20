﻿
function Hash-Compare {
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$path = Read-Host Von Welcher Datei soll der Hash errechnet werden?

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select a Computer'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please select a computer:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)
$listBox.Height = 80

[void] $listBox.Items.Add('SHA1')
[void] $listBox.Items.Add('SHA256')
[void] $listBox.Items.Add('SHA384')
[void] $listBox.Items.Add('SHA512')
[void] $listBox.Items.Add('MACTripleDES')
[void] $listBox.Items.Add('MD5')
[void] $listBox.Items.Add('RIPEMD160')

$form.Controls.Add($listBox)
$form.Topmost = $true
$result = $form.ShowDialog()

$algorithm = $listBox.SelectedItem

$currenthash = Read-Host Welcher Haswert sollte es sein?

$hash = Get-FileHash -Path $path -Algorithm $algorithm

if($hash -eq $currenthash){
    Write-Host Sie sind gleich -ForegroundColor Green
}else{
    Write-Host Sie sind unterschiedlich -ForegroundColor Red
}
}