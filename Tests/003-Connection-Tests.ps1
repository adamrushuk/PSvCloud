$ProjectRoot = Resolve-Path "$PSScriptRoot\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
$ModuleName = Split-Path $ModuleRoot -Leaf
$ModulePath = (Join-Path $ModuleRoot "$ModuleName.psd1")
Import-Module $ModulePath -Force

# Load Private function
. "$ModuleRoot\Private\Test-CIConnection.ps1"

Describe "Connection Tests" {
    Context 'When no vCloud connections are present' {
        It 'Should throw an error using empty array' {
            {Test-CIConnection -DefaultCIServers @()} | Should throw "A connection with Connect-CIServer is required"
        }

        It 'Should throw an error using $null' {
            {Test-CIConnection -DefaultCIServers $null} | Should throw "A connection with Connect-CIServer is required"
        }
    }

    Context 'When more than one vCloud connection is present' {
        $Connections = @(
            [PSCustomObject]@{
                Name = 'vcloud01.example.com'
                User = 'User1'
                Org = 'Org1'
            },
            [PSCustomObject]@{
                Name = 'vcloud02.example.com'
                User = 'User2'
                Org = 'Org2'
            }
        )

        It 'Should throw an error' -Verbose {
            {Test-CIConnection -DefaultCIServers $Connections} | Should throw "Too many connections - A single connection with Connect-VIServer is required"
        }
    }
}
