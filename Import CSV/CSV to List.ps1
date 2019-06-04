# Connecting to the site where the list lives
Connect-PnPOnline -Url https://[Org].sharepoint.com/sites/[WhereListLives] -UseWebLogin #-Credentials:SharePointAdmin

# Location of the CSV
$csv = Import-Csv -path "C:\Path\To\Your.csv"

# This command loops the site creation for each row in the CSV
foreach ($row in $csv)
    {
        #Declare Variables row.[HeaderText] is how you pull the variable out of the row in the CSV
        $Title = $row.Center
        $User = $row.User
        $Number = $row.CenterNum
        $URL = $Row.URL

        #Add item to the list
        $list = Get-PnPList -Identity "[List Name]"
        $ListValues = @{"Title" = "$Title"; "[Column1]" = "$User"; "[Column2]" = "$URL"; "[Column3]" = "$Number"}
        Add-PnPListItem -List $list -ContentType "Item" -Values $ListValues
        "next"
    }