jenkins_project
===============

A project agnostic way to programmatically set up a jenkins server on EC2 via StarCluster and create 'job's

Preqrequisistes

* starcluster installed to local machine
* jenkinsapi python package installed to local machine
* 'starcluster start -c $cluster_template' will successfully start an EC2 instance
	* We assume $cluster_template = $project_name unless you specify otherwise
* some directory exists with Jenkins job config files in XML format
	* We assume $config_dir = /path/to/jenkins_project/$project_name unless you specify otherwise
	* Job names are created from config filenames: ${job_name}.config.xml
 
To Run

    bash spin_up_jenkins_server $project_name [$config_dir]

