jenkins_project
===============

A project agnostic way to programmatically set up a jenkins server on EC2 via StarCluster and create 'job's


## Prerequisites

* jenkinsapi, starcluster python packages installed to local machine
* `starcluster start -c $cluster_template` will successfully start an EC2 instance with all test requirements installed
	* We assume `$cluster_template` = `$project_name` unless you specify otherwise in `$config_dir/settings.sh`
* $config_dir exists with Jenkins job config files in XML format
	* We assume `$config_dir` = `/path/to/jenkins_project/$project_name` unless you specify otherwise at command line invocation of spin_up_jenkins_server.sh
	* Job names are created from config filenames.  Config filenames are assumed to be of the form `${job_name}.config.xml`
	* For info on Job setup, see [README_JOB.md](https://github.com/mit-probabilistic-computing-project/jenkins_project/blob/master/README_JOB.md)

 

## To Run

    bash spin_up_jenkins_server.sh $project_name [$config_dir]

## Setting up Security

After the machine is spun up, you should immediately follow Jenkins' [Standard Security Setup](https://wiki.jenkins-ci.org/display/JENKINS/Standard+Security+Setup) procedure.
* To allow anybody to view results, retain the 'Anonymous' user giving it only 'Read' permission in the 'Overall' and 'Job' categories.
* Retain the new username and password you create to pass to jenkins_utils.py with its `--username` and `--password` arguments.

**Failing to heed this warning may result in your EC2 machine being hijacked by bitcoin miners.**


## Extras

### Configure email.

* Go to \<EC2-HOSTNAME\>:8080/configure. Fill out
  * 'System Admin e-mail address' under Jenkins Location
  * The fields under the 'E-mail Notification' section
    * To use your own gmail account (only works with 2-factor authentication), under the 'E-mail Notification' section:
       * SMTP server: smtp.gmail.com
       * Click 'Advanced'
       * Check 'Use SMTP Authentication'
       * User Name: your gmail username
       * Password: your gmail password (application-specific if you use 2-factor authentication)
       * Check 'Use SSL'
       * add '465' to the text box labelled 'SMTP Port'

### Set up Github's "Jenkins (Git plugin)" service
* Browse to \<REPO-URL\>/settings/hooks
* Click "Configure services" button
* Click "Jenkins (Git plugin)"
* In the "Jenkins Url" text box, enter "http://\<EC2-HOSTNAME\>:8080"
* Click checkbox "Active"
* Click "Update settings" button
* Optionally: Click "Test Hook" button
    * You can veriy "it worked" by browsing to http://\<EC2-HOSTNAME\>:8080/job/\<JOBNAME\>/scmPollLog/?
    * If it worked, you should NOT see: "Polling has not run yet."

### Including link to jobs in Flowdock notifications

Flowdock notifcations must be set up on a [per job basis](https://github.com/mit-probabilistic-computing-project/jenkins_project/blob/master/README_JOB.md).

For Jenkins' Flowdock notifications to include a link back to the build its referring to, both "Jenkins URL" and  "System Admin e-mail address" must be set under "Manage Jenkins" -> "Configure System" -> "Jenkins Location" (http://\<HOSTNAME\>:8080/configure)

## Notes

The Jenkins user is set to use matplotlib's headless backend to prevent errors when matplotlib can't find a display

        mkdir -p ~/.matplotlib
        echo backend: Agg > ~/.matplotlib/matplotlibrc

## TODO/Needed features: 

* Programmatic configuration of Jenkins' email credentials, Jenkins' security, Github service hooks


