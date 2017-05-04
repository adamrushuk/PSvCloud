$ProjectRoot = Resolve-Path "$PSScriptRoot\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psm1")
$ModuleName = Split-Path $ModuleRoot -Leaf
$ModulePath = (Join-Path $ModuleRoot "$ModuleName.psm1")
Import-Module $ModulePath -Force -Verbose

$ModuleManifestName = "$($ModuleName).psd1"
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"
$ModuleManifestPath = (Join-Path $ModuleRoot $ModuleManifestName)

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        $Result = Test-ModuleManifest -Path $ModuleManifestPath
        $Result | Should Be $true
    }
}

Describe -Name 'Module Tests' -Fixture {
    It -Name "Attempting to import the Module" -Test {
        $Module = Import-Module $ModulePath -Force -PassThru | Where-Object {$_.Name -eq 'PSvCloud'}
        $Module.Name | Should be "PSvCloud"
    }
}

Describe "Comment-based help for $ModuleName" -Tags Help {

    $Functions = Get-Command -Module $ModuleName -CommandType Function

    foreach ($Function in $Functions) {
        $Help = Get-Help $Function.Name

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
    }
}
