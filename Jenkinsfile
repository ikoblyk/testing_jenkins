pipeline {
   agent any
   tools {
      maven "mvn_auto"
   }

   stages {
  
        stage('Build') {
         steps {
             sh "cd DEMO2 && ./script.sh && ls && echo 'done!'"

         }
        }
      stage("Wipe Workspace") {
         steps {
            deleteDir()
         }
      }
}
}