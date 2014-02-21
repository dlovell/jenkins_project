#!/bin/bash
set -e
set -v


# modifiable setings
project_name=$1
config_dir=$2
if [ -z $project_name ]; then
	echo "!!! $0: project_name must NOT be blank"
	echo "!!! $0: project_name must NOT be blank"
	exit 1
fi
if [ -z $config_dir ]; then
	config_dir=$project_name
fi


# everything is relative to this script's dir
this_script_abs_path=$(readlink -f "$0")
this_script_dirname=$(dirname $this_script_abs_path)
cd $this_script_dirname


settings_script=$config_dir/settings.sh
jenkins_setup_script=setup_jenkins.sh
jenkins_utils_script=jenkins_utils.py
open_port_script=open_master_port_via_starcluster_shell.py
config_filename_suffix=.config.xml
#
jenkins_project_name=jenkins_project
probcomp_base_uri=https://github.com/mit-probabilistic-computing-project
jenkins_repo_uri=$probcomp_base_uri/$jenkins_project_name


# set some defaults
cluster_name=${project_name}_jenkins
cluster_template=$project_name
instance_type=c1.xlarge
num_intances=1
# pull from project settings.sh if it exists
if [ -f $settings_script ]; then
	. $settings_script
fi


# spin up the cluster
starcluster start -c $cluster_template -i $instance_type -s $num_intances $cluster_name
hostname=$(starcluster listclusters $cluster_name | grep master | awk '{print $NF}')
# bypass key checking
ssh -o PasswordAuthentication=no -o StrictHostKeyChecking=no jenkins@$hostname exit || true


# open up the port for jenkins
starcluster shell < <(perl -pe "s/'crosscat'/'$cluster_name'/" $open_port_script)
# set up jenkins
starcluster sshmaster $cluster_name "(git clone $jenkins_repo_uri)"
starcluster sshmaster $cluster_name bash $jenkins_project_name/$jenkins_setup_script


# push up jenkins configuration
# jenkins server must be up and ready
jenkins_uri=http://$hostname:8080
for config_filename in $config_dir/*$config_filename_suffix; do
	job_name=$(basename ${config_filename%$config_filename_suffix})
	python $jenkins_utils_script \
	--base_url $jenkins_uri \
	--config_filename $config_filename \
	--job_name $job_name \
	-create
done


# notify user what hostname is
echo $hostname
