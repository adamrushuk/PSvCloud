<#
.SYNOPSIS
Exports the configuration of an vShield Edge.

.DESCRIPTION
Exports the configuration of an vShield Edge.
The XML file is saved to the location specified in Path.

.PARAMETER Name
Specifies an array of vShield Edge names.

.PARAMETER Path
Specifies the path to where the XML configuration file will be saved.

.EXAMPLE
Export-CIEdge_Controller.ps1 -Name 'Edge01'

.NOTES
Author: Adam Rush
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Path
)

<#
Connect-CIServer -Server 'api.vcd.portal.skyscapecloud.com' -Org '1-1-1-a4f57h'

Import-Module '.\PSvCloud\PSvCloud.psd1' -Force

$CIEdgeView = Get-CIEdgeView -Name $Name
$CIEdgeView

$CIEdgeXML = $CIEdgeView | Get-CIEdgeXML
$CIEdgeXML
#>
#$Name = 'nft001a4i2 -1'
#$Name = 'nft001a4i2 -1', 'nft00191i2-1'
#$Name = 'NameDoesNotExist'
$Name = 'NameDoesNotExist', 'nft001a4i2 -1'
$CIEdge = Get-CIEdge -Name $Name
$CIEdge