folder("jobs_folder")
freeStyleJob('jobs_folder/freestyle_child_job') 
{
        parameters{
	   stringParam(name:'user_name', default:"nikhil")
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
