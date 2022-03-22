#
# DESCRIPTION:
#   This PowerShell script applies Pretty PuTTY to all sessions saved in PuTTY.
#   A dark or light theme will be applied based on the time of day.
#
# RUN:
#   .\apply-all.ps1
#
$light = (Get-Date -Hour 8).TimeOfDay
$dark = (Get-Date -Hour 19).TimeOfDay
$now = (Get-Date).TimeOfDay
$reg_file = '.\pretty_putty_dark.reg'
if ($now -gt $light -and $now -lt $dark) {
    $reg_file = '.\pretty_putty_light.reg'
}
$reg_content = Get-Content $reg_file

$session_names = Get-ChildItem HKCU:\Software\SimonTatham\PuTTY\Sessions\ -Name
foreach ($session_name in $session_names) {
    $reg_content -replace 'FOO%20BAR', $session_name | Out-File -Encoding default .\temp.reg
    reg import .\temp.reg
    Remove-Item .\temp.reg
}
