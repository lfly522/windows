# Title: Bulk_users_changepw
# Author: Jeffrey
# Version: 1.02

Import-Module activedirectory

$csvFilePath = "D:\Scripts\account_final_062023.csv"
$ADUsers = Import-Csv $csvFilePath

foreach ($User in $ADUsers)
{
    $Username   = $User.username
    $Password   = $User.password
    $Firstname  = $User.firstname
    $Lastname   = $User.lastname
    $OU         = $User.ou
    $Email      = $User.email
    $Mobile     = $User.mobile

    if (Get-ADUser -Filter {SamAccountName -eq $Username})
    {
        Write-Warning "A user account with username $Username already exists in Active Directory."
    }
    else
    {
        $UserPrincipalName = "$Username@mnews.local"
        $Name = "$Lastname$Firstname"
        $DisplayName = "$Lastname$Firstname"
        $AccountPassword = ConvertTo-SecureString $Password -AsPlainText -Force

        New-ADUser -SamAccountName $Username `
                   -UserPrincipalName $UserPrincipalName `
                   -Name $Name `
                   -GivenName $Firstname `
                   -Surname $Lastname `
                   -Enabled $true `
                   -DisplayName $DisplayName `
                   -Path $OU `
                   -EmailAddress $Email `
                   -MobilePhone $Mobile `
                   -AccountPassword $AccountPassword -ChangePasswordAtLogon $true
    }
}


#Title: UpdateADUserAttributes
# Author: Jeffrey
# Version: 1.02

$csvFilePath = "D:\Scripts\users062023.csv"
$users = Import-Csv $csvFilePath

foreach ($user in $users)
{
    $SamAccountName = $user.samaccountname
    $Description = $user.description
    $Pager = $user.pager
    $Group = $user.group

    Set-ADUser -Identity $SamAccountName -Add @{Description = $Description}
    Set-ADUser -Identity $SamAccountName -Add @{Pager = $Pager}
    Add-ADGroupMember -Identity $Group -Members $SamAccountName
}
