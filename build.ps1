# Default to Test during testing
param ($Task = 'Default')

# Grab nuget bits, install modules, set build variables, start build.
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null

Install-Module Psake, PSDeploy, BuildHelpers, VMware.PowerCLI -Force -AllowClobber
Install-Module Pester -RequiredVersion 4.0.2 -Force -AllowClobber
Import-Module Psake, PSDeploy, BuildHelpers, Pester -Force
Import-Module VMware.PowerCLI -Force | Out-Null

Set-BuildEnvironment

Invoke-psake -buildFile $ENV:BHProjectPath\psake.ps1 -taskList $Task -nologo
exit ( [int]( -not $psake.build_success ) )
