######################################################################################################
# 
# Create a Theme and add it to the tenant
# By Matt Peterson, May 2019
#
######################################################################################################

Connect-PnPOnline -Url https://[Org].sharepoint.com -Credentials:SharePointAdmin

# Theming can be developed automatically at the following URL:
# https://fabricweb.z5.web.core.windows.net/pr-deploy-site/refs/pull/9015/merge/theming-designer/index.html

# Set the PowerShell output to the variable 
$themeOne = @{
    "themePrimary" = "#ffba3c";
    "themeLighterAlt" = "#0a0702";
    "themeLighter" = "#291e0a";
    "themeLight" = "#4d3812";
    "themeTertiary" = "#997024";
    "themeSecondary" = "#e0a435";
    "themeDarkAlt" = "#ffc14f";
    "themeDark" = "#ffcb6b";
    "themeDarker" = "#ffd892";
    "neutralLighterAlt" = "#0b0000";
    "neutralLighter" = "#150202";
    "neutralLight" = "#250505";
    "neutralQuaternaryAlt" = "#2f0909";
    "neutralQuaternary" = "#370c0c";
    "neutralTertiaryAlt" = "#591f1f";
    "neutralTertiary" = "#c8c8c8";
    "neutralSecondary" = "#d0d0d0";
    "neutralPrimaryAlt" = "#dadada";
    "neutralPrimary" = "#ffffff";
    "neutralDark" = "#f4f4f4";
    "black" = "#f8f8f8";
    "white" = "#000000";
    }

# Adds the theme tennant wide
Add-PnPTenantTheme -Identity "Dark SharePoint Theme" -Palette $themeOne -IsInverted $false

Get-PnPSiteDesign 