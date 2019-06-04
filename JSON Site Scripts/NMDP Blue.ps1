Connect-PnPOnline -Url https://[Org].sharepoint.com -Credentials:SharePointAdmin

# Theming can be developed automatically at the following URL:
# https://fabricweb.z5.web.core.windows.net/pr-deploy-site/refs/pull/9015/merge/theming-designer/index.html

# Set the PowerShell output to the variable 
$themeOne = @{
        "themePrimary" = "#0079c1";
        "themeLighterAlt" = "#f2f9fd";
        "themeLighter" = "#cee7f5";
        "themeLight" = "#a6d3ed";
        "themeTertiary" = "#57aada";
        "themeSecondary" = "#1888c9";
        "themeDarkAlt" = "#006eae";
        "themeDark" = "#005d93";
        "themeDarker" = "#00456d";
        "neutralLighterAlt" = "#f8f8f8";
        "neutralLighter" = "#f4f4f4";
        "neutralLight" = "#eaeaea";
        "neutralQuaternaryAlt" = "#dadada";
        "neutralQuaternary" = "#d0d0d0";
        "neutralTertiaryAlt" = "#c8c8c8";
        "neutralTertiary" = "#d4ccc7";
        "neutralSecondary" = "#a99c94";
        "neutralPrimaryAlt" = "#817369";
        "neutralPrimary" = "#706259";
        "neutralDark" = "#554a43";
        "black" = "#3f3732";
        "white" = "#ffffff";
        }

# Adds the theme tennant wide
Add-PnPTenantTheme -Identity "NMDP Blue Theme" -Palette $themeOne -IsInverted $false

Get-PnPSiteDesign 