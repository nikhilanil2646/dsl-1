folder("jobs_folder")
freeStyleJob('jobs_folder/freestyle_child_job') 
{
        parameters{
	   stringParam('user_name', 'Enter your name')
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
 stage ("build") {		//an arbitrary stage name
            steps {
                build 'jobs_folder/freestyle_child_job'	//this is where we specify which job to invoke.
            }
        }
