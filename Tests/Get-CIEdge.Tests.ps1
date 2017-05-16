Describe 'CIEdge Tests' {
    Context 'Input' {
        It 'Should throw an error using empty array' {
            {Test-CIConnection -DefaultCIServers @()} | Should throw "A connection with Connect-CIServer is required"
        }

        It 'Should throw an error using $null' {
            {Test-CIConnection -DefaultCIServers $null} | Should throw "A connection with Connect-CIServer is required"
        }
    }

    Context 'Execution' {

    }
    Context 'Output' {

    }
}