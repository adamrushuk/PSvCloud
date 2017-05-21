# PSake makes variables declared here available in other scriptblocks
Properties {
    $ProjectRoot = $ENV:BHProjectPath
    if (-not $ProjectRoot) {
        $ProjectRoot = $PSScriptRoot
    }

    $Timestamp = Get-date -uformat "%Y%m%d-%H%M%S"
    $PSVersion = $PSVersionTable.PSVersion.Major
    $lines = '----------------------------------------------------------------------'

    $Verbose = @{}
    if ($ENV:BHCommitMessage -match "!verbose") {
        $Verbose = @{Verbose = $True}
    }

    # Pester
    $TestRootDir = "$ProjectRoot\Tests"
    $TestScripts = Get-ChildItem "$ProjectRoot\Tests\*Tests.ps1"
    $TestFile = "TestResults_PS$PSVersion`_$TimeStamp.xml"

    # Script Analyzer
    [ValidateSet('Error', 'Warning', 'Any', 'None')]
    $ScriptAnalysisFailBuildOnSeverityLevel = 'None'
    $ScriptAnalyzerSettingsPath = "$ProjectRoot\PSScriptAnalyzerSettings.psd1"
}

Task Default -Depends Test

Task Init {
    $lines
    Set-Location $ProjectRoot
    "Build System Details:"
    Get-Item ENV:BH*
    "`n"
}

Task Analyze -Depends Init {

    $Results = Invoke-ScriptAnalyzer -Path $ENV:BHModulePath -Recurse -Settings $ScriptAnalyzerSettingsPath -Verbose:$VerbosePreference
    $Results | Select-Object RuleName, Severity, ScriptName, Line, Message | Format-List

    switch ($ScriptAnalysisFailBuildOnSeverityLevel) {

        'None' {

            return

        }
        'Error' {

            Assert -conditionToCheck (
                ($Results | Where-Object Severity -eq 'Error').Count -eq 0
            ) -failureMessage 'One or more ScriptAnalyzer errors were found. Build cannot continue!'

        }
        'Warning' {

            Assert -conditionToCheck (
                ($Results | Where-Object {
                        $_.Severity -eq 'Warning' -or $_.Severity -eq 'Error'
                    }).Count -eq 0) -failureMessage 'One or more ScriptAnalyzer warnings were found. Build cannot continue!'

        }
        default {

            Assert -conditionToCheck ($analysisResult.Count -eq 0) -failureMessage 'One or more ScriptAnalyzer issues were found. Build cannot continue!'

        }

    }

}

Task Test -Depends Analyze {
    $lines
    "`nSTATUS: Testing with PowerShell $PSVersion"

    # Gather test results. Store them in a variable and file
    $TestResults = Invoke-Pester -Script $TestScripts -PassThru -OutputFormat NUnitXml -OutputFile "$ProjectRoot\$TestFile" -PesterOption @{IncludeVSCodeMarker = $true}

    # In Appveyor?  Upload our tests! #Abstract this into a function?
    if ($ENV:BHBuildSystem -eq 'AppVeyor') {
        (New-Object 'System.Net.WebClient').UploadFile(
            "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)",
            "$ProjectRoot\$TestFile" )
    }

    Remove-Item "$ProjectRoot\$TestFile" -Force -ErrorAction SilentlyContinue

    # Failed tests?
    # Need to tell psake or it will proceed to the deployment. Danger!
    if ($TestResults.FailedCount -gt 0) {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
    "`n"
}

Task Build -Depends Test {
    $lines

    # Load the module, read the exported functions, update the psd1 FunctionsToExport
    Set-ModuleFunctions -Name $env:BHPSModuleManifest

    # Bump the module version
    try {
        $Version = Get-NextPSGalleryVersion -Name $env:BHProjectName -ErrorAction Stop
        Update-Metadata -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -Value $Version -ErrorAction stop
    }
    catch {
        "Failed to update version for '$env:BHProjectName': $_.`nContinuing with existing version"
    }
}

Task Deploy -Depends Build {
    $lines

    $Params = @{
        Path    = "$ProjectRoot"
        Force   = $true
        Recurse = $false
    }
    Invoke-PSDeploy @Verbose @Params
}
