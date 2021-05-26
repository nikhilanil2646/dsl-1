pipelineJob(jobname) {
        parameters {
               stringParam('GITLAB_REPOSITORY_URL', '', 'Set the Gitlab repository URL')
           }
        
   

        definition {
            cpsScm {
                scm {
                git {
                        remote {
                          url(repoUrl)
                          credentials('gitlab-test')
                    }
                     branches('master')
                     extensions {
                       cleanBeforeCheckout()
                    }
                      }
                    }
                    scriptPath("Jenkinsfile")
                  }
            }
        }