Clear-Host
$ProjectRoot = Resolve-Path "$PSScriptRoot\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
$ModuleName = Split-Path $ModuleRoot -Leaf
$ModulePath = (Join-Path $ModuleRoot "$ModuleName.psd1")
Import-Module $ModulePath -Force -Verbose | Remove-Module -Force

$ModuleManifestName = "$($ModuleName).psd1"
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"
$ModuleManifestPath = (Join-Path $ModuleRoot $ModuleManifestName)

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        { $Result = Test-ModuleManifest -Path $ModuleManifestPath -ErrorAction Stop } | Should Not Throw
    }
}

Describe -Name 'Module Tests' {
    It -Name "Attempting to import the Module" -Test {
        $Module = Import-Module $ModulePath -Force -PassThru | Where-Object {$_.Name -eq $ModuleName}
        $Module.Name | Should be $ModuleName
    }
}

Describe "Comment-based help for $ModuleName" {

    $Functions = Get-Command -Module $ModuleName -CommandType Function

    foreach ($Func in $Functions) {
        $Help = Get-Help $Func.Name

        Context $Help.Name {
            it "Has Synopsis" {
                $Help.Synopsis | Should Not BeNullOrEmpty
            }

            it "Has Description" {
                $Help.Description | Should Not BeNullOrEmpty
            }

            foreach ($Parameter in $Help.Parameters.Parameter) {
                if ($Parameter -notmatch 'whatif|confirm') {
                    it "Has a Parameter description for '$($Parameter.Name)'" {
                        $Parameter.Description.Text | Should Not BeNullOrEmpty
                    }
                }
            }

            it "Has Inputs" {
                $Help.inputTypes | Should Not BeNullOrEmpty
            }

            it "Has Outputs" {
                $Help.returnValues | Should Not BeNullOrEmpty
            }

            it "Has Examples" {
                $Help.Examples | Should Not BeNullOrEmpty
            }
        }
    } # End foreach function
} # End Comment-based help
