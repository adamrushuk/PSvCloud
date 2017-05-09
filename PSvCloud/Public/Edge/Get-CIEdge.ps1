function Get-CIEdge {
    <#
    .SYNOPSIS
    Retrieves vCloud Edges.

    .DESCRIPTION
    Retrieves vCloud Edges, including View and XML configuration.

    .PARAMETER Name
    Specifies the name of the vShield Edges you want to retrieve.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSCustomObject

    .EXAMPLE
    Get-CIEdge -Name 'Edge01'

    .EXAMPLE
    Get-CIEdge -Name 'Edge01', 'Edge02'

    .NOTES
    Author: Adam Rush
    #>
    [CmdletBinding()]
    [OutputType('System.Management.Automation.PSCustomObject')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Name
    )

    Begin {
        # Check for vcloud connection
        Test-CIConnection
    }

    Process {

        foreach ($EdgeName in $Name) {

            # Get Edge details
            try {
                $CIEdgeView = Get-CIEdgeView -Name $EdgeName

                # Validation checks
                # Test for null object
                if ($null -eq $CIEdgeView) {
                    throw "Edge Gateway named $EdgeName not found."
                }
                # Test for 1 returned object
                if ($CIEdgeView.Count -gt 1) {
                    throw "More than 1 Edge Gateway found for $EdgeName."
                }

                # Get Edge XML Configuration
                $CIEdgeXML = $CIEdgeView | Get-CIEdgeXML

                # Output to pipeline
                [PSCustomObject]@{
                    Name = $CIEdgeView.Name
                    Href = $CIEdgeView.Href
                    Id = $CIEdgeView.Id
                    ExtensionData = $CIEdgeView
                    XML = $CIEdgeXML
                }
            }
            catch [exception] {
                Write-Error $_
            }

        } # End foreach

    } # End process

} # End function
