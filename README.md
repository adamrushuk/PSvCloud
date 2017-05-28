# PSvCloud
[![Build status](https://ci.appveyor.com/api/projects/status/4n5tvb1qj1ieq4jv?svg=true)](https://ci.appveyor.com/project/adamrushuk/psvcloud)

A PowerShell module for VMware vCloud Director.

## Goals
I've created various scripts for vCloud Director over the past few years, so
I plan to use this module as an opportunity to refactor and share these scripts, applying the latest methods and best practices I've learnt recently around [The Release Pipeline Model](https://msdn.microsoft.com/en-us/powershell/dsc/whitepapers#the-release-pipeline-model) (Source > Build > Test > Release).

### Source
Use Git with a popular [branching model](http://nvie.com/posts/a-successful-git-branching-model/) geared towards collaboration.

### Build
Use [psake](https://github.com/psake/psake) to develop build scripts that can be used both locally using [Task Runners in Visual Studio Code](https://code.visualstudio.com/docs/editor/tasks), and by a CI/CD system like [Appveyor](https://www.appveyor.com).

### Test
Use [Pester](https://github.com/pester/Pester) for Unit Testing.

### Release
Configure [Appveyor](https://www.appveyor.com) for Continuous Integration / Continuous Deployment.
This should cover:
- Release to the [PowerShell Gallery](https://www.powershellgallery.com/packages/PSvCloud).
- Uploading created Artifacts as a [tagged Release in GitHub](https://github.com/adamrushuk/PSvCloud/releases)
- Automatically updating documentation to a 3rd-party like [ReadTheDocs](https://docs.readthedocs.io/en/latest/).
