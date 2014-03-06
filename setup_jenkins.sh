#!/bin/bash
set -e
set -v


# settings
jenkins_plugins=(
	git
	github
	jenkins-flowdock-plugin
	)
jenkinsapi_version=0.1.13
jar_dir=/var/cache/jenkins/war/WEB-INF/
jenkins_uri=http://127.0.0.1:8080/


# Helper functions
function install_jenkins () {
	# per http://pkg.jenkins-ci.org/debian-stable/
	wget -q -O - http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key | sudo apt-key add -
	sudo echo "deb http://pkg.jenkins-ci.org/debian-stable binary/" >> /etc/apt/sources.list
	sudo apt-get update
	sudo apt-get install -y jenkins
}

function update_jenkins () {
	# https://gist.github.com/jedi4ever/898114
	wget http://updates.jenkins-ci.org/update-center.json -qO- | sed '1d;$d' > default.json
	curl -X POST -H "Accept: application/json" -d @default.json $jenkins_uri/updateCenter/byId/default/postBack --verbose
}

function install_jenkins_plugin () {
	plugin_name=$1
	plugin_dir=${jar_dir}/plugins/
	#
	rm ${plugin_dir}/${plugin_name}.hpi 2>/dev/null || true
	java -jar ${jar_dir}/jenkins-cli.jar -s $jenkins_uri install-plugin $plugin_name
	return 0
}

function restart_jenkins () {
	java -jar ${jar_dir}/jenkins-cli.jar -s $jenkins_uri safe-restart || true
	return 0
}

function wait_for_web_response () {
	set +e
	uri=$1
	wget $uri 2>/dev/null 1>/dev/null
	while [ $? -ne "0" ]
	do
		sleep 2
		wget $uri 2>/dev/null 1>/dev/null
	done
	set -e
	return 0
}


install_jenkins
# if you don't update, you can't install by short name
wait_for_web_response $jenkins_uri
update_jenkins
# make sure jenkins api available for job setup automation
pip install jenkinsapi==$jenkinsapi_version


# wait for jenkins to respond before installing
wait_for_web_response $jenkins_uri
# install plugins
for jenkins_plugin in ${jenkins_plugins[*]}; do
	install_jenkins_plugin $jenkins_plugin
done
# restart before continuing
restart_jenkins
# wait for jenkins to respond before returning
wait_for_web_response $jenkins_uri


# miscellaneous support operations
#
# set up headless matplotlib
jenkins_home=/var/lib/jenkins/
mkdir -p ${jenkins_home}/.matplotlib
echo backend: Agg > ${jenkins_home}/.matplotlib/matplotlibrc
chown -R jenkins $jenkins_home
#
# make sure jenkins can install python packages
python_dir=/usr/local/lib/python2.7/dist-packages
chown -R jenkins $python_dir

# make sure jenkins can install binaries
bin_dir=/usr/local/bin
chown -R jenkins $bin_dir
