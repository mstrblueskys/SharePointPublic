#############################################################################
#
#                   SharePoint site Creation
#                        by Matt Peterson
#                          1/31/2019
#
#      To do: include input steps to help with naming standards
#
#                         INSTRUCTIONS
#       1) Open Credential Manager by searching in start
#       2) Select "Windows Credentials" icon at the top
#       3) Click "Add a generic credential" button
#       4) Put "SharePointAdmin" in the Internet or network address box
#       5) Enter admin username (full email) and password
#       6) Click "OK"
#
#############################################################################

# Connecting to [Org] - will use Credential Manager to pull in Admin Credentials
Connect-PnPOnline -Url https://[Org].sharepoint.com -Credentials:SharePointAdmin

# Collect basic site information
""
$SiteName = Read-Host -Prompt 'What is your site name?'
$SiteURL = Read-Host -Prompt 'What is your site URL (No Spaces)?'
$AdminUser = Read-Host -Prompt 'Admin email address'
$RequestingUser = Read-Host -Prompt "Who requested this site?"
$HubSiteAssociation = Read-Host -Prompt "What Hub Site should this site be under?"
""

# Creating the Team Site
New-PnPTenantSite `
  -Title "$SiteName" `
  -Url "https://[Org].sharepoint.com/sites/$SiteURL" `
  -Description "New SharePoint Site" `
  -Owner "$AdminUser" `
  -Lcid 1033 `
  -Template "STS#3" `
  -TimeZone 11 `
  -Wait

$FullURL = "https://[Org].sharepoint.com/sites/$SiteURL"

Add-PnPHubSiteAssociation -Site $FullURL -HubSite $HubSiteAssociation

# Print out site details with spacing
""
"The $SiteName site has been setup."
""
"Site URL is https://[Org].sharepoint.com/sites/$SiteURL"
""
"The owner and admin for the site can be reached at $AdminUser"
""
