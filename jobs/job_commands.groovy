println "child job is successfully runned by child_job by user ${user_name}"
job('demo') {
    steps {
        shell('echo Hello World!')
    }
}

