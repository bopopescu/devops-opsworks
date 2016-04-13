if node[:cloud][:provider] == "vagrant"

	Chef::Log.info("cloud-vagrant : set cloud attributes")

	custom_stack = nil
	if node[:rawiron][:stack].nil? or
			node[:rawiron][:stack][:db_servers].nil? or 
			node[:rawiron][:stack][:db_servers].empty?
		custom_stack = { :stack => {:db_servers => {:layer => "app", :engine => "sqlite"}} }
	else
		custom_stack = node[:rawiron]
	end
	database_connect = {:username => "root", :password => ""}

	node.override[:cloud][:mysql_master] = Rawiron::Zookeeper::Layers.mysql_master_info(database_connect, custom_stack)
	node.override[:cloud][:uwsgi_instances] = {node[:cloud][:this_node] => {:private_ip => "127.0.0.1"}}
	node.override[:cloud][:riak_instances] = [node[:cloud][:this_node_fqdn]]


	Chef::Log.info("cloud-vagrant : set deploy attributes")

	if node[:deploy].nil? or node[:deploy].empty?
		application = node[:rawiron][:app]
		node.set[:deploy][application] = {}
	end

	node[:deploy].each do |application, deploy|

	default[:deploy][application] = {
		:user => "deploy",
		:group => node[:rawiron][:web_group],
		:home => "/home/deploy",
		:environment => {"HOME" => "/home/deploy"},
		:shell => "/bin/bash",
		:deploy_to => "/srv/www/#{application}",
		:current_path => "/srv/www/#{application}/current",
		:document_root => '',
		:symlink_before_migrate => {},
		:action => 'deploy',
		:enable_submodules => true,
		:database => {:host => "", :port => 0, :username => "", :password => "", :database => ""},
	}

	end

end