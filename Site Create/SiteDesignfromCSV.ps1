#############################################################################
#
#           Custom template repeat site Creation from CSV
#                        by Matt Peterson
#                          8/12/2020
#
#############################################################################

# Connecting to Your Tenant - will use Credential Manager to pull in Admin Credentials
Connect-PnPOnline -Url https://[YourOrg].sharepoint.com -Credentials:SharePointAdmin

# Location of the CSV
$csv = Import-Csv -path "C:\Path\To\Your.csv"

# Set global variables - hardcoding the admin account. Will appear as "Company Admin" in the admin center
$AdminUser = '[YourEmail]'
# Hubbing this site will help us sort in the admin center - this is hardcoded
$hubURL = "https://[YourOrg].sharepoint.com/sites/Hub-NRD"
$version = 1
# This command loops the site creation for each row in the CSV
foreach ($row in $csv)
    {
        # Start a timer - more for testing than anything
        $StartTime = $(get-date)
        $version ++
        # The CSV has the headers of Center and Num, so we set the site variables on those columns
        $SiteName = $row."Center"
        $SiteNum = $row."Num"
        # Complete the rest of the variables
        $SiteURL = "NRD-$SiteNum"
        $group = "APP-SP-NRD-$SiteName-ViewOnly"   
        $fullURL = "https://[YourOrg].sharepoint.com/sites/$siteURL"
        # Set a site design script that includes the AD group that was created for this specific site
        $SiteDesignScript =@"
        {    
            '$schema': 'schema.json',
            'actions': [
                {
                    'verb': 'removeNavLink',
                    'displayName': 'Home',
                    'isWebRelative': true
                },
                {
                    'verb': 'removeNavLink',
                    'displayName': 'Pages',
                    'isWebRelative': true
                },
                {
                    'verb': 'removeNavLink',
                    'displayName': 'Documents',
                    'isWebRelative': true
                },
                {
                    'verb': 'removeNavLink',
                    'displayName': 'Notebook',
                    'isWebRelative': true
                },
                {
                    'verb': 'removeNavLink',
                    'url': '/_layouts/15/viewlsts.aspx',
                    'displayName': 'Site contents',
                    'isWebRelative': true
                },
                {
                    'verb': 'createSPList',
                    'listName': 'Reports',
                    'templateType': 101
                },
                {
                    'verb': 'addPrincipalToSPGroup',
                    'principal': 'SharePoint Page Admin',
                    'group': 'Owners'
                },
                {
                    'verb': 'addPrincipalToSPGroup',
                    'principal': '$group',
                    'group': 'Visitors'
                }
            ], 
                'bindata': { }, 
                'version': '$version'
            };
"@
        # Add the script to our tennant
        Add-PnPSiteScript -Title "For Loop" -Content $SiteDesignScript -Description "To be Removed"
        # Pull that script ID - it should be the only one
        $Script = Get-PnPSiteScript
        $ScriptID = $Script.ID
        # Set the script to our specific design called later in the script

        # Replace [IdentityGuid] with your custom Site Design GUID
        Set-PnPSiteDesign -Identity [IdentityGUID] -Title $SiteNum -SiteScriptIds $ScriptID
        "Create"
        # Creating the Team Site, 500MB in size
        New-PnPTenantSite `
            -Title "Network Partner $SiteName" `
            -Url "https://[YourOrg].sharepoint.com/sites/$siteURL" `
            -Owner "$AdminUser" `
            -TimeZone 11 `
            -Template "STS#3" `
            -Lcid 1033 `
            -RemoveDeletedSite `
            -StorageQuota 500 `
            -StorageQuotaWarningLevel 400 `
            -Wait
        
        # Pause for the site to assign proper security - without this the connect command fails
        "Created"
        Start-Sleep -s 20
        # Connect to the newly created site
        Connect-PnPOnline -Url https://[YourOrg].sharepoint.com/sites/$siteURL -Credentials:SharePointAdmin
        # Add the hub association
        Add-PnPHubSiteAssociation -Site https://[YourOrg].sharepoint.com/sites/$siteURL -HubSite https://[YourOrg].sharepoint.com/sites/Hub-NRD 
        "Hubbed"
        # Design creates Reports doc library, gives admin permissions to the AD group SharePoint page admin, removes nav links, and adds the center group
        Invoke-PnPSiteDesign -Identity [IdentityGUID]
        
        # Allow the site design to settle in - this step is for stability
        Start-Sleep -s 20
        "Designed"
        # Adds a single section - this is the workaround for not being able to use the Get-PnPClientSideComponent.
        # When you add the page section, it tricks the page. The template doesn't recognize anything yet on the page
        # so when we run this, SharePoint believes it's adding the section to an empty page and builds that, which
        # removes all the predefined but not yet completely associated web parts.
        Add-PnPClientSidePageSection -Page Home -SectionTemplate OneColumn -Order 1
        "Sectioned"
        Start-Sleep -s 20
        # Get the GUID for the Reports document library
        $list=Get-PnPList -Identity "Reports" 
        $listID=$list.ID
        # Add the Document Library web part to the section we added earlier.
        Add-PnPClientSideWebPart -Page Home -DefaultWebPartType "List" -Section 1 -Column 1 -WebPartProperties @{isDocumentLibrary="true";selectedListId="$listID"}
        "Library Part"
        Start-Sleep -s 20
        # Remove the site design we created
        Connect-PnPOnline -Url https://[YourOrg].sharepoint.com -Credentials:SharePointAdmin
        $Scripts = Get-PnPSiteScript | foreach {Remove-PnPSiteScript -Identity $_ -Force}
        # Get our "Lap" time for this loop
        $elapsedTime = $(get-date) - $StartTime
        $totalTime = "{0:HH:mm:ss}" -f ([datetime]$elapsedTime.Ticks)
        "$totalTime"
    }
