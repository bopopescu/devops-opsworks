require "socket"

install_dir = "/opt/newrelic_nginx_agent"
plugin_uri = "#{node[:rawiron][:backends_url]}/newrelic_nginx_agent.tar.gz"


# get plugin from github
remote_file "/opt/newrelic_nginx_agent.tar.gz" do
  source plugin_uri
  owner "root"
  mode 0644
end


execute "gunzip" do
	cwd "/opt"
	command "gunzip newrelic_nginx_agent.tar.gz"
	action :run
end

execute "untar" do
	cwd "/opt"
	command "tar -xvf newrelic_nginx_agent.tar"
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
	cwd install_dir	
	command "bundle install"
	action :run
end


template "configure newrelic_plugin" do
	path "#{install_dir}/config/newrelic_plugin.yml"
	source "newrelic_nginx_plugin.yml.erb"
	owner "root"
	group "root"
	mode 0644
	variables(
		:license => node['newrelic']['application_monitoring']['license'],
		:hostname => Socket.gethostname,
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


execute "start agent as daemon" do
	cwd install_dir	
	command "./newrelic_nginx_agent.daemon start"
	action :run
end
