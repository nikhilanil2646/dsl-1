folder("jobs_folder")
freeStyleJob('freestyle_child_job') {
        parameters{
	   stringParam('JOB_NAME', '', 'Set the Gitlab repository URL')
	   stringParam('GITLAB_REPOSITORY_URL', '', 'Set the Gitlab repository URL')
			}
		steps {
			dsl {
			external('jobs/child_job')
			    }
			  }
		 }
