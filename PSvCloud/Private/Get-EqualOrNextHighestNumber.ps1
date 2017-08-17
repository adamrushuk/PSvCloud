function Get-EqualOrNextHighestNumber {
    <#
        .SYNOPSIS
        Returns an equal number or the next highest number from a given set of numbers.

        .DESCRIPTION
        Returns an equal number or the next highest number from a given set of numbers.
        If the set of acceptable numbers are "2, 4, 8, 16" then a value of 4 will return 4,
        and a value of 5 would return 8; the next highest in the set.

        .PARAMETER Number
        Specifies the number to test.

        .PARAMETER NumberSet
        Specifies an set of acceptable numbers.

        .INPUTS
        System.Int32
        System.Object[]

        .OUTPUTS
        System.Int32

        .EXAMPLE
        Get-EqualOrNextHighestNumber -Number 4 -NumberSet @(2, 4, 8, 16)

        Returns number 4.

        .EXAMPLE
        Get-EqualOrNextHighestNumber -Number 5 -NumberSet @(2, 4, 8, 16)

        Returns number 8.

        .NOTES
        Author: Adam Rush
        GitHub: adamrushuk
        Twitter: @adamrushuk
    #>
    [CmdletBinding()]
    [OutputType('System.Int32')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Int32]
        $Number,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Int32[]]
        $NumberSet
    )

    try {

        for ($i = 0; $i -lt $NumberSet.Count; $i++) {
            if ($Number -gt $NumberSet[$i]) {
                continue
            } else {
                return $NumberSet[$i]
            }
        }

    }
    catch [exception] {

        throw $_

    }

} # End function
