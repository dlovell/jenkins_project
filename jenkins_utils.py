#
#   Copyright (c) 2010-2014, MIT Probabilistic Computing Project
#
#   Lead Developers: Dan Lovell and Jay Baxter
#   Authors: Dan Lovell, Baxter Eaves, Jay Baxter, Vikash Mansinghka
#   Research Leads: Vikash Mansinghka, Patrick Shafto
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#!python
import argparse
import jenkinsapi.jenkins
import jenkinsapi.job


def get_jenkins_obj(base_url):
	jenkins_obj = jenkinsapi.jenkins.Jenkins(base_url)
	return jenkins_obj

def get_jenkins_job(base_url, job_name):
	jenkins_obj = get_jenkins_obj(base_url)
	jenkins_job = jenkins_obj.get_job(job_name)
	return jenkins_job

def get_existing_config(base_url, job_name):
	jenkins_job = get_jenkins_job(base_url, job_name)
	config = jenkins_job.get_config()
	return config

def update_existing_job_config(base_url, job_name, config):
	jenkins_job = get_jenkins_job(base_url, job_name)
	jenkins_job.update_config(config)
	return

def create_jenkins_job(base_url, job_name, config):
	jenkins_obj = get_jenkins_obj(base_url)
	jenkins_obj.create_job(job_name, config)
	return

def delete_jenkins_job(base_url, job_name):
	jenkins_obj = get_jenkins_obj(base_url)
	jenkins_obj.delete_job(job_name)
	return

def invoke(base_url, job_name):
	jenkins_job = get_jenkins_job(base_url, job_name)
	jenkins_job.invoke()
	return

def read_file(config_filename):
	config = None
	with open(config_filename) as fh:
		config = ''.join(line for line in fh)
	return config

def write_file(config, config_filename):
	with open(config_filename, 'w') as fh:
		fh.write(config)
	return


if __name__ == '__main__':
	parser = argparse.ArgumentParser()
	parser.add_argument('--base_url', default='http://localhost:8080', type=str)
	parser.add_argument('--job_name', default='crosscat-unit-tests', type=str)
	parser.add_argument('--config_filename', default='crosscat-unit-tests.config.xml', type=str)
	parser.add_argument('-create', action='store_true')
	parser.add_argument('-delete', action='store_true')
	parser.add_argument('-put', action='store_true')
	parser.add_argument('-get', action='store_true')
	parser.add_argument('-invoke', action='store_true')
	#
	args = parser.parse_args()
	base_url = args.base_url
	job_name = args.job_name
	config_filename = args.config_filename
	do_create = args.create
	do_delete = args.delete
	do_put = args.put
	do_get = args.get
	do_invoke = args.invoke
	#
	if do_create:
		config = read_file(config_filename)
		create_jenkins_job(base_url, job_name, config)
	elif do_delete:
		delete_jenkins_job(base_url, job_name)
	elif do_put:
		config = read_file(config_filename)
		update_existing_job_config(base_url, job_name, config)
	elif do_get:
		config = get_existing_config(base_url, job_name)
		write_file(config, config_filename)
	elif do_invoke:
		invoke(base_url, job_name)
	else:
		print 'no action specified'
