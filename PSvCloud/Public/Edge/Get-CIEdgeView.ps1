function Get-CIEdgeView {
    <#
    .SYNOPSIS
    Gets the Edge View.

    .DESCRIPTION
    Gets the Edge View using the Search-Cloud cmdlet.

    .PARAMETER Name
    Specifies a single vShield Edge name.

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

    # Check for vcloud connection
    Test-CIConnection

    # Find Edge
    try {
        $EdgeView = Search-Cloud -QueryType EdgeGateway -Name $Name | Get-CIView
        Write-Output $EdgeView
    }
    catch [exception] {
        Write-Error "An error occurred searching for Edge Gateway named $Name."
    }
}
