function Get-CIVMPrice {
    <#
        .SYNOPSIS
        Retrieves pricing options for vCloud VMs.

        .DESCRIPTION
        Retrieves pricing options for vCloud VMs, by comparing it's CPU count and Memory against a pricing
        matrix for different tiers.

        .PARAMETER CIVM
        One or more vCloud VM objects.

        .PARAMETER PricingMatrix
        A hashtable pricing matrix for different tiers, with the keys being a concatenation of CPU count and
        Memory in GB.

        .INPUTS
        System.Object

        .OUTPUTS
        PSCustomObject

        .EXAMPLE
        Get-CIVM | Get-CIVMPrice

        Returns prices for all CIVMs.

        .EXAMPLE
        Get-CIVMPrice -CIVM $CIVM01, $CIVM02

        Returns prices for two CIVMs.

        .NOTES
        Author: Adam Rush
    #>
    [CmdletBinding()]
    [OutputType('PSCustomObject')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Object[]]
        $CIVM,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [hashtable]
        $PricingMatrix = @{
            10 = @{Size = 'Micro'; Essential = 0.01; Power = 0.02; Priority = 0.03}
            12 = @{Size = 'Tiny'; Essential = 0.03; Power = 0.09; Priority = 0.135}
            24 = @{Size = 'Small'; Essential = 0.04; Power = 0.12; Priority = 0.18}
            48 = @{Size = 'Medium'; Essential = 0.06; Power = 0.22; Priority = 0.33}
            416 = @{Size = 'Medium High Memory'; Essential = 0.14; Power = 0.35; Priority = 0.520}
            816 = @{Size = 'Large'; Essential = 0.18; Power = 0.45; Priority = 0.675}
            832 = @{Size = 'Large High Memory'; Essential = 0.35; Power = 0.55; Priority = 1.125}
            848 = @{Size = 'Tier 1 Apps Small'; Essential = 0.50; Power = 0.60; Priority = 1.575}
            864 = @{Size = 'Tier 1 Apps Medium'; Essential = 0.70; Power = 0.99; Priority = 2.085}
            896 = @{Size = 'Tier 1 Apps Large'; Essential = 0.95; Power = 1.45; Priority = 2.675}
            12128 = @{Size = 'Tier 1 Apps Extra Large'; Essential = 1.30; Power = 2.30; Priority = 'NA'}
        }
    )

    Begin {}

    Process {

        try {

            foreach ($VM in $CIVM) {

                $MemoryGBRounded = [math]::Round( $VM.MemoryGB )
                $PricingMatrixKey = [int]"$($VM.CpuCount)$MemoryGBRounded"

                [PSCustomObject]@{
                    Org       = $VM.Org
                    OrgVdc    = $VM.OrgVdc
                    vApp      = $VM.vApp
                    Name      = $VM.Name
                    Status    = $VM.Status
                    CpuCount  = $VM.CpuCount
                    MemoryGB  = $VM.MemoryGB
                    Size      = $PricingMatrix[$PricingMatrixKey].Size
                    Essential = $PricingMatrix[$PricingMatrixKey].Essential
                    Power     = $PricingMatrix[$PricingMatrixKey].Power
                    Priority  = $PricingMatrix[$PricingMatrixKey].Priority
                }

            }

        }
        catch [exception] {

            throw $_

        }

    } # End process

} # End function
