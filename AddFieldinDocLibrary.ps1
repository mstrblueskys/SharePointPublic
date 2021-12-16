#######################################
#
#  Add fields to doc libraries
#   12.16.21 // Matt Peterson
#
######################################


# Connect to SharePoint
# Documentation link: https://pnp.github.io/powershell/cmdlets/Connect-PnPOnline.html
Connect-PnPOnline "https://yourtenant.sharepoint.com" -UseWebLogin

# Get All hubbed sites 
# Documentation link: https://pnp.github.io/powershell/cmdlets/Get-PnPHubSiteChild.html
$Sites = Get-PnPHubSiteChild -Identity "https://yourtenant.sharepoint.com/sites/hubsite"

# Loop through the hubbed sites
Foreach ($Site in $Sites){
    #Get the hubbed site URL
    $childURL = $Site.Url
    #Connect to that specific site
    Connect-PnPOnline $childURL -UseWebLogin
    
    # Get only document library lists
    # Documentation: https://pnp.github.io/powershell/cmdlets/Get-PnPList.html 
    $Lists = Get-PnPList | Where-Object {$_.BaseTemplate -eq 101 -and $_.Hidden -eq $false}

    # Loop through each document library in the specific site
    Foreach ($List in $Lists){
        Add-PnPField -List $List -Field "FieldName" -Type Text
        # For list of field types go to: https://docs.microsoft.com/en-us/dotnet/api/microsoft.sharepoint.client.fieldtype?view=sharepoint-csom
        # Using Command: https://pnp.github.io/powershell/cmdlets/Add-PnPField.html
    }
}
