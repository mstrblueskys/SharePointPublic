######################################################################################################
# 
# Commit a site script and add it as a design
# By Matt Peterson, May 2019
#
######################################################################################################

# Get admin account
$admin = Read-Host "Username:"

# Connect to the site
Connect-SPOService -Url https://[Org]-admin.sharepoint.com -Credential:$admin

$siteScript = "Test Site Script"
$siteDesign = "Test Site Design"
$Description = "V 0.1 site design"

# Upload site script
Get-Content 'C:\Path\To\Site Script.json' -Raw | Add-SPOSiteScript -Title “$siteScript”

# Get the Script GUID
$scriptGUID = Read-Host -Prompt "Enter the ID from the previous step."

# Set the script as a design
Add-SPOSiteDesign -Title “$siteDesign” -WebTemplate "64"  -SiteScripts “f4ec828b-6d56-40bc-9c12-c31dd943fc3b”  -Description "$Description"
