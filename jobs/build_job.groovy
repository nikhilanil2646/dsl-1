folder("jobs_folder")
freeStyleJob('jobs_folder/freestyle_child_job') {
        parameters{
	   stringParam('user_name', '', 'Enter the username')
	          }
		 scm {
	  git {
	   remote {
	   url 'https://github.com/nikhilanil2646/dsl-1' 
	         }
	  branch 'master'
              }

		    }
		steps {
			dsl {
			external('jobs/job_commands.groovy')
			    }
		      }
}
