install_dir = "/opt/basho_riak_plugin-master"
plugin_uri = "https://github.com/basho/basho_riak_plugin/archive/master.zip"


# get plugin from github
remote_file "/opt/master.zip" do
  source plugin_uri
  owner "root"
  mode 0644
end


package "unzip" do
  action :upgrade
end

execute "unzip" do
	cwd "/opt"
	command "unzip master.zip"
	action :run
end


execute "ruby system_timer" do
	command "gem install system_timer"
	action :run
end

execute "ruby bundler" do
	command "gem install bundler"
	action :run
end

execute "install" do
	command "bundle install"
	cwd install_dir
	action :run
end


template "configure newrelic_plugin" do
	path "#{install_dir}/config/newrelic_plugin.yml"
	source "newrelic_riak_plugin.yml.erb"
	owner "root"
	group "root"
	mode 0644
	variables(
		:license => node['newrelic']['application_monitoring']['license'],
		:private_ip => node['ipaddress']
	)
end

=begin
template "configure riak_agent" do
	path "#{install_dir}/riak_agent.rb"
	source "riak_agent.rb.erb"
	owner "root"
	group "root"
	mode 0644
	variables(
		:guid => "com.rawiron.riak_agent"
	)
end
=end


# this should be in a init.d script
# good enough for testing
execute "start agent as daemon" do
	command "./riak_agent.rb &"
	cwd install_dir
	action :run
end
