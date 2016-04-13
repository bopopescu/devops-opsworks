if node[:cloud][:provider] == "ec2" and node[:cloud][:manager] == "opsworks"

	Chef::Log.info("cloud-opsworks : set cloud attributes")


	node.override[:cloud][:this_instance] = node[:opsworks][:instance]

	node.override[:cloud][:my_cpu] =
			Rawiron::Zookeeper::VirtualMachine.cpu(node[:opsworks][:instance][:instance_type])
	node.override[:cloud][:my_user_memory] = 
			Rawiron::Zookeeper::VirtualMachine.user_memory(node[:opsworks][:instance][:instance_type])


	node.override[:cloud][:layers] = node[:opsworks][:layers]
	Rawiron::Zookeeper::Layers.list_layers_by_key(node[:cloud][:layers])
	require 'json'
	Chef::Log.debug("cloud-opsworks : layers #{node[:cloud][:layers].to_json}")


	node.override[:cloud][:my_layer] = Rawiron::Zookeeper::Layers.my_layer(
																node[:cloud][:layers], 
																node[:cloud][:this_node], 
																node[:cloud][:this_instance])
	Chef::Log.debug("cloud-opsworks : this node is in layer #{node[:cloud][:my_layer]}")
	

	if Rawiron::Zookeeper::LoadBalancers.does_balance_for?(node[:cloud][:loadbalancers], "nginx", "uwsgi")
		node.override[:cloud][:nginx_lb_uwsgi] = true	   	
	end

	if node[:cloud][:nginx_lb_uwsgi] and node[:cloud][:my_layer] == "nginx"	   
		node.override[:cloud][:uwsgi_instances] = 
								Rawiron::Zookeeper::Layers.get_instances(node[:cloud][:layers], 'djangoapp')
	else
		node.override[:cloud][:uwsgi_instances] = {node[:cloud][:this_node] => {:private_ip => "127.0.0.1"}}
	end


	if Rawiron::Zookeeper::LoadBalancers.does_balance_for?(node[:cloud][:loadbalancers], "haproxy", "nginx") and
		node.override[:cloud][:haproxy_lb_nginx] = true
	end

	if node[:cloud][:haproxy_lb_nginx] and node[:cloud][:my_layer] == "httplb"	
		node.override[:cloud][:nginx_instances] = 
								Rawiron::Zookeeper::Layers.get_instances(node[:cloud][:layers], 'nginx')
	else
		node.override[:cloud][:nginx_instances] = {node[:cloud][:this_node] => {:private_ip => "127.0.0.1"}}
	end	


	node.override[:cloud][:memcached_instances] = Rawiron::Zookeeper::Layers.memcached_info(
																node[:cloud][:this_instance], 
																node[:cloud][:layers], 
																node[:rawiron])

	node.override[:cloud][:innodb_memcache_instances] = Rawiron::Zookeeper::Layers.innodb_memcache_info(
																node[:cloud][:this_instance], 
																node[:cloud][:layers], 
																node[:rawiron])
	# use them all, for now
	# using memcached as cache and myql plugin as db will cause trouble
	node.override[:cloud][:memcache_api_instances] = 
							node[:cloud][:memcached_instances].merge(node[:cloud][:innodb_memcache_instances])


    db_settings = {}
	db_settings['username'] = ""
	db_settings['password'] = ""
	if not (node[:deploy].nil? or node[:deploy].empty?)
		application = nil
		node[:deploy].each do |app_name, deploy|
			if node[:deploy][app_name].include?("database")
				application = app_name
				break
			end
		end
		if not application.nil?
			Chef::Log.debug("cloud-opsworks : db user read from #{application}")
			db_settings['username'] = node[:deploy][application][:database][:username]
			db_settings['password'] = node[:deploy][application][:database][:password]
		else
			Chef::Log.debug("cloud-opsworks : no db user info found")
		end
	end

	mysql_master_instances = Rawiron::Zookeeper::Layers.get_instances(node[:cloud][:layers], 'db-master')
	
	if mysql_master_instances.empty?
		Chef::Log.debug("cloud-opsworks : found no mysql master instance")
	elsif mysql_master_instances.length > 1
		Chef::Log.error("cloud-opsworks : found more than 1 mysql master")
	else
		db_settings['host'] = mysql_master_instances["db-master1"]["private_ip"]
		require 'json'
		Chef::Log.debug("cloud-opsworks : mysql master instance #{mysql_master_instances.to_json}")
	end

	node.override[:cloud][:mysql_master] = Rawiron::Zookeeper::Layers.mysql_master_info(
												db_settings, node[:rawiron])


	node.override[:cloud][:riak_nodes] = Rawiron::Zookeeper::Layers.get_riak_cluster_info(
															node[:rawiron], node[:cloud][:layers])

	node.override[:cloud][:riak_instances] = Rawiron::Zookeeper::Layers.get_instances(
															node[:cloud][:layers], 'riaknode')

end

