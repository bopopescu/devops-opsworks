Chef::Log.info("ganglia : install plugin")


this_node = node[:cloud][:this_node]
Chef::Log.debug("ganglia : this node is #{this_node}")

my_layer = node[:cloud][:my_layer]
Chef::Log.debug("ganglia : this node is in layer #{my_layer}")

case my_layer
when "mysql"
	Chef::Log.info("ganglia : enable mysql")
	include_recipe "ri_ganglia::mysqld_opsworks_enable"

when "nginx"
	Chef::Log.info("ganglia : install nginx plugin")
	include_recipe "ri_ganglia::nginx_plugin"

when "memcached"
	Chef::Log.info("ganglia : enable memcached")
	include_recipe "ri_ganglia::memcached_opsworks_enable"

when "riak"
	Chef::Log.info("ganglia : enable riak")
	include_recipe "ri_ganglia::riak_opsworks_enable"

when "mysqlmemcachedplugin"
	Chef::Log.info("ganglia : enable mysql-memcached")
	include_recipe "ri_ganglia::memcached_opsworks_enable"
	include_recipe "ri_ganglia::mysqld_opsworks_enable"

when "djangoapp"
	Chef::Log.info("ganglia : install plugins")
	include_recipe "ri_ganglia::nginx_plugin"
	include_recipe "ri_ganglia::uwsgi_plugin"

else
	Chef::Log.info("ganglia : no plugin found for this layer")
end


include_recipe 'opsworks_ganglia::monitor-fd-and-sockets'
include_recipe 'opsworks_ganglia::monitor-disk'


Chef::Log.info("ganglia : done install plugin")