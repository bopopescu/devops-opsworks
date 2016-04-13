include_recipe "jenkins::server"

if node['jenkins']['server']['ebs']
	include_recipe "ri_jenkins::ebs"
end

jenkins_plugin 'credentials'
jenkins_plugin 'shiningpanda'