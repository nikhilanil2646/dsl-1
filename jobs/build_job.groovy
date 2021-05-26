folder("jobs_folder")
freeStyleJob('jobs_folder/freestyle_child_job') {
        parameters{
	   stringParam('JOB_NAME', '', 'Set the Gitlab repository URL')
	   stringParam('GITLAB_REPOSITORY_URL', '', 'Set the Gitlab repository URL')
	          }
		 scm {
	  git {
	   remote {
	   url 'https://github.com/nikhilanil2646/dsl-1' 
	         }
	  branch 'master'
              }

		steps {
			dsl {
			external('jobs/job_commands.groovy')
			    }
		      }
}
