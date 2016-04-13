module Rawiron
module Zookeeper


module Layers

	def self.list_layers_by_key(layers)
		layers.keys.each do |key|
			Chef::Log.debug("zookeeper : found layer #{key}")
		end
	end

	def self.layer_names(layers)
		layers.keys
	end

	def self.instances_in_layer(layers, shortname)	
		if layers.include?(shortname)
			return layers[shortname.to_sym][:instances]
		else
			return {}
		end
	end

	def self.list_instances(instances, layername)
		if instances.length > 0
			Chef::Log.debug("zookeeper : found #{instances.length} #{layername} instances")
			instances.each do |instance_name, instance|
				Chef::Log.debug("zookeeper : instance #{instance_name}: #{instance.to_json}")
			end
		else
			Chef::Log.debug("zookeeper : found 0 #{layername} nodes")
		end
	end

	def self.get_instances(layers, layername)
		instances = instances_in_layer(layers, layername)		
		if instances.length > 0
			list_instances(instances, layername)
			return instances
		else
			return {}
		end
	end

	def self.my_layer(layers, me, my_instance)
		my_layer = nil
		layer_names = layer_names(layers)
		layer_names.each do |layer_name|
			instances = get_instances(layers, layer_name)
			if instances.include?(me)
				my_layer = layer_name
				break
			end
		end
		if not my_layer
			my_layer = my_instance[:layers][0]
		end
		my_layer
	end


	def self.memcached_info(my_instance, layers, rawiron_config)
		memcached_instances = nil
		if rawiron_config[:stack][:cache_servers][:layer] == "app" and 
			 rawiron_config[:stack][:cache_servers][:engine] == "memcached"
			memcached_instances = {"localhost" => my_instance}
		else
			memcached_instances = get_instances(layers, 'memcached')
		end
		memcached_instances
	end


	def self.innodb_memcache_info(my_instance, layers, rawiron_config)
		innodb_memcache_instances = nil
		if rawiron_config[:stack][:cache_servers][:layer] == "app" and 
			 rawiron_config[:stack][:cache_servers][:engine] == "mysqlmemcachedplugin"
			innodb_memcache_instances = {"localhost" => my_instance}
		else
			innodb_memcache_instances = get_instances(layers, 'mysqlmemcachedplugin')
		end
		innodb_memcache_instances
	end


	def self._set_mysql_master(db_settings)
		mysql_master = {}
		mysql_master[:username] = "root"
		mysql_master[:password] = ""
		mysql_master[:port] = 3306
		mysql_master[:database] = nil
		mysql_master[:host] = nil		

		require 'json'
		Chef::Log.debug("zookeeper : db_settings #{db_settings.to_json}")

		if db_settings.nil?
			Chef::Log.debug("zookeeper : no mysql master info available")
			return mysql_master
		end

		if db_settings.include?("username")
			mysql_master[:username] = db_settings["username"]
		end

		if db_settings.include?("password")
			mysql_master[:password] = db_settings["password"]
		end

		if db_settings.include?("host")
			mysql_master[:host] = db_settings["host"]
		end

		if db_settings.include?("port")
			mysql_master[:port] = db_settings["port"]
		end

		if db_settings.include?("database")
			mysql_master[:database] = db_settings["database"]
		end

		require 'json'
		Chef::Log.debug("zookeeper : mysql master info #{mysql_master.to_json}")
		return mysql_master
	end


	def self._get_local_mysql_master_info(settings)
		mysql_master = _get_mysql_master_info(settings)

		if mysql_master[:host] != "127.0.0.1"
			mysql_master[:host] = "127.0.0.1"
			Chef::Log.debug("zookeeper : changed mysql master to #{mysql_master[:host]}")
		end		
		
		return mysql_master
	end	


	def self._get_mysql_master_info(settings)
		mysql_master = _set_mysql_master(settings)
		return mysql_master
	end


	def self.mysql_master_info(db_settings, rawiron_config)
		mysql_master = nil
		if rawiron_config[:stack][:db_servers][:layer] == "app" and 
			 rawiron_config[:stack][:db_servers][:engine] == "mysql"
			Chef::Log.debug("zookeeper : mysql master is local")
			mysql_master = _get_local_mysql_master_info(db_settings)
		elsif rawiron_config[:stack][:db_servers][:engine] != "mysql"
			mysql_master = nil
		else
			mysql_master = _get_mysql_master_info(db_settings)
		end

		if mysql_master.nil? or mysql_master[:host].nil?
			mysql_master = {}
			Chef::Log.debug("zookeeper : found no mysql master")
		else
			Chef::Log.debug("zookeeper : found #{mysql_master[:host]} as mysql master")
		end
		mysql_master
	end

	
	def self.get_riak_cluster_private_ip(layers)
		instances = instances_in_layer(layers, 'riaknode')
	
		if instances.length > 0
			riak_private_ips = []

			instances.each do |instance_name, instance|
				riak_private_ips.push(instance[:private_ip])
				Chef::Log.debug("zookeeper : instance #{instance_name}: #{instance.to_json}")
			end
			
			Chef::Log.debug("zookeeper : found #{riak_private_ips.length} riak nodes")
			Chef::Log.debug("zookeeper : nodes private ip are #{riak_private_ips.to_json}")
			return riak_private_ips
		
		else
			Chef::Log.debug("zookeeper : found 0 riak nodes")
			return []
		end
	end


	def self.get_riak_cluster_info(rawiron_config, layers)
		instances = instances_in_layer(layers, 'riaknode')
	
		if instances.length > 0
			riak_public_ips = []
			riak_nodes = []

			instances.each do |instance_name, instance|
				riak_public_ips.push(instance[:ip])
				riak_nodes.push("#{instance_name}.#{rawiron_config[:fqdn]}")
			end
			
			Chef::Log.debug("zookeeper : found #{riak_nodes.length} riak nodes")
			Chef::Log.debug("zookeeper : nodes name are #{riak_nodes.to_json}")
			Chef::Log.debug("zookeeper : nodes public ip are #{riak_public_ips.to_json}")
			return riak_nodes
		
		else
			Chef::Log.debug("zookeeper : found 0 riak nodes")
			return []
		end
	end

end # Layers

end # Zookeeper
end # Rawiron