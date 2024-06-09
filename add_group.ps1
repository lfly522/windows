# 
# Add User to a Group - PowerShell Script 
# 
Import-module ActiveDirectory  
Import-CSV "C:\Scripts\Users.csv" | % {  
Add-ADGroupMember -Identity $group -Members $_.UserName  
}
