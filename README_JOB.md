Managing jobs
==================

## Security

If you have [jenkins security](https://github.com/mit-probabilistic-computing-project/jenkins_project/blob/master/README.md#setting-up-security) set up, you will need to append `--username <username> --password <password>` to all the jenkins_utils.py commands below.

## Saving a Job programmatically

jenkins_utils.py can be used to save an already existing Job configuration as an XML file.  An example invocation:

    python jenkins_utils.py -get --base_url http://<EC2-HOSTNAME>:8080 --job_name <JOB_NAME_TO_SAVE> --config_filename <FILENAME_TO_SAVE_TO>

Keeping \<FILENAME_TO_SAVE\> allows you to programmatically create the same job on a new server


## Creating a Job programmatically (from a saved Job)

spin_up_jenkins_server.sh will programmatically create all job's specified by config files in `$config_dir` when it is run.  You can push up new jobs at any time with:

    python jenkins_utils.py -create --base_url http://<EC2-HOSTNAME>:8080 --job_name <JOB_NAME> --config_filename <SAVED_CONFIG_FILENAME>


## Creating a Job manually

Following the procedure below will create a basic job that

* uses git for version control
* builds when there's a push to Github
  * requires [Github's "Jenkins (Git plugin)"](https://github.com/mit-probabilistic-computing-project/jenkins_project/blob/master/README.md#set-up-githubs-jenkins-git-plugin-service) service to be enabled
* archives the entire project dir as well as all nosetest results
* sends email on failure
  * requires [Jenkins's "E-mail Notification"](https://github.com/mit-probabilistic-computing-project/jenkins_project/blob/master/README.md#configure-email) section to be filled out
* sends notifications to a Flowdock flow

----

* Access the Jenkins web interface at \<EC2-HOSTNAME\>:8080
  * you can determine your EC2-HOSTNAME with 'starcluster listclusters' from the machine you spun up the cluster
* click 'New Job' at the top left
* add '\<JOBNAME\>' to the text box labelled 'Job name'
* click the 'Build a free-style software project' radio button
* click the 'OK' button, a new window will open up to \<EC2-HOSTNAME\>:8080/job/\<JOBNAME\>/configure
   * Under teh 'Source Code Management' section:
      * Select the 'Git' radio button
      * Fill in the 'Repository URL' text box
      * Optionally specify 'Branches to build' to build ONLY when the specified branches are pushed to
   * Under the 'Build Triggers' section:
      * Select the 'Build when a change is pushed to Github' checkbox AND the 'Poll SCM' checkbox
         * These two actions combined are required to only build the branches specified by 'Branches to build'
      * Optionally specify a build schedule if you want period builds regardless of commit actions
         * "H(0-9) 0 * * *" will build nightly at some randomzed minute after midnight
   * Under the 'Build' section:
      * Click 'Add build step'
      * select 'Execute shell' from the drop down
      * In the text box labelled 'Command', insert whatever commands are necessary to test.  Working directory is the root dir of the repo being tested
         * If you have to rebuild your software, you must include that here
   * Under the 'Post-build Actions' section:
      * Add an archiving action
         * Click 'Add post-build action'
         * select 'Archive the artifacts' from the drop down
         * add '**/*.*' to the text box labelled 'Files to archive'
      * Add a junit report action
         * Click 'Add post-build action'
         * select 'Publish JUnit test result report' from the drop down
         * add '**/nosetests.xml' to the text box labelled 'Test report XMLs'
      * Add an email action
         * Click 'Add post-build action'
         * select 'Email Notification' from the drop down
         * add '\<PROJECT-NAME\>-dev@mit.edu' to the text box labelled 'Recipients'
      * Add a Flowdock action
         * **NOTE**: the Flowdock token should not be included in content of saved job configs
         * go to flowdock tokens page: https://www.flowdock.com/account/tokens
         * copy the desired **flow** token
         * Click 'Add post-build action'
         * paste desired flow token into ‘Flow API token(s)’ box
   * Click 'Save' (at the bottom) to save your configuration.
