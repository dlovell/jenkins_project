Instructions to create a Job on a Jenkins server
==================

Creating a Job manually

* Access the Jenkins web interface at \<EC2-HOSTNAME\>:8080
  * you can determine your EC2-HOSTNAME with 'starcluster listclusters' from the machine you spun up the cluster
* click 'New Job' at the top left
* add '\<JOBNAME\>' to the text box labelled 'Job name'
* click the 'Build a free-style software project' radio button
* click the 'OK' button, a new window will open up to \<EC2-HOSTNAME\>:8080/job/test-jobname/configure
   * Under the 'Build' section: 
      * Click 'Add build step'
      * select 'Execute shell' from the drop down
      * add 'bash jenkins/jenkins_script.sh' to the text box labelled 'Command'
        * a branch named \<BRANCH_NAME\> can be tested by appending '-b \<BRANCH_NAME\>'
   * Under the 'Post-build Actions' section:
      * Click 'Add post-build action'
      * select 'Archive the artifacts' from the drop down
      * add '**/*.*' to the text box labelled 'Files to archive'
      * Click 'Add post-build action'
      * select 'Publish JUnit test result report' from the drop down
      * add '**/nosetests.xml' to the text box labelled 'Test report XMLs'
      * Click 'Add post-build action'
      * select 'Email Notification' from the drop down
      * add '\<PROJECT-NAME\>-dev@mit.edu' to the text box labelled 'Recipients'
   * Click 'Save' (at the bottom) to save your configuration.

----

Creating a Job programmatically from a config XML file

