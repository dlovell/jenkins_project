jenkins_project
===============

A project agnostic way to programmatically set up a jenkins server on EC2 via StarCluster and create 'job's


## Preqrequisistes

* starcluster installed to local machine
* jenkinsapi python package installed to local machine
* 'starcluster start -c $cluster_template' will successfully start an EC2 instance
	* We assume $cluster_template = $project_name unless you specify otherwise
* some directory exists with Jenkins job config files in XML format
	* We assume $config_dir = /path/to/jenkins_project/$project_name unless you specify otherwise
	* Job names are created from config filenames: ${job_name}.config.xml
 

## To Run

    bash spin_up_jenkins_server $project_name [$config_dir]


## Extras

* Configure email.

  * Go to \<EC2-HOSTNAME\>:8080/configure. Fill out the forms under the 'E-mail Notification' section
  * To use your own gmail account (only works with 2-factor authentication):
       * Sender E-mail Address: your address FIXME: is this 'System Admin e-mail address' under Jenkins Location?
       * SMTP server: smtp.gmail.com
       * Click "Advanced"
       * Check 'Use SMTP Authentication'
       * User Name: your gmail username
       * Password: your gmail password (application-specific if you use 2-factor authentication)
       * Check 'Use SSL'
       * add '465' to the text box labelled 'SMTP Port'
  * To do this in a smarter way (recommended): set up a different mail server and enter its information.

* Setting up Git Commit Hook
	* Install Github plugin. Enter the URL for the repository, and ensure that the jenkins users' ssh keys are added on github.
	* On Github, click on the repository settings, and add a post-receive hook. Click the github plugin page, and add the url for the jenkins server, appended with "/github-webhook/".


## Notes

The Jenkins user is set to use matplotlib\'s headless backend to prevent errors when matplotlib can't find a display

        mkdir -p ~/.matplotlib
        echo backend: Agg > ~/.matplotlib/matplotlibrc

## TODO/Needed features: 

* Using ssh keys instead of plaintext password in source (probcomp-reserve's password)


