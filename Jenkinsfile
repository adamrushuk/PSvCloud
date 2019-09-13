pipeline {
  agent {
    node {
      label 'windows'
    }

  }
  stages {
    stage('Analyze') {
      steps {
        powershell '.\\build.ps1 -Task "Analyze"'
      }
    }
  }
}