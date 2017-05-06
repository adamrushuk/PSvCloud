param ($Task = 'Default')

# Grab nuget bits, install modules, set build variables, start build.
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null

# Install modules if required
$ModuleNames = @('Psake', 'PSDeploy', 'BuildHelpers', 'VMware.PowerCLI')
foreach ($ModuleName in $ModuleNames) {
    if (-not (Get-Module -Name $ModuleName -ListAvailable)) {
        Write-Verbose "$ModuleName module not installed. Installing from PSGallery..."
        Install-Module -Name $ModuleName -Force -AllowClobber
    }
}
Import-Module -Name $ModuleNames -Force

# Target latest version of Pester as older versions are bundled with OS
if (-not (Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -match '^4.'})) {
    Install-Module Pester -MinimumVersion '4.0.3' -Force -AllowClobber -ErrorAction Stop
}

Set-BuildEnvironment

Invoke-psake -buildFile $ENV:BHProjectPath\build.psake.ps1 -taskList $Task -nologo
exit ( [int]( -not $psake.build_success ) )
