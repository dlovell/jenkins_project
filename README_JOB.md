Instructions to create a Job on a Jenkins server
==================

Creating a Job manually

* Access the Jenkins web interface at \<EC2-HOSTNAME\>:8080
  * you can determine your EC2-HOSTNAME with 'starcluster listclusters' from the machine you spun up the cluster
* click 'New Job' at the top left
* add '\<JOBNAME\>' to the text box labelled 'Job name'
* click the 'Build a free-style software project' radio button
* click the 'OK' button, a new window will open up to \<EC2-HOSTNAME\>:8080/job/test-jobname/configure
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
         * go to flowdock tokens page: https://www.flowdock.com/account/tokens
         * copy the desired **flow** token
         * Click 'Add post-build action'
         * paste desired flow token into ‘Flow API token(s)’ box
   * Click 'Save' (at the bottom) to save your configuration.

----

Creating a Job programmatically from a config XML file

