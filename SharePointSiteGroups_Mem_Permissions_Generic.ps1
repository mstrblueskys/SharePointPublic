####################################################
#
#    Pull User Permissions in SharePoint
#       Matt Peterson, June 2023
#
#   Quick script to pull all users and permissions
#   of every SharePoint permission group for a site
#
####################################################

# Set Variables for your SharePoint site and where you want to save reports

$SiteUrl = 'https://[yourorg].sharepoint.com/sites/[yoursite]'
$FolderPath = 'C:\your\path\'

# Connect to SharePoint

Connect-PnpOnline -Url $SiteUrl -Interactive

# Get the groups on the site you connected to

$Groups = Get-PnPGroup

# Loop through each group

Foreach ($Group in $Groups){

    # Get Group Permissions and members

    $Permissions = Get-PnPGroupPermissions $Group
    $Members = Get-PnPGroupMember -Group $Group.Title 

    # Build the report

    $Summary = $Permissions + " ************************** " + $Members

    # Export the report using the group name as the file name

    $FilePath = $FolderPath + $Group.Title + ".txt"
    $Summary | Out-File -FilePath $FilePath -NoClobber 
}