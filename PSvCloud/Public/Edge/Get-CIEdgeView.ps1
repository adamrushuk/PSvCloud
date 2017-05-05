function Get-CIEdgeView {
    <#
    .SYNOPSIS
    Gets the Edge View.

    .DESCRIPTION
    Gets the Edge View using the Search-Cloud cmdlet.

    .PARAMETER Name
    Specify a single vShield Edge name. Use quotes if the name includes spaces.

    .INPUTS
    System.String

    .OUTPUTS
    VMware.VimAutomation.Cloud.Views.Gateway

    .EXAMPLE
    Get-CIEdgeView -Name 'Edge01'

    .NOTES
    Author: Adam Rush
    #>
    [CmdletBinding()]
    [OutputType('VMware.VimAutomation.Cloud.Views.Gateway')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
    )

    # Check for vcloud connection (User property sometimes clears when intermittent issues, so worth checking)
    if (-not $global:DefaultCIServers[0].User) {
        throw 'Please connect to vcloud before using this function, eg. Connect-CIServer vcloud'
    }

    # Find Edge
    try {
        $EdgeView = Search-Cloud -QueryType EdgeGateway -Name $Name | Get-CIView
    }
    catch [exception] {
        throw "An error occurred searching for Edge Gateway named '$Name'."
    }

    # Test for null object
    if ($null -eq $EdgeView) {
        throw "Edge Gateway named '$Name' not found."
    }

    # Test for 1 returned object
    if ($EdgeView.Count -gt 1) {
        throw 'More than 1 Edge Gateway found.'
    }

    return $EdgeView
}
