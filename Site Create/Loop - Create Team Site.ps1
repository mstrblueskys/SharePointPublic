#############################################################################
#
#          Be the Match - SharePoint site Creation from CSV
#                        by Matt Peterson
#                          3/25/2019
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

# Connecting to NMDP - will use Credential Manager to pull in Admin Credentials
Connect-PnPOnline -Url https://[Org].sharepoint.com -Credentials:SharePointAdmin

# Location of the CSV
$csv = Import-Csv -path "C:\Path\to\your\sites.csv"

# Set global variables 
$AdminUser = Read-Host -Prompt 'Admin email address'
$RequestingUser = Read-Host -Prompt "Who requested this site?"

# This command loops the site creation for each row in the CSV
foreach ($row in $csv)
    {
        #The CSV has the headers of SiteName and SiteAddress, so we set the site variables on those columns
        $SiteName = $row."SiteName"
        $SiteURL = $row."SiteAddress"
        # Creating the Team Site
        New-PnPTenantSite `
        -Title "$SiteName" `
        -Url "https://[Org].sharepoint.com/sites/$SiteURL" `
        -Owner "$AdminUser" `
        -Lcid 1033 `
        -Template "STS#1" `
        -TimeZone 11 `
        -Wait

        # Site and Hubsite Variables, if necessary
        $fullsiteURL = "https://[Org].sharepoint.com/sites/$SiteURL"
        $hubURL = "https://[Org].sharepoint.com/sites/[Hubsite]"

        #Check variables
        "$fullsiteURL"
        "$hubURL"
        
        # Associate our new site to the created hubsite
        Add-PnPHubSiteAssociation -Site $fullsiteURL -HubSite $hubURL 

        # Print out site details with spacing
        "The $SiteName site has been setup."
        "Site URL is https://[Org].sharepoint.com/sites/$SiteURL"
    }