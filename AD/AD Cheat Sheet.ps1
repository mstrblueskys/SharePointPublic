############################################################
# Install Remote Server Administration Tools for Windows 10
############################################################

(New-Object -Com Shell.Application).Open("https://www.microsoft.com/en-us/download/details.aspx?id=45520")

#####################################
# List AD Groups made in last Month
#####################################

$date = (get-Date).tostring()
$month = (Get-Date).AddDays(-30)
Get-ADGroup -Filter * -Properties whencreated | where {$_.whencreated -ge $month} | select name,whenCreated

##############################
# Add a user to an AD group
##############################

$usernm = "username"
$group = "AD Group Name"
Add-ADGroupMember -Identity $group -Members $usernm

###########################
# Pull user's AD groups
###########################

$user = "username"
Get-ADPrincipalGroupMembership "$user"

####################################################
# Get Group details with created and modified dates
####################################################

Get-ADGroup -identity "GroupIdentity" -Properties modified,whencreated

#############################################################
# Get list of AD groups with a specific name exported to csv
#############################################################

$filepath = "C:\FilePath"
get-adgroup -filter "name -like 'W_*'" | Select name | Export-Csv $filepath –NoTypeInformation  

############################################################
# BTM Specific SharePoint Group Create
############################################################

#New ADGroup
New-ADGroup -Name "APP-$SiteURL-Owners" -GroupScope Universal -Path "OU=SharePoint,OU=Applications,OU=[Org]_Groups,DC=[Org],DC=ORG"
New-ADGroup -Name "APP-$SiteURL-Members" -GroupScope Universal -Path "OU=SharePoint,OU=Applications,OU=[Org]_Groups,DC=[Org],DC=ORG"

#Add Members
Get-ADGroup "APP-$SiteURL-Owners" | Add-ADGroupMember $OwnerUsers
Get-ADGroup "APP-$SiteURL-Members" | Add-ADGroupMember $MemberUsers