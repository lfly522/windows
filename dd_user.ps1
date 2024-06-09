# 
# Disabled User - PowerShell Script 
# 
$User = Read-Host -Prompt 'Enter the username of the employee you wish to change'
Get-ADUser -Identity $User -Properties MemberOf | ForEach-Object {
  $_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -Confirm:$false
  Add-ADGroupMember -Identity 已離職 -Members $User
  Disable-ADAccount -Identity $User
  Get-ADUser $User | Move-ADObject -TargetPath "OU=已離職,OU=mnews,DC=mnews,DC=local"
  Set-ADUser $User -Clear pager
}
