pipeline {
  agent any
  stages {
    stage('Analyze') {
      steps {
        powershell '.\\build.ps1 -Task "Analyze"'
      }
    }
  }
}