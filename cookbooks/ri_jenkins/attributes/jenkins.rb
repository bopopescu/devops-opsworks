node.override['jenkins']['server']['port'] = 8081
node.override['jenkins']['server']['url']  = 
		"http://#{node['jenkins']['server']['host']}:#{node['jenkins']['server']['port']}"

node.override['jenkins']['node']['home'] = "/var/lib/jenkins/data"


default['jenkins']['server']['ebs'] = true
default['jenkins']['server']['ec2_ebs_mount'] = '/vol/jenkins'
default['jenkins']['server'][:ec2_path] = '/vol/jenkins/data'