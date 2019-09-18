Function Hold-Jobs {
    While ((Get-Job -State Running).count -gt 100) {
    start-sleep 2
    }
}

$csv = Import-Csv -path "U:\SiteCodes-All.csv"

foreach ($row in $csv)
    {
        $Title = $row.title
        $view = $row.view 
        $edt = $row.edt 
        $admin = $Row.admin 
        $own = $row.own 
        Hold-Jobs
        Start-Job -Name $row.title -ScriptBlock {
            $Titl = $args[1]
            $vie = $args[2] 
            $ed = $args[3]
            $admi = $args[4] 
            $ow = $args[5] 
            Connect-PnPOnline -Url https://yourorg.sharepoint.com/sites/str -UseWebLogin 
            $list = Get-PnPList -Identity "TestParallel"
            $ListValues = @{"Title" = "$titl"; "view" = "$vie"; "edt" = "$ed"; "admin" = "$admi"; "own" = "$ow"} 
            Add-PnPListItem -List $list -ContentType "Item" -Values $ListValues
        } -ArgumentList ($Title, $view, $edt, $admin, $own)
    }
